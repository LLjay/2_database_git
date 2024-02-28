/*
    <PL / SQL>
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    ����Ŭ ��ü�� ����Ǿ� �ִ� ������ ���
    SQL ���� ������ ������ ����, ����(IF), �ݺ�(FOR, WHILE) ���� �����Ͽ� SQL�� ������ ����
    �ټ��� SQL���� �� ���� ���� ����
    / �ʼ��� �ƴ�, ���Ǹ� ���� ��
    
    *PL/SQL ����
    - [�����] : DECLARE�� ����, ������ ����� ���� �� �ʱ�ȭ �ϴ� �κ�
    - ����� : BEGIN���� ���� END;/ �� ����, SQL�� �Ǵ� ���(���ǹ�, �ݺ���) ���� ������ ����ϴ� �κ�
    - [����ó����] : EXCEPTION���� ����, ���� �߻� �� �ذ��ϱ� ���� ���� / �ڹ��� TRY-CATCH�� ����
*/

SET SERVEROUTPUT ON;
--/ �̰� �ؾ� �ۼ� ����?

-- HELLO ORACLE ���
BEGIN
    --SYSTEM.OUT.PRINTLN("HELLO ORACLE"); -> �ڹ�
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE'); --/SYSO�� ����
END;
/ 

--/ ������ �� �ᵵ ����� �Ǵµ� �� ���ִ� ����...
--/ ������ ���� �ּ��� �� ������ �ν����� ����
----------------------------------------------------------------------------------------
/*
    1. DECLARE �����
       ���� �� ����� �����ϴ� ����(����� ���ÿ� �ʱ�ȭ ����)
       �Ϲ� Ÿ�� ����, ���۷��� Ÿ�� ����, ROW Ÿ�� ����
       
    1-1) �Ϲ� Ÿ�� ���� ���� �� �ʱ�ȭ
        [ǥ����] ������ [CONSTANT] �ڷ��� [:= ��];
        / ���Կ����� :=
*/

DECLARE --/ ������ ����� ���� ���� ��
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14; --/ CONSTANT�� ���
BEGIN
    EID := &��ȣ;
    ENAME := '&�̸�';
    --> ��ü ����, ���� �Է��϶�� �� / ��ȣ�� �״��, ���ڿ� �� ���ͷ��� ��������ǥ �ȿ�
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI); --DDFLKSDJFLK
END;
/ 
--���⸸ �� �ǳ�? �׷���...

------------------------------------------------------------------------------------------
-- 1-2) ���۷��� Ÿ�� ���� ���� �� �ʱ�ȭ(� ���̺��� � �÷��� ������ Ÿ���� �����ؼ� �� Ÿ������ ����)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; --/�굵 �Ȱ��� �ڷ������� ��
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
--    EID := 800;
--    ENAME := '������';
--    SAL := 1000000;

-- ����� 200���� ����� ���, �����, �޿� ��ȸ�ؼ� �� ������ ����
SELECT EMP_ID, EMP_NAME, SALARY
INTO EID, ENAME, SAL --/ SELECT������ ������ ���� ���� ��� ������ ���������� INTO ����ؼ� ��Ī
FROM EMPLOYEE
WHERE EMP_ID = 200;

DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);

SELECT EMP_ID, EMP_NAME, SALARY
INTO EID, ENAME, SAL --/ SELECT������ ������ ���� ���� ��� ������ ���������� INTO ����ؼ� ��Ī
FROM EMPLOYEE
WHERE EMP_ID = &���;

DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);

END;
/

----------------------------------------�ǽ�-------------------------------------------
/*
    ���۷��� Ÿ�� ������ EID, ENAME, JCODE, SAL, DTITLE�� �����ϰ�
    �� �ڷ��� EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT(DEPT_TITLE) ���� �����ϵ���
    ����ڰ� �Է��� ����� ����� ���, �����, �����ڵ�, �޿�, �μ��� ��ȸ �� �� ������ ��� ���
*/
-- �� ����
DECLARE
    EID VARCHAR2(20);
    ENAME VARCHAR2(20);
    JCODE VARCHAR2(5);
    SAL NUMBER;
    DTITLE VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
END;
/

-- ����� ����
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
END;
/

-----------------------------------------------------------------------------------
-- 1-3) ROW Ÿ�� ���� ����
--      ���̺��� �� �࿡ ���� ��� �÷����� �� ���� ���� �� �ִ� ����
--      [ǥ����] ������ ���̺��%ROWTYPE;

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('����� : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || E.SALARY);
--    DBMS_OUTPUT.PUT_LINE('���ʽ� : ' || NVL(BONUS, 0)); ��� BONUS���� ��������� ��? ��?
    DBMS_OUTPUT.PUT_LINE('���ʽ� : ' || NVL(E.BONUS, 0));
END;
/

-------------------------------------------------------------------------------------
/*
    2. BEGIN �����
    <���ǹ�>
    1) IF ���ǽ� THEN ���� ���� END IF; (IF���� �ܵ����� ����� ��)
*/

-- �Է� ���� ����� �ش��ϴ� ����� ���, �̸�, �޿�, ���ʽ� ���
-- ��, ���ʽ��� ���� ���� ����� ���ʽ� ��� �� '���ʽ��� ���� ���� ���� ����Դϴ�' ���

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || EID);
    DBMS_OUTPUT.PUT_LINE('����� : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || SAL);

    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� ���� ����Դϴ�.');
    END IF;
    -- IF ���� �ɸ��� ���⼭ �����ٴ� �ű���
    DBMS_OUTPUT.PUT_LINE('���ʽ��� : ' || BONUS); -- �����ٴ� �� �ƴ϶� �׳� ���� ���� ������� �ʴ� �ǰ�?
END;
/

-- 2) IF ���ǽ� THEN ���೻�� ELSE ���೻�� END IF; (IF-ELSE)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || EID);
    DBMS_OUTPUT.PUT_LINE('����� : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || SAL);

    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� ���� ����Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('���ʽ��� : ' || (BONUS * 100 || '%'));
    END IF;
END;
/

------------------------------------�ǽ�-----------------------------------------
--DECLARE
--  ���۷��� Ÿ�� ���� (EID, ENAME, DTITLE, NCODE)
--          ���� �÷� (EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE)
--      �Ϲ� Ÿ�� ���� (TEAM ���ڿ�) < == �̵��� ������, �ؿ��� �и��ؼ� ���� ����
--BEGIN
--  ����ڰ� �Է��� ����� ����� ���, �����, �μ���, �ٹ������ڵ� ��ȸ �� �� ������ ����
-- 
--  NCODE ���� KO�� ��� --> TEAM --> '������' ����
--             �ƴ� ��� --> TEAM --> '�ؿ���' ����
--
--  ���, �̸�, �μ�, �Ҽӿ� ���� ���
--END;
--/


DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &���;
    
    IF NCODE = 'KO'
        THEN TEAM := '������';
    ELSE 
        TEAM := '�ؿ���';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME || ', ' || DTITLE || ', ' || NCODE || ', ' || TEAM);
END;
/

-- 3) IF ���ǽ�1 THEN ���೻��1 ELSIF ���ǽ�2 THEN ���೻��2 ... [ELSE ���೻��] END IF;

DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(1);
BEGIN
    SCORE := &����;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('����� ������ ' || SCORE || '���̰� ������ ' || GRADE || '���                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          �Դϴ�.');
END;
/

---------------------------------�ǽ�------------------------------------
-- ����ڿ��� �Է� ���� ����� ����� �޿��� ��ȸ�ؼ� SAL���� ����
-- 500���� �̻��̸� '���'
-- 400���� �̻��̸� '�߱�'
-- 300���� �̻��̸� '�ʱ�'
-- '�ش� ����� �޿� ����� XX�Դϴ�.'

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    IF SAL >= 5000000
        THEN GRADE := '���';
    ELSIF SAL >= 4000000
        THEN GRADE := '�߱�';
    ELSIF SAL >= 3000000
        THEN GRADE := '�ʱ�';
    ELSE
        GRADE := '����';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('�ش� ����� �޿� ����� ' || GRADE || '�Դϴ�.');
END;
/

--------------------------------------------------------------------
-- 4)CASE �񱳴���� WHEN ����񱳰�1 THEN ����� ... ELSE ����� END;
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '�λ���'
                WHEN 'D2' THEN 'ȸ����'
                WHEN 'D3' THEN '��������'
                WHEN 'D4' THEN '����������'
                WHEN 'D5' THEN '�ѹ���'
                ELSE '�ؿܿ�����'
            END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '�� ' || DNAME || '�Դϴ�.');
END;
/

-----------------------------------------------------------------------

/*
    1) BASIC LOOP ��
    [ǥ����]
    LOOP
        �ݺ������� ������ ����;
        *�ݺ����� �������� �� �ִ� ����
    END LOOP;
    
    *�ݺ����� �������� �� �ִ� ����
    1) IF ���ǽ� THEN EXIT; END IF;
    2) EXIT WHEN ���ǽ�;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
--        IF I = 6 THEN EXIT; END IF;
        EXIT WHEN I = 6;
    END LOOP;
END;
/

---------------------------------------------------------------------------------------
/*
    2) FOR LOOP��
    [ǥ����]
    FOR ���� IN [REVERSE] �ʱⰪ..������
    LOOP
        �ݺ������� ������ ����
    END LOOP;
*/

BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

DROP TABLE TEST;

CREATE TABLE TEST (
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

SELECT * FROM TEST;

CREATE SEQUENCE SEQ_TNO
START WITH 1
INCREMENT BY 2
MAXVALUE 1000
NOCYCLE
NOCACHE;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUE(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/
-- �� �� ��
----------------------------------------------------------------------

/*
    WHILE LOOP��
    
    [ǥ����]
    WHILE �ݺ����� ����� ����
    LOOP 
        �ݺ� �����ϴ� ����
    END LOOP;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP  
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
    END LOOP;
END;
/

-----------------------------------------------------------------------------------------

/*
    3. ����ó����
    ����(EXCEPTION) : ���� �� �߻��ϴ� ����
    
    EXCEPTION
        WHEN ���ܸ�1 THEN ����ó������1;
        WHEN ���ܸ�2 THEN ����ó������2;
        ...
    
    *�ý��� ����(����Ŭ���� �̸� �����ص� ����)
    - NO_DATE_FOUND : SELECT�� ����� �� �൵ ���� ��
    - TOO_MANY_ROWS : SELECT�� ����� ���� ���� ��� /�ʹ� ���� ��
    - ZERO_DIVIDE : 0���� ���� ��
    - DUP_VAL_ON_INDEX : UNIQUE ���� ���ǿ� ���� �Ǿ��� ���
    ...
*/

-- ����ڰ� �Է��� ���� ������ ������ ��� ���
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &����;
    DBMS_OUTPUT.PUT_LINE('��� : ' || RESULT);
EXCEPTION
    -- WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('������ ���� �� 0���� ���� �� �����ϴ�.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('������ ���� �� 0���� ���� �� �����ϴ�.'); --/ ���ܸ� �� �޾��ִ� ����
END;
/

-- UNIQUE ���� ���� ����
-- ALTER TABLE EMPLOYEE ADD PRIMARY KEY(EMP_ID);

BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&�����һ��'
    WHERE EMP_NAME = '���ö'; -- 200 �Է� �� 200 ����� �̹� �����Ƿ� ���� �߻�
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('�̹� �����ϴ� ����Դϴ�.');
END;
/