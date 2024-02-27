/*
    *DDL : ������ ���� ���
    ����Ŭ���� �����ϴ� ��ü�� ���� �����(CREATE), ������ �����ϰ�(ALTER), ���� ��ü�� ����(DELETE) �ϴ� ���
    ��, ���� ������ ���� �ƴ� ��Ģ ��ü�� �����ϴ� ���
    
    ����Ŭ������ ��ü(����) : ���̺�, ��, ������, �ε���, ��Ű��, Ʈ����
                         ���ν���, �Լ�, ���Ǿ�, �����
    
    <CREATE>
    ��ü�� ���� �����ϴ� ����
*/

/*
    1. ���̺� ����
    - ���̺� : ��� ���� �����Ǵ� ���� �⺻���� �����ͺ��̽� ��ü
              ��� �����͵��� ���̺��� ���ؼ� �����
              
    CREATE TABLE ���̺�� (
        �÷��� �ڷ���(ũ��),
        �÷��� �ڷ���(ũ��),
        �÷��� �ڷ���,
        ...
    )
    
    *�ڷ���
    - ���� (CHAR(����Ʈ ũ��) | VARCHAR2(����Ʈ ũ��)) /���ڴ� ������ ����Ʈ ũ�⸦ ����� ��
        CHAR : �ִ� 2000����Ʈ���� ���� ���� / ���� ���� (������ ���� ���� �����Ͱ� ��� ���) //�ֹε�Ϲ�ȣ, ��ȭ��ȣ ��
        (������ ũ�⺸�� �� ���� ���� ������ �������ζ� ä���� ó�� ������ ũ�⸦ �������)
        VARCHAR2 : �ִ� 4000����Ʈ���� ���� ���� / ���� ����(�� ������ �����Ͱ� ����� �𸣴� ���)
        (��� ���� ���� ���� ũ�Ⱑ ������)
    - ���� (NUMBER)
    - ��¥ (DATE)

*/

-- ȸ���� ���� �����͸� ��� ���� ���̺� MEMBER ����
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13), --/ �����̸鼭�� 13�ڸ� ������ ����� ���Ƿ� ������ ��
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
); --/ ���̺� ����� �͸� ��, ���⿡ �̰����� ������ �־��� ��

SELECT * FROM MEMBER;

--------------------------------------------------------------------------
-- ������ ��ųʸ� : �پ��� ��ü���� ������ �����ϰ� �ִ� �ý��� ���̺�
--/ ������ ������ ���̺� => �����ͺ��̽��� �����ϱ� ���� ���̺��, �����̳� � ����� �ϱ� ����
--/ ó�� ���� ������ �����ص� �⺻ ���̺�
SELECT * FROM USER_TABLES;
--/ ���� DB�� �ִ� �� �ٸ� DB�� �����ϴ� �� : ���̱׷��̼�
SELECT * FROM USER_TAB_COLUMNS;
--------------------------------------------------------------------------

/*
    2. �÷��� �ּ� �ޱ�(�÷��� ���� ������ ����)
    
    [ǥ����]
    COMMENT ON COLUMN ���̺��.�÷��� IS '�ּ�����';
    -> �߸� �ۼ� �� ���� �����ϸ� ��
*/

COMMENT ON COLUMN MEMBER.MEM_NO IS 'ȸ����ȣ';
COMMENT ON COLUMN MEMBER.MEM_ID IS 'ȸ�����̵�';
COMMENT ON COLUMN MEMBER.MEM_PWD IS 'ȸ����й�ȣ';
COMMENT ON COLUMN MEMBER.MEM_NAME IS 'ȸ����';
COMMENT ON COLUMN MEMBER.GENDER IS '����(��/��)';
COMMENT ON COLUMN MEMBER.PHONE IS '��ȭ��ȣ';
COMMENT ON COLUMN MEMBER.EMAIL IS '�̸���';
COMMENT ON COLUMN MEMBER.MEM_DATE IS 'ȸ��������';


-- ���̺� ���� : DROP TABLE ���̺��;
DROP TABLE MEMBER;
--/ ���� ���̺� ���� ���� ������ ����� ��������

-- ���̺� �����͸� �߰���Ű�� ����(INSERT)
-- INSERT INTO ���̺�� VALUES(��, ��, ��, ��, ��, ... ��) /�� ��� ��� �� �÷� ó������ ������� ���� �� �־���� ��
INSERT INTO MEMBER
VALUES(1, 'USER1', 'PASS1', 'ȫ�浿', '��', '010-1111-2222', 'AAAA@NAVER.COM', '24/02/23');

SELECT * FROM MEMBER;

INSERT INTO MEMBER
VALUES(2, 'USER2', 'PASS2', '������', '��', '010-5240-0484', NULL, SYSDATE);

INSERT INTO MEMBER
VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
--/ �̷� ���� �����Ͱ� ���� �� ��, �⺻Ű�� ������ �� ���� ������ ��ü�� ����

-------------------------------------------------------------------------
/*
    <��������>
    - ���ϴ� �����Ͱ�(��ȿ�� ������ ��)�� �����ϱ� ���ؼ� Ư�� �÷��� �����ϴ� ����
    - ������ ���Ἲ ������ �������� ��
    --/ ���� ���ϴ� ���¸� �����ϴ� �� ���Ἲ ����, �� ���°� ������ ���Ἲ�� �����ٰ� ��
    
    ���� : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
*/

/* 
    *NOT NULL ���� ����
    �ش� �÷��� �ݵ�� ���� �����ؾ߸� �ϴ� ��� (��, ���� NULL�� ������ �� �Ǵ� ���)
    ���� / ���� �� NULL ���� ������� �ʵ��� ����
    
    ���� ������ �ο��ϴ� ����� ũ�� 2���� ���� (�÷� ���� ��� / ���̺� ���� ���)
    NOT NULL ���� ������ ������ �÷� ���� ������θ� ������
*/

CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),--/ ���� ���� �ʿ��� ���������� Ȯ���ϸ� ��, �ʼ��������� ���û�������
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL
VALUES(1, 'USER1', 'PASS1', 'ȫ�浿', '��', '010-1111-2222', 'AAAA@NAVER.COM');

SELECT * FROM MEM_NOTNULL;

INSERT INTO MEM_NOTNULL
VALUES(2, 'USER2', 'PASS2', 'ȫ���', NULL, NULL, NULL);

INSERT INTO MEM_NOTNULL
VALUES(3, NULL, 'PASS2', 'ȫ���', NULL, NULL, NULL);
-- �ǵ��ߴ� ��� ���� �߻� (NOT NULL ���� ���ǿ� ����Ǿ� ���� �߻�)

INSERT INTO MEM_NOTNULL
VALUES(3, 'USER2', 'PASS2', 'ȫ���', NULL, NULL, NULL);
-- ���̵� �ߺ� �Ǿ������� �ұ��ϰ� �� �߰��� �� => �̷��� �� ��

-------------------------------------------------------------------------
/*
    *UNIQUE ���� ����
    �ش� �÷��� �ߺ��� ���� ������ �� �� ��� ���
    �÷����� �ߺ����� �����ϴ� ���� ����
    ���� / ���� �� ������ �ִ� ������ �� �� �ߺ����� ���� ��� ������ �߻���Ŵ
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- �÷� ���� ���
    --/ �÷� ���� ����� ���������� � ������ �ִ��� ���� �� �� ����, ���� �÷� ������ ��ȣ
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),--/ ���� ���� �ʿ��� ���������� Ȯ���ϸ� ��, �ʼ��������� ���û�������
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50)
    -- UNIQUE(MEM_ID) -- ���̺� ���� ���
);

SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', 'ȫ�浿', '��', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER1', 'PASS2', 'ȫ���', '��', NULL, NULL);
-- UNIQUE ���� ���ǿ� ����Ǿ����Ƿ� INSERT ����
--> ���� ������ ���� ���Ǹ����� �˷���
--> ���� �ľ��ϱ� �����
--> ���� ���� �ο� �� ���� ���Ǹ��� ���������� ������ �ý��ۿ��� �̸��� �ο���
--/ UNIQUE ���ǿ� ����ȴٰ� ��
--/ �̶� ������ �ߴ� KH.SYS_C007024�� �������� �̸�, �ش� ���̺��� ���� ���ǿ� ������ Ȯ���� �� �ִ� �ڵ�

-----------------------------------------------------------------------
/*
    *���� ���� �ο� �� ���� ���� ����� �����ִ� ���
    > �÷� ���� ���
    CREATE TABLE ���̺��(
        �÷��� �ڷ��� (CONSTRAINT ���� ���Ǹ�) ���� ���� --/ ���� ����, ������ �ý����� �˾Ƽ� ����
    )
    
    > ���̺� ���� ���
    CREATE TABLE ���̺��(
        �÷��� �ڷ���,
        �÷��� �ڷ���,
        (CONSTRAINT ���� ���Ǹ�) ���� ���� (�÷���)
    )
*/

DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER CONSTRAINT MEMNO_NT NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NT NOT NULL, 
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NT NOT NULL, 
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NT NOT NULL,
    GENDER CHAR(3), --/ ���� ���� ���� �ٸ� ���̺��̴��� �ߺ��� �� ����
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID) --/ �� �� ���̰� ������� ���̺� ������ ���� ��
);
SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', 'ȫ�浿', '��', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER2', 'PASS2', 'ȫ���', '��', NULL, NULL);

INSERT INTO MEM_UNIQUE
VALUES(3, 'USER3', NULL, 'ȫ���', '��', NULL, NULL); --/ ���� ���� ����

INSERT INTO MEM_UNIQUE
VALUES(4, 'USER4', 'PASS4', NULL, NULL, NULL, NULL);

----------------------------------------------------------------------------
/*
    *CHECK(���ǽ�)
    �ش� �÷��� ���� �� �ִ� ���� ���� ������ �������� �� ����
    �ش� ������ �����ϴ� ������ ���� ���� �� ����
*/
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')), -- ��, �� --/ F, M �������̽� ���� �ɷ� �� �ɾ��ָ� ������ ������ �Լ��� �� �����ؾ� ��
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID) --/ �� �� ���̰� ������� ���̺� ������ ���� ��
);

INSERT INTO MEM_CHECK
VALUES(1, 'USER1', 'PASS1', 'ȫ�浿', '��', '010-1111-2222', 'AAAA@NAVER.COM');

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK
VALUES(2, 'USER2', 'PASS2', 'ȫ���', '��', NULL, NULL);
--> CHECK ���� ���� ������ ������ �߻���
--> ���� GENDER �÷��� �����͸� �ְ��� �Ѵٸ� CHECK ���� ���ǿ� �����ϴ� ���� �־�� ��
INSERT INTO MEM_CHECK
VALUES(2, 'USER2', 'PASS2', 'ȫ���', NULL, NULL, NULL);
--> NULL�� ���� ���ٴ� ���̱� ������ ����
--/ NOT NULL�� ���ٸ� �� �� ����

-------------------------------------------------------------------------
/*
    PRIMARY KEY(�⺻Ű) ���� ����
    ���̺��� �� ��(ROW)�� �ĺ��ϱ� ���� ���� �÷��� �ο��ϴ� ���� ����(�ĺ��� ����)
    
    EX) ȸ����ȣ, �й�, ����, �μ��ڵ�, �����ڵ�, �ֹ���ȣ, �ù� ����� ��ȣ, �����ȣ ���
    PRIMARY KEY ���� ������ �ο� -> NOT NULL + UNIQUE �� ����
    --/ PRIMARY KEY�� �� ���̺� �ϳ����� ����
    
    ���ǻ��� : �� ���̺� �� ���� �� ���� ���� ����
*/

CREATE TABLE MEM_PRI(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')), -- ��, �� --/ F, M �������̽� ���� �ɷ� �� �ɾ��ָ� ������ ������ �Լ��� �� �����ؾ� ��
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID) --PRIMARY KEY(MEM_NO)
);

INSERT INTO MEM_PRI
VALUES(1, 'USER1', 'PASS1', 'ȫ�浿', '��', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_PRI
VALUES(1, 'USER2', 'PASS2', 'ȫ���', '��', NULL, NULL);
--> �⺻Ű�� �ߺ����� �������� �� ��(UNIQUE ���� ���� ����)

INSERT INTO MEM_PRI
VALUES(2, 'USER2', 'PASS2', 'ȫ���', '��', NULL, NULL);

------------------------------------------------------------------------
CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')), -- ��, �� --/ F, M �������̽� ���� �ɷ� �� �ɾ��ָ� ������ ������ �Լ��� �� �����ؾ� ��
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID),
    PRIMARY KEY(MEM_NO, MEM_ID)
);

-- ����Ű : �� ���� �÷��� ���ÿ� �ϳ��� PRIMARY KEY�� �����ϴ� ��
--/ �ٴ�� ����� ���� Ű�� ������ ���� �� ����
--/ ������ ��ǰ�� ������ �� �̰� 1��� ���谡 ��
--/ �ٵ� ���� ��ǰ�� �ٽ� ���� ���� ����
--/ ���� ������ �⺻Ű�� ��ǰ�� �⺻Ű�� ���ļ� ���ϱ� ���̺��� ����Ű�� ���
--/ ���ƿ�, �ϸ�ũ, ���ã�� ��

CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

-- ȸ�� 2�� (1�� 2��) ����
-- ����A ����B ��ǰ ����

--/ ������ �÷����� �����ϸ� �� ���̺��� PRIMARY KEY�� ������

--/ ������ �� �ǰų� �ش� �����͸� ����ϰ� �ִ� �ڽ� �����͵� ���� ���� �Ǵ� �� ��
--/ ��� �� �� ������ -> ��å�� ���� �ٸ�
--/ ���ߴ� ��ǰ, ����ڸ� �����ϸ� �� �����ʹ� ������� ��


--/ ���̺� ���� �ÿ��� DROP���� �����ϰ� �ٽ� ����� �� ��������
--/ ���� �ϴ� ���߿��� ������ �� ����
--/ �̷� �� ����

--/ ���� �������� ���� �� �����ϴ� �� ������ �������� ������ ������ �մ� ���������� ������ ���� ���� ����
--/ DROP���� PRIMARY KEY �����ϸ� ��
--/ ��� ��ġ�� DROP ������ ������ ���� �� �� ����

--EMPLOYEE ���̺� DEPT_cODE�� �ܷ�Ű �������� �߰�
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;
-- EMPLOYEE ���̺� JOB_CODE�� �ܷ�Ű �������� �߰�
-- DEPARTMENT ���̺� LOCATION_ID�� �ܷ�Ű ���� ���� �߰�