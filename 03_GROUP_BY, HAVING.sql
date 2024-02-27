/*
    <GROUP BY��>
    �׷� ������ ������ �� �ִ� ���� (�ش� �׷� ���غ��� ���� �׷����� ���� �� ����)
    ���� ���� ������ �ϳ��� �׷����� ��� ó���ϴ� �������� ���
*/

-- �� �μ��� �� �޿�
-- �� �μ����� ���� �׷�
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- DEPT_CODE�� ���� ���� ���� �ೢ�� ���� ���� ��Ƶ�

-- �� �μ��� �����
SELECT COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE 
GROUP BY DEPT_CODE; --/ �̰� �̹� �׷��� ������ �����̹Ƿ� �� �������� ������, ����

--SELECT DEPT_CODE, COUNT(*)
--FROM EMPLOYEE; --/ �̰� �׷� �Լ��� �� ���� ���̹Ƿ� �� ��

SELECT DEPT_CODE, COUNT(*), SUM(SALARY) ----- 3
FROM EMPLOYEE ----- 1
GROUP BY DEPT_CODE ----- 2
ORDER BY DEPT_CODE; ----- 4

-- �� ���޺� �� �����, ���ʽ��� �޴� ��� ��, �޿� ��, ��� �޿�, ���� �޿�, �ְ� �޿� (���� : ���� ��������)
SELECT JOB_CODE AS "����", COUNT(*) AS "�� �����"
        , COUNT(BONUS) AS "���ʽ��� �޴� �����"
        , SUM(SALARY) AS "�޿� ��", ROUND(AVG(SALARY)) AS "��� �޿�"
        , MIN(SALARY) AS "���� �޿�", MAX(SALARY) AS "�ְ� �޿�"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE; --/ ��
SELECT SALARY
FROM EMPLOYEE
GROUP BY DEPT_CODE;--/ �� ��

-- GROUP BY ���� �Լ��� ��� ���� 
-- ���� ����� ��, ���� ����� ��
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��') AS "����", COUNT(*) AS "�����"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);
--/ �׷� ���̿� �� �� �ִ� �� �÷����� �׷츸 �� �������� ��

-- GROUP BY ���� ���� �÷� ��� ����
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE; --/ �׷��� �ߺ��ؼ� ������ ���� �� �׷��� �� ��

-------------------------------------------------------------------------

/*
    [HAVING ��]
    �׷쿡 ���� ������ ������ �� ����ϴ� ���� (�ַ� �׷��Լ����� ������ ������ ����)
*/

-- �� �μ��� ��� �޿� ��ȸ(�μ� �ڵ�, ��� �޿�)
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- �� �μ��� ��� �޿��� 300���� �̻��� �μ��鸸 ��ȸ (�μ� �ڵ�, ��� �޿�)
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
--WHERE AVG(SALARY) >= 3000000; => ������, WHERE�� ��� �࿡ ���� ������ ���� ��
HAVING AVG(SALARY) >= 3000000;

--------------------------------------------------------------------

-- ���޺� ���� �ڵ�, �� �޿� ��(�� ���޺� �޿� ���� õ�� �� �̻��� ���޸� ��ȸ)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- �μ��� ���ʽ��� �޴� ����� ���� �μ��� �μ� �ڵ�
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
--HAVING SUM(BONUS) IS NULL;
HAVING COUNT(BONUS) = 0;

SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) != 0;

-------------------------------------------------------------------------
/*
    SELECT * | ��ȸ�ϰ� ���� �÷� AS ��Ī | �Լ��� | �������� ----- 5
    FROM ��ȸ�ϰ��� �ϴ� ���̺� | DUAL    ----- 1
    WHERE ���ǽ� (�����ڵ��� Ȱ���Ͽ� ���) / �� �࿡ ���� ���� ----- 2
    GROUP BY �׷� ������ �Ǵ� �÷� | �Լ��� ----- 3
    HAVING ���ǽ� (�׷� �Լ��� ���) ----- 4
    ORDER BY �÷� | ��Ī | ���� [ASC | DESC] [NULLS FIRST | NULLS LAST] ----- 6
*/
--/ ������ �������� �� ����, �� ������ ���� �ɾ��ֱ�, �ɾ��� �͵��� ������ �ٽ� �׷����� ����,
--/ �׷����� ���� �͵�� �ٽ� ���� �ɰ� �������� ���� �͵��� ���� �� ����
--/ ������ ���� ��� ���߿��� �����͸� ������ ���� �� ���ΰ��� ����ϰ� ��
--/ ���̺��� ���� �� ���ļ� ������ �� �ְ� ��, �� �������� �ӵ��� �ִ�ġ�� ������ �� ���� ������ ������ �����;� ��
--/ ����ȭ�� �̹� �Ǿ� �ִ� ȸ�縦 ���� �� ����, 0.3�� �ȿ� �������� �ϴµ� ��� �κп����� �ӵ��� Ȯ �þ
--/ �װ� �׷��� ���� �ʵ��� ���߿� �ɰ��� ������ �װ� ��




/*
    ���� ������ == SET OPERATION
    ���� ���� �������� �ϳ��� ���������� ����� ������

    - UNION : OR | ������(�� ������ ������ ������� ���Ѵ�)
    - INTERSECT : AND | ������(�� �������� ������ ����� �� �ߺ��� �����
    - UNION ALL : ������ + ������ (�ߺ��Ǵ� �� �� �� ǥ���� �� �ִ�.
    - MINUS : ������(���� ������� ���� ������� �� ������)
*/

-- 1. UNION (�ߺ��� ���ŵ�)
-- �μ� �ڵ尡 D5�� ��� �Ǵ� �޿��� 300���� �ʰ��� ������� ���, �̸�, �μ� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5') OR SALARY > 3000000;

-- �μ� �ڵ尡 D5�� ������� ���, �̸�, �μ� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5');

-- �޿��� 300���� �ʰ��� ������� ���, �̸�, �μ� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION���� ���ϱ�
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION --/ ��� ������ �� ���ε� �׳� ���� �����ִ� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--/ ������ ������� OR�� ����ϰ� �� �� ���� ������ ���� ����, �׷� �� UNION���� ������

-- 2. INTERSECT(������) (�ߺ��� ����)
-- �μ� �ڵ尡 D5�̸鼭 �޿��� 300���� �ʰ��� ������� ���, �̸�, �μ� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

---------------------------------------------------------------------------
-- ���� ������ ��� �� ���ǻ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION --/ ��� ������ �� ���ε� �׳� ���� �����ִ� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE --/ SALARY�� ���� ��� ������
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- �÷��� ������ �Ȱ��ƾ� ��

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION 
SELECT EMP_ID, EMAIL, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;
--/ ������ �Ȱ����� EMP_NAME �ڸ��� EMAIL �÷����� ���Ե� ���·� ��
--/ ���� ������ �� �� �����ϸ� EMP_NAME, EMAIL ������ ����� �� ����

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- �÷� �ڸ����� ������ Ÿ������ ����ؾ� �Ѵ�.

--------------------------------------------------------------------------
-- 3. UNION ALL : ���� ���� ���� ����� ������ �� ���ϴ� ������ (�ߺ� ���� �� ��)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_ID;
--/ �� �� �����ϸ� ����� �ߺ��̾ �� �� ������

-- 4. MINUS : ���� SELECT ������� ���� SELECT ����� �� ������(������) (�ߺ��� ��)
-- �μ� �ڵ尡 D5�� ����� �� �޿��� 300���� �ʰ��� ������� �����ϰ� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_ID;

