-- ���ö ����� ���� �μ��� ���� ����� ��ȸ
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '���ö');

-- �� ������ ��� �޿����� �� ���� �޿��� �޴� ������� ���, �̸�, ���� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);

/*
    ���� ������ ����� ���� �з��� �޶���
    / ����� ����������, ����������, ���߿�����, ������ ���߿������� �з��ϴ� ��
    
    > ������ ���� ���� : ��� ���� ����� 1���� ��
    > ������ ���� ���� : ��ȸ ������� �÷��� 1���� �÷����� ���� ���� ��
    > ���߿� ���� ���� : ��ȸ ������� ���� �� ���� ��� �ϳ��� �ش��ϴ� �÷����� ���� ���� ��
    > ������ ���߿� ���� ���� : ��ȸ ������� ���� �� ���� �÷��� ��
*/

-- ������ ���� ����
-- 1) �� ������ ��� �޿����� �޿��� �� ���� �޴� ������� �����, �����ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
-- AVG�� �׷� �Լ��̰� �ƹ��� �׷쵵 �������� �ʾ����Ƿ� ��ü�� �ϳ��� �׷�ó�� ��޵Ǿ�
-- �� ������ ��� ��� �� ������ ������ => SALARY�� ��հ� ��� �� ������ ����
-- �� ��հ� ��� �� ������ SALARY�� �� ����
-- SALARY�� ��պ��� ���� ������� �ɷ����� �ش��ϴ� ������� ������ ��ȸ
-- / AVG(SALARY)�� SALARY ��� ��� �ϳ��� �����Ƿ� ������
                
-- 2) ���� �޿��� �޴� ����� ���, �̸�, �޿�, �Ի��� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);

-- 3) ���ö ����� �޿����� ���� �޴� ������� ���, �̸�, �μ� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '���ö');

-- 4) ���ö ����� �޿����� ���� �޴� ������� ���, �̸�, �μ���, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '���ö');

-- 5) �μ��� �޿� ���� ���� ū �μ��� �μ� �ڵ� �޿� ��
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE);
--/EMPLOYEE�� DEPT_CODE�� �������� �׷����� �����ֱ� => �����Ͱ� DEPT_CODE �������� ��µ� ��
--/ �׷��� �� �׷��� ������? SUM(SALARY)�� �ִ밪�� ������ �׷�
--/ ��ġ... �׷��� SALARY ���� ���Ͱ� ���ٰ� �ؾ� �ϴϱ�
--/ WHERE�� ��� �࿡ ���� ������ �ٿ��ִ� ��
--/ HAVING�� ���� �׷���� ������ �� �׷��Լ� ����� �׷��� ī��Ʈ � ���� ������ �ٿ��ִ� ��
--/ ���⼭�� �μ��� �޿� ���� ���� ū �μ���� �����ϱ� �μ����� �׷� ��� �޿� �� ����� ����
--/ ���� ���� ���ο� ���� ����� �ƴ� ��, WHERE���δ� ����� �� ���� ����
--/ �׷쿡 ���� �����̹Ƿ� HAVING���� ������ �ٿ���� ��
--/ �� ���� ������ �����Ϳ� ���� ������ �ƴϴ�!!!
--/ �׷쿡 ���� ����� �׷쿡 ���� �������� ���� �� �ִ�!!!

-- 6) '������' ����� ���� �μ��� ������� ���, �����, ��ȭ��ȣ, �Ի���, �μ����� ��ȸ
--    ��, ������ ����� ����
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_CODE = (SELECT DEPT_CODE --/ DEPT_CODE�� ���� ������ ������� ���� ���̱� ������ �÷��� ���ƾ� �ùٸ� ����� ��ȸ�� �� ����
                FROM EMPLOYEE
                WHERE EMP_NAME = '������')
AND EMP_NAME != '������';
-- DEPT_CODE�� ���� ������ ������� ���� ��, �� �������̶�� �÷����� ���� �μ� �ڵ�� ���� ��
-- ������ �ű⼭ '������'�̶�� �÷����� �ִ� ���� ��ȸ���� �ʰڴ�.

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '������';
-- �μ� �ڵ带 ��ȸ�ϰڴ�.
-- �� EMP_NAME�� �÷����� '������'�� ���� �μ� �ڵ�.

-- ������ ���� ����
-- 1) ����� �Ǵ� ������ ����� ���� ������ ������� ���, �����, ���� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME IN ('�����', '������'));
-- JOB_CODE �� �÷��� �ϳ�(���� ������ ����)
-- JOB_CODE�� �ش��ϴ� ������� ���� ��(����� �Ǵ� ������)
-- ������� ����� �ñ��� => ���� �ڵ尡 �� �� �ϳ��� ������ ��ȸ
-- ���� IN ���� ����� ����
-- OR�� ������ ����İ� ���� �Ǵ� �����ؿ� ���ٷ� ���� ���� ������
-- ���� ������ �� �� �ʿ������Ƿ� IN���� ���ļ� ������

-- 2) �븮 �����ӿ��� ���� ���� �޿��� �� �ּ� �޿����� ���� �޴� ����� ��ȸ
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY > (SELECT MIN(SALARY)
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '����');

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY > ANY (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '����');


--
--SELECT EMP_NAME, SALARY
--FROM EMPLOYEE
--WHERE SALARY > ANY BETWEEN 2000000 AND 2500000;

-- ���� �ڵ尡 J4�� �������� �ְ� �޿� ���� ���� �޴� ����� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE
                    WHERE JOB_CODE = 'J4');
                    
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < ALL (SELECT SALARY
                    FROM EMPLOYEE
                    WHERE JOB_CODE = 'J4');

-- ���߿� ���� ����
-- 1) ������ ����� ���� �μ� �ڵ�, ���� ���� �ڵ忡 �ش��ϴ� ����� ��ȸ
-- �����, �μ� �ڵ�, ���� �ڵ�, �Ի���
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '������');
-- �̸��� ������ ����� ������ ���� �÷��� �μ� �ڵ�, ���� �ڵ带 ����
-- �μ� �ڵ�� ���� �ڵ��� ������ �׿� ����
-- �÷��� ������� �ùٸ� �÷������� ������ �� ����

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT 'D5', 'J5' FROM EMPLOYEE); --/ ����

SELECT 'D5', 'J5' FROM EMPLOYEE; --/ ���ͷ��� ���̺���� ���� ���� ���� ���̴�?
--/ SELECT �ڿ� ���� �� �÷���, �÷����� SELECT�� ���� �������� ���� ����
--/ �׷��Ÿ� ��ȸ�� �� ��.
--/ ���ͷ��� ������ ��� ���̺��� �࿡ ���ͷ� ���� ��


-- 2) �ڳ��� ����� ���� ���� �ڵ�, ���� ����� ������ �ִ� ������� ���, �����, ���� �ڵ�, ��� ��ȣ ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '�ڳ���');
-- ���� ������ ����� �ڳ����� �̸��� ���� ���� �����ڵ�� ��� �÷����� ���
--> �÷��� �� ��, ���� �ڳ��� ������ �� ��
--> ���� ���� WHERE�� ���ǽĿ� ���Ǵ� ���� �� ������ �� ���� �ۿ� ����

-- ������ ���߿� ���� ����
-- 1) �� ���޺� �ּ� �޿��� �޴� ��� ��ȸ(���, �����, ���� �ڵ�, �޿�)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE)
ORDER BY JOB_CODE;
-- ���޺��� �ּ� �޿��� �޴� ��� => ���� ������ ���޺� �ּ� �޿� ������ �ƿ� �ɷ��� ������
-- ���ް� �ּ� �޿� �÷��� �Բ� ������ �ӽ� ���̺� �� ���� �ϳ��� �ش�Ǵ� ��� ���
-- => ������ ���缭 ������� ��
-- IN���� ���� ���� �� �ϳ��� �ش�Ǵ� ��츦 ���, �ϳ��� ������ �Ǵ� �� �ƴ�
-- ������ �ٸ��� �� ������ �ּ� �޿��� ���� ���� �����ϱ� ������ ������� ��

-- �� �μ��� �ְ� �޿��� �޴� ������� ���, �����, �μ� �ڵ�, �޿�
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- �ζ��� �� : FROM ���� ���� ������ ���� ��츦 ����
-- �� : ������ ����Ǿ� �ִ� ���̺� ���� ����ڰ� ���ϴ� ���̺��� ������ ���� ����� �ӽ� ���̺�
-- ���� �ζ��� ��� ���� ������ ������� �ӽ� ���̺��� FROM���� �ҷ��ִ� ��

-- ������� ���, �̸�, ���ʽ� ���� ����, �μ� �ڵ� ��ȸ
-- ��, ���ʽ� ���� ������ NULL�� �Ǹ� �� �ȴ�.
-- ��, ���ʽ� ���� ������ 3000���� �̻��� ����鸸 ��ȸ
SELECT ROWNUM, EMP_ID, EMP_NAME, 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) AS "���ʽ�����", DEPT_CODE
FROM EMPLOYEE
WHERE 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) >= 30000000;

-- �� ���� �� �޿��� ���� ���� 5�� ��ȸ
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM BETWEEN 2 AND 10; --X

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- ���� �ֱٿ� �Ի��� ��� 5�� ��ȸ (�����, �޿�, �Ի���)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;
-- ROWNUM�� ������ 1���� �ε��� ���·� �����ϴ� �� ����. SQL�� JAVA�� �ٸ��� �ε����� ������ 1���� �����̶�� �ߴ�.
-- JAVA�� �ε����� ������ �Ѿ�� ���� �����ϱ�...
-- 1���� �����ϴ� ROWNUM�� 5 ���ϴϱ� ROWNUM�� 1���� 5������ ����� ����϶�� ����.

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC);

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM >= 5; -- X

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM BETWEEN 1 AND 10; -- O

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM BETWEEN 2 AND 10; -- X

SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM BETWEEN 2 AND 23; -- X

-- �� �μ��� ��� �޿��� ���� 3���� �μ� ��ȸ
SELECT DEPT_CODE, "��ձ޿�"
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "��ձ޿�"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC)
        -- �� ���� ���������� �����Ͱ� ��� ���� �׷����� ���� ����, ���̺��� EMPLOYEE�ϱ�
        -- �ٵ� ������� �׷����� ���� �����ͷ� ���� ��
        -- AVG(SALARY)�� �ᱹ �μ����� �ϳ��� ������ ���� ���� ��
        -- �׷��ϱ� �� ����� ��ü�� ���̺�� ���� ���� ������ �׷����� ���� ���� ����
        -- �̹� ���������� ġȯ�� ���´ϱ�
        -- �� ������� �����ʹ� �� ���̺� ���� ���� �ֳĸ� �׷����� ���� �����Ͱ� ������̴ϱ�!
GROUP BY DEPT_CODE
HAVING ROWNUM <= 3;

SELECT DEPT_CODE, "��� �޿�" --/ ���̿� ������ ���� ��� �ֵ���ǥ�� ������ ������ ������
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "��� �޿�"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;


SELECT DEPT_CODE, AVG(SALARY) AS "��ձ޿�"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC;
        
-- �μ��� ��� �޿��� 270������ �ʰ��ϴ� �μ��鿡 ���ؼ�
-- �μ��ڵ�, �μ��� �� �޿� ��, �μ��� ��� �޿�, �μ��� ����� ��ȸ
SELECT DEPT_CODE, SUM(SALARY), AVG(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 2700000;

SELECT DEPT_CODE, "�޿���", "�޿����", "�����"
FROM (SELECT DEPT_CODE, SUM(SALARY) AS "�޿���", AVG(SALARY) AS "�޿����", COUNT(*) AS "�����"
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY AVG(SALARY))
WHERE "�޿����" > 2700000;


-- �÷��� ������ �ű�� �Լ�
-- �޿��� ���� ������� ������ �Űܼ� ��ȸ


