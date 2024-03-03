/*
    DDL : ������ ���� ���
    
    ��ü�� ����(CREATE), ����(ALTER), ����(DROP)�ϴ� ����
    
    <ALTER>
    ��ü�� �����ϴ� ����
    
    [ǥ����]
    ALTER TABLE ���̺�� ������ ����;
    
    *������ ����
    1) �÷� �߰� / ���� / ����
    2) �������� �߰� / ���� --> ������ �Ұ�(�����ϰų� ���� �� �ٽ� �߰��ؾ� ��)
    3) �÷��� / �������Ǹ� / ���̺�� ����
*/

-- 1) �÷� �߰� / ���� / ����
-- DEPT_TABLE�� CNAME �÷� �߰�
ALTER TABLE DEPT_TABLE ADD CNAME VARCHAR2(20);

-- LNAME �÷� �߰� (�⺻�� -> �ѱ�)
ALTER TABLE DEPT_TABLE ADD LNAME VARCHAR2(20) DEFAULT '�ѱ�';

-- 1-2) �÷� ���� (MODIFY)
--> ������ Ÿ�� ���� : MODIFY �÷��� �ٲٰ��� �ϴ� ������ Ÿ��
--> DEFAULT �� ���� : MODIFY �÷��� DEFAULT �ٲٰ��� �ϴ� �⺻��

ALTER TABLE DEPT_TABLE MODIFY DEPT_ID CHAR(5);

ALTER TABLE DEPT_TABLE MODIFY DEPT_TITLE NUMBER;
--/ column to be modified must be empty to change datatype
--/ ������ Ÿ�Կ� ���� ������, ���� �����Ϳ� �ڷ����� �ٸ�

ALTER TABLE DEPT_TABLE MODIFY DEPT_TITLE VARCHAR2(10);
--/ cannot decrease column length because some value is too big
--/ ũ�� ���� ��

-- DEPT_TITLE �÷��� VARCHAR2(40)
ALTER TABLE DEPT_TABLE MODIFY DEPT_TITLE VARCHAR2(40);
-- LNAME �÷��� �⺻���� '�̱�'���� ����
ALTER TABLE DEPT_TABLE MODIFY LNAME DEFAULT '�̱�';

-- ���ߺ��� ����
ALTER TABLE DEPT_TABLE
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LNAME DEFAULT '�̱�';
    
-- 1-3) �÷� ���� (DROP COLUMN) : DROP COLUMN �����ϰ��� �ϴ� �÷�
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPT_TABLE;

SELECT * FROM DEPT_TABLE;

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;

SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
--/ An attempt was made to drop all columns in a table
--/ ���̺��� ����� �Ϸ��� �ּ� �� ���� �÷��� �־�� ��

-----------------------------------------------------------------------
-- 2) �������� �߰� / ����(������ �����ϰ� �ٽ� �߰��ϱ�� ��ü)
/*
    2-1)
     -PRIMARY KEY : ALTER TABLE ���̺�� ADD PRIMARY KEY(�÷���);
    -FOREIGN KEY : ALTER TABLE ���̺�� ADD FOREIGN KEY(�÷���) REFERENCES ������ ���̺��[(�������÷���)]
    -UNIQUE      : ALTER TABLE ���̺�� ADD UNIQUE(�÷���);
    -CHECK      : ALTER TABLE ���̺�� ADD CHECK(�÷��� ���� ���ǽ�);
    -NOT NULL   : ALTER TABLE ���̺�� MODIFY �÷��� NOT NULL;
    
    �������Ǹ��� �����ϰ��� �Ѵٸ� [CONSTRAINT �������Ǹ�] ��������
*/

-- DEPT_TABLE
-- DEPT_ID�� PRIMARY KEY �������� �߰�
ALTER TABLE DEPT_TABLE ADD PRIMARY KEY (DEPT_ID);
-- DEPT_TITLE�� UNIQUE �������� �߰�
ALTER TABLE DEPT_TABLE ADD UNIQUE(DEPT_TITLE);
-- LNAME�� NOT NULL �������� �߰�
ALTER TABLE DEPT_TABLE ADD NOT NULL(LNAME);
--/ NOT NULL�� MODIFY�� �ؾ� ��

-- ����� ����
ALTER TABLE DEPT_TABLE
    ADD CONSTRAINT DTABLE_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DTABLE_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DTABLE_NN NOT NULL;
    
-- 2-2) �������� ���� : DROP CONSTRAINT �������Ǹ� / NOT NULL -> ���� �� ��
ALTER TABLE DEPT_TABLE DROP CONSTRAINT DTABLE_PK;

ALTER TABLE DEPT_TABLE
    DROP CONSTRAINT DTABLE_UQ
    MODIFY LNAME NULL;
    --/ NOT NULL�� �ٽ� ������ �ƴ� �������� NULL�� �ٲ��ָ� ��
    
---------------------------------------------------------------------
-- ���̺� ����
DROP TABLE DEPT_TABLE;
-- ��򰡿� ���� �ǰ� �ִ� �θ� ���̺��� �Ժη� �������� ����

--/ �ϴٺ��� ���� �� �Ǵ� ���̺��� ����

-- ������� �ϴ� ���
-- 1. �ڽ� ���̺� ���� ���� �� ����
-- 2. �θ� ���̺� ���� + �������Ǳ��� �����ϴ� ���
--      > DROP TABLE ���̺�� CASCADE CONSTRAINT;

---------------------------------------------------------------------
--/������ ���� ������� ����, �� ���� ���� ����
-- 3) �÷��� / �������Ǹ� / ���̺�� ����(RENAME)
-- 3-1) �÷��� ���� : RENAME COLUMN ���� �÷��� TO �ٲ� �÷���

CREATE TABLE DEPT_TABLE
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_TABLE;

-- DEPT_TITLE -> DEPT_NAME ����
ALTER TABLE DEPT_TABLE RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3-2) �������Ǹ� ���� : RENAME CONSTRAINT ���� ���� ���Ǹ� TO �ٲ� ���� ���Ǹ�
ALTER TABLE DEPT_TABLE RENAME CONSTRAINT SYS_C007086 TO DTABLE_LID_NN;

-- 3-3) ���̺�� ���� : RENAME TO �ٲ� ���̺��
ALTER TABLE DEPT_TABLE RENAME TO DEPT_TEST;

------------------------------------------------------------------------------
-- TRUNCATE : ���̺� �ʱ�ȭ
-- DROP���� �ٸ��� ���̺��� ������ ���� ���� �����Ͽ� ���̺��� �ʱ� ���·� ������
TRUNCATE TABLE DEPT_TEST;
SELECT * FROM DEPT_TEST;