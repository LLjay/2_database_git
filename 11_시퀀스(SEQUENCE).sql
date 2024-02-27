/*
    <������ SEQUENCE>
    �ڵ����� ��ȣ�� �߻� �����ִ� ������ �ϴ� ��ü
    �������� ���������� �������� ���� ��Ű�鼭 ��������
    
    EX) ȸ����ȣ, �����ȣ, �Խñ۹�ȣ...
    
    [ǥ����]
    CREATE SEQUENCE ��������
    [START WITH ���� ����] --> ó�� �߻� ��ų ���۰� ����[�⺻�� 1]
    [INCREMEMT BY ����] --> �� �� ������ų ����[�⺻�� 1]
    [MAXVALUE ����] --> �ִ밪 ����[�⺻���� �ſ� ū ��]
    [MINVALUE ����] --> �ּҰ� ����[�⺻�� 1] --/ �ִ밪�� �������� �� ��ȯ�Ұ��� ���� ����
    [CYCLE | NOCYCLE] --> ���� ��ȯ���� ���� [�⺻�� NOCYCLE]
    [NOCACHE | CACHE ����Ʈũ��] --> ĳ�ø޸� �Ҵ�[�⺻�� CACHE 20]
    --/ ĳ�ø޸𸮸� �̸� ����� ���� �����Ͱ� ���� �� �׳� �ֱ⸸ �ϸ� ��
    --/ �׷� ���� �� ������
    
    *ĳ�ø޸� : �̸� �߻��� ������ �����ؼ� �����صδ� ����
                �Ź� ȣ��� ������ ���� ��ȣ�� �����ϴ� �� �ƴ϶�
                ĳ�ø޸� ������ �̸� ������ ������ ������ �� �� ���� (�ӵ��� ������)
                
    ���̺�� : TB_
    ��� : VW_
    �������� : SEQ_
    Ʈ���� : TRG_
*/

--/ �⺻Ű�� ����� �־��ְ� �Ǹ� �Ǽ��� �� �� ����
--/ �������� ���� �ڵ����� �־��� ��

CREATE SEQUENCE SEQ_TEST;

--[����] ���� ������ �����ϰ� �ִ� ���������� ������ ������ �� ��
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

SELECT * FROM USER_SEQUENCES;

/*
    2. ������ ���
    ��������.CURRVAL : ���� ������ �� (���������� ������ NEXTVAL�� ��)
    / CURRENT
    ��������.NEXTVAL : ������ ���� �������� ���� ���� �߻��� ��
                     ���� ������ ������ INCREMENT BY ����ŭ ������ ��
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- ����
--> NEXTVAL�� �� ���� �������� ���� �̻� CURRVAL�� ������ �� ����
--/NEXTVAL�� �� ���� �������� ����, ���� CURRVAL�� ������ �� ����
--> CURRVAL�� ���������� ������ NEXTVAL�� ���� �����ؼ� �����ִ� �ӽð�

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
--/ ���۰��� 300���� �ֱ�� �����ϱ�.
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305, 310

SELECT * FROM USER_SEQUENCES;
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 315�� ���;� �ϴµ� MAX�� 310���� ������ ���� �߻�

--/ �ܷ�Ű�� �� �� CURRVAL ���� ��
--/ ��� ������ �� ���̺��� �⺻Ű�� ���� �� �� ����

/*
    3. �������� ���� ����
    
    ALTER SEQUENCE �������� /���� �Ѵٴ� ���� �̹� �����Ǿ� ����ϰ� �ִ� ��������� ��
    X [START WITH ���� ����] : �̹� ���� ���̹Ƿ� ���� �Ұ�
    [INCREMEMT BY ����] --> �� �� ������ų ����[�⺻�� 1]
    [MAXVALUE ����] --> �ִ밪 ����[�⺻���� �ſ� ū ��]
    [MINVALUE ����] --> �ּҰ� ����[�⺻�� 1] --/ �ִ밪�� �������� �� ��ȯ�Ұ��� ���� ����
    [CYCLE | NOCYCLE] --> ���� ��ȯ���� ���� [�⺻�� NOCYCLE]
    [NOCACHE | CACHE ����Ʈũ��] --> ĳ�ø޸� �Ҵ�[�⺻�� CACHE 20]
    
    *START WITH�� ���� �Ұ�
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;

-- 4. ������ ����
DROP SEQUENCE SEQ_EMPNO;

-----------------------------------------------------------------------
CREATE SEQUENCE SEQ_EID
START WITH 400
NOCACHE;

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '�踻��', '111111-2222222', 'J6', SYSDATE);
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '�����', '111111-2222222', 'J6', SYSDATE);
SELECT * FROM EMPLOYEE;
--/ �ڹٿ��� �Ȱ��� ID�� �־��൵ ������ �ڹٴ� �����͸� �����ϰ� �ִ� ���� �ƴϹǷ�
--/ �� ������ �ŷ��� �� ���� => �����ͺ��̽��� �� �������� �����ϴٰ� �� �� ����
