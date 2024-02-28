/*
    <Ʈ����>
    ���� ������ ���̺� INSERT, UPDATE, DELETE �� DML���� ���� ���� ������ ���� ��
    (���̺� �̺�Ʈ�� �߻����� ��) /���� �����Ͱ� ����Ǵ� ������ �߻��ϸ� �̺�Ʈ��� ��
    �ڵ����� �Ź� ������ ������ �̸� ������ �� �� ����
    / Ʈ���ŵ� ���� �� �ϳ�
    
    EX)
    ȸ�� Ż�� �� ������ ȸ�� ���̺��� ������ DELETE �� ��ٷ� Ż���� ȸ���鸸 ���� �����ϴ� ���̺�
    �ڵ����� INSERT ���Ѿ� ��
    / -> ������ �� ��, �Ź� �Ȱ��� ������ �� ���� ����� ��
    
    �Ű� Ƚ���� ���� ���� �Ѿ��� �� ���������� �ش� ȸ���� ������Ʈ�� �ö󰡵��� ó��
    -> UPDATE Ƚ�� Ȥ�� �Ű� ������ INSERT
    
    ����� ���� �����Ͱ� ���(INSERT)�� ������ �ش� ��ǰ�� ���� ��� ������ �Ź� ����(UPDATE)�ؾ� ��
    
    *Ʈ���� ����
    - SQL���� ���� �ñ⿡ ���� �з�
    > BEFORE TRIGGER : ���� ������ ���̺� �̺�Ʈ�� �߻��Ǳ� �ٷ� ������ Ʈ���� ����
    > AFTER TRIGGER : ���� ������ ���̺� �̺�Ʈ�� �߻��� �� Ʈ���� ����
    
    - SQL���� ���� ������ �޴� �� �࿡ ���� �з�
    > ���� Ʈ���� : �̺�Ʈ�� �߻��� SQL���� ���� �� �� ���� Ʈ���� ����
    > �� Ʈ���� : �ش� SQL�� ������ ������ �Ź� Ʈ���� ����
                (FOR EACH ROW �ɼ� ����ؾ� ��)
                > :OLD -BEFORE UPDATE(���� �� �ڷ�), BEFORE DELETE(���� �� �ڷ�)
                > :NEW -AFTER INSERT(�߰��� �ڷ�), AFTER UPDATE(���� �� �ڷ�)
                --/ �̶�� ������ �ڵ����� ����
    
    *Ʈ���� ���� ����
    
    [ǥ����]
    CREATE [OR REPLACE] TRIGGER Ʈ���Ÿ�
    BEFORE | AFTER              INSERT | UPDATE | DELETE    ON ���̺��
    [FOR EACH ROW] /� �������� ���
    [DECLARE ���� ����] /Ʈ���ſ� ���� PLSQL
    BEGIN / �̰ɷ� ���� Ʈ���� ����
        ���� ����(��� ���� ������ �̺�Ʈ �߻� �� ������(�ڵ�)���� ������ ����)
    [EXCEPTION ����ó��]
    END;
    /
*/

-- EMPLOYEE ���̺� ���ο� ���� INSERT �� ������ �ڵ����� ��µǴ� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('���Ի����, ȯ���մϴ�.');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES (500, '�̼���', '111111-1111111', 'D7', 'J7', SYSDATE);
--/ ���ԵǾ����ϴ� ������ ���� ���� �ð��� ���� ��� ����
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES (501, '������', '111111-1111111', 'D8', 'J8', SYSDATE);

------------------------------------------------------------------------------------
-- ��ǰ �԰� �� ��� ���� ����
--> �ʿ��� ���̺� �� ������ ����

-- 1. ��ǰ�� ���� �����͸� �����ϴ� ���̺� (TB_PRODUCT)
--DROP TABLE TB_PRODUCT;
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- ��ǰ ��ȣ
    PNAME VARCHAR2(30) NOT NULL, -- ��ǰ��
    BRAND VARCHAR2(30) NOT NULL, -- �귣��
    PRICE NUMBER, -- ����
    STOCK NUMBER DEFAULT 0 -- ���
);

SELECT * FROM TB_PRODUCT;

-- ��ǰ��ȣ �ߺ� �� �ǰԲ� �Ź� ���ο� ��ǰ ��ȣ�� �߻� ��Ű�� ���� ������ ����
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

-- ���� ������ �߰�
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '������24', '����', 1400000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '������15', '������15', 1300000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '�����', '�����', 700000, 20);

COMMIT; --/ ������ INSERT, UPDATE, DELETE �� ������ ���� ���׿� ���õ� ���� �ϸ� ������ Ŀ���ϴ� ����

-- 2. ��ǰ ����� �� �̷� ���̺� ����(TB_PRODETAIL)
-- � ��ǰ�� � ��¥�� �� ���� �԰� �Ǵ� ��� �Ǵ��� �����͸� ���
CREATE TABLE TB_PRODETAIL(
    DECODE NUMBER PRIMARY KEY, -- �̷� ��ȣ
    PCODE NUMBER REFERENCES TB_PRODUCT, -- ��ǰ ��ȣ
    PDATE DATE NOT NULL, -- �������
    AMOUNT NUMBER NOT NULL, -- ����� ����
    STATUS CHAR(6) CHECK(STATUS IN ('�԰�', '���')) -- ����(�԰�, ���)
);

SELECT * FROM TB_PRODETAIL;

-- �̷� ��ȣ �Ź� ���ο� ��ȣ�� �߻� ���� �� �� �ְ� ������ ������ ���� /��ü�� ���� ����, �� ��ü�� ����� ������
CREATE SEQUENCE SEQ_DECODE
NOCACHE;

-- 200�� ��ǰ�� ���� ��¥�� 10�� �԰�
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 200, SYSDATE, 10, '�԰�');

-- 200�� ��ǰ�� ��� ������ 10 ����
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT;

-- 205�� ��ǰ�� ���� ��¥�� 20�� �԰�
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 205, SYSDATE, 20, '�԰�');

-- 205�� ��ǰ�� ��� ������ 20 ����
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 205;

--/ �̰� �Ϻ��ϰ� ����������� ������ ����

-- TB_PRODETAIL ���̺� INSERT �̺�Ʈ �߻� ��
-- TB_PRODUCT ���̺� �Ź� �ڵ����� ������ UPDATE �ǰԲ� Ʈ���� �ۼ�
/*
    - ��ǰ�� �԰�� ��� -> �ش� ��ǰ�� ã�Ƽ� ��� ���� ���� UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK + ���� �԰�� ����(INSERT �� �ڷ� AMOUNT)
    WHERE PCODE = �԰�� ��ǰ ��ȣ(INSERT �� �ڷ��� PCODE);
    
        - ��ǰ�� ���� ��� -> �ش� ��ǰ�� ã�Ƽ� ��� ���� ���� UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK - ���� ���� ����(INSERT �� �ڷ� AMOUNT)
    WHERE PCODE = ���� ��ǰ ��ȣ(INSERT �� �ڷ��� PCODE);
*/
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW --/ OLD Ȥ�� NEW ������ ���ڴ�
BEGIN
    IF(/*�̰� ��ü�� Ʈ���� ���� �� ����� ����*/:NEW.STATUS = '�԰�')
        THEN  UPDATE TB_PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
    
    IF(:NEW.STATUS = '���')
        THEN UPDATE TB_PRODUCT
             SET STOCK = STOCK - :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

--/ ���� INSERT�� �� ���Ŀ� �ؾ���, INSERT �Ǿ� ������ �����͸� �����ͼ� �� ���̱� ������
--/ ���� ������ DELETE�� ����

-- 210�� ��ǰ�� ���� ��¥�� 7�� ���
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 210, SYSDATE, 7, '���');

-- 210�� ��ǰ�� ���� ��¥�� 100�� �԰�
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 200, SYSDATE, 100, '�԰�');