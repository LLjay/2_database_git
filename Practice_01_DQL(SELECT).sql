-- ��� ����� ������ ������
SELECT * FROM EMPLOYEE;

-- ��� ����� �̸�, �ֹε�Ϲ�ȣ, �ڵ�����ȣ
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE;

SELECT EMP_NAME, PHONE, EMP_NO
FROM EMPLOYEE;

----------------------�ǽ�------------------------
-- JOB ���̺��� ���޸� �÷��� ��ȸ
SELECT JOB_NAME FROM JOB;

-- DEPARTMENT ���̺��� ��� �÷� ��ȸ
SELECT * FROM DEPARTMENT;

-- DEPARTMENT ���̺��� �μ� �ڵ�, �μ��� ��ȸ
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- EMPLOYEE ���̺��� �����, �̸���, ��ȭ��ȣ, �Ի���, �޿� ��ȸ
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� �����, ����� ����(SALARY * 12)�� ��ȸ
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� �����, �޿�, ���ʽ�, ����, ���ʽ� ���� ���� ��ȸ(�޿� + (�޿� * ���ʽ�)) * 12
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12 AS "����", (SALARY + (SALARY * BONUS)) *12 AS "���ʽ�����"
FROM EMPLOYEE;

-- �����, �Ի���, �ٹ��ϼ��� ��ȸ
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

SELECT SYSDATE FROM DUAL;
-- �̹� ������ �ִ� ����ϱ� ���ʿ� ��𿡼��� ������ ���� ����, ���̵������� DUAL���� �������ڴٰ� ������ִ� ��
-- SYSDATE�� ������ �� �� �� �� �� �� �� ǥ���� �� ����

-- ���� ��¥ ��ȸ
SELECT SYSDATE FROM DUAL;

-- EMPLOYEE ���̺��� ���, �����, �޿�
SELECT EMP_ID, EMP_NAME, SALARY, '��'
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '��' 
FROM EMPLOYEE;

-- ���, �̸�, �޿��� �ϳ��� �÷����� ��ȸ
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- EMPLOYEE ���̺��� ��� ����� ������ ��ȸ�Ѵ�. ������ ���� ����� �������� ����϶�.
-- XX�� ������ XX���Դϴ�.
SELECT EMP_NAME || '�� ������ ' || SALARY || '�� �Դϴ�.' AS SALARY
FROM EMPLOYEE;

-- EMPLOYEE �����ڵ� ��ȸ
SELECT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE �μ��ڵ带 ��ȸ (�ߺ�����)
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE �μ��ڵ�, �����ڵ� �ߺ� �����ؼ� ��ȸ
SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

--EMPLOYEE���� �μ��ڵ尡 'D9'�� ����鸸 ��ȸ(��� �÷�)
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE���� �μ��ڵ尡 'D1'�� ������� �����, �޿�, �μ��ڵ� ��ȸ
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE���� �μ��ڵ尡 'D1'�� �ƴ� ������� �����, �޿�, �μ��ڵ� ��ȸ
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE != 'D1';

-- ������ 400���� �̻��� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

---------------------------�ǽ�---------------------------
-- 1. �޿��� 300���� �̻��� ������� �����, �޿�, �Ի���, ����(��Ī -> ����) ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY * 12 AS "����"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. ������ 5õ���� �̻��� ������� �����, �޿�, ����(��Ī -> ����), �μ��ڵ� ��ȸ


-- 3. ���� �ڵ尡 'J3'�� �ƴ� ������� ���, �����, ���� �ڵ�, ��� ���� ��ȸ


-- 4. �޿��� 350���� �̻� 600���� ������ ��� ����� �����, ���, �޿� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;