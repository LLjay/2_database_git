/*
    *���� ���� (SUBQUERY)
    - �ϳ��� SQL�� �ȿ� ���Ե� �Ǵٸ� SELECT��
    - ���� SQL���� ���� ���� ������ �ϴ� ����
*/

-- ������ ���� ���� ����1
-- ���ö ����� ���� �μ��� ���� ����� ��ȸ

-- 1) ���ö ����� �μ� �ڵ�
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '���ö';

-- 2) �μ� �ڵ尡 D9�� ����� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- ���� �� �ܰ踦 �ϳ��� ���������� ����
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '���ö');
                   
-- ������ ���� ���� ����2
-- �� ������ ��� �޿����� �� ���� �޿��� �޴� ������� ���, �̸�, ���� �ڵ�, �޿� ��ȸ
-- 1) �� ������ ��� �޿�
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE; -- 3047663

-- 2) 3047663 ���� �� ���� �޿��� �޴� ������� ���, �̸�, ���� �ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- �� �ܰ踦 �ϳ��� ���ϱ�
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY))
                   FROM EMPLOYEE); --/ AVG�� ����� �ϳ�, �̷� ���� �񱳿��� ���� ��
                   
/*
    *���� ������ ����
    ���� ������ ������ ������� �� �� �� ���� �����Ŀ� ���� �з�
    
    -- ������ ���� ���� : ���� ������ ��ȸ ������� ������ ������ 1���� ��
    -- ������ ���� ���� : ���� ������ ��ȸ ������� ���� ���� ��(���� ��, �� ��) /�÷��� �ϳ�
    -- ���߿� ���� ���� : ���� ������ ��ȸ ������� �� �������� �÷��� ���� ���� ��
    -- ������ ���߿� ���� ���� : ���� ������ ��ȸ ������� ���� �� ���� �÷��� ��
    
    >> ���� ������ ������ �����̳Ŀ� ���� ���� ���� �տ� �ٴ� �����ڰ� �޶���
*/

/*
    1. ������ ���� ����
    ���� ������ ��ȸ ������� ������ ������ 1���� �� (�����ѿ�)
    �Ϲ� �񱳿����� ��� ����
    = != > <= ...
*/

-- 1) �� ������ ��� �޿����� �޿��� �� ���� �޴� ������� �����, �����ڵ�, �޿� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
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

-- 6) '������' ����� ���� �μ��� ������� ���, �����, ��ȭ��ȣ, �Ի���, �μ����� ��ȸ
--    ��, ������ ����� ����
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������')
AND EMP_NAME != '������';

/*
    2. ������ ���� ����
    ���� ������ ������ ������� ���� ���� �� (�÷��� �� ��)
    
    IN (���� ����) : ���� ���� ����� �߿��� �� ���� ��ġ�ϴ� ���� �ִٸ� ��ȸ / �����
    > ANY (���� ����) : ���� ���� ����� �߿��� �� ���� Ŭ ��� / ��Һ�
    < ANY (���� ����) : ���� ���� ����� �߿��� �� ���� ���� ���
        �񱳴�� > ANY (���� ������ ����� => ��1, ��2, ��3...)
        �񱳴�� > ��1 OR �񱳴�� > ��2 OR �񱳴�� > ��3
        
    > ALL (���� ����) : ���� ���� ��� ������麸�� Ŭ ��� ��ȸ
    < ALL (���� ����) : ���� ���� ��� ������麸�� ���� ��� ��ȸ
        �񱳴�� > ALL (���� ������ ����� => ��1, ��2, ��3...)
        �񱳴�� > ��1 AND �񱳴�� > ��2 AND �񱳴�� > ��3...
*/
-- 1) ����� �Ǵ� ������ ����� ���� ������ ������� ���, �����, ���� �ڵ�, �޿� ��ȸ
-- 1-1) ����� �Ǵ� ������ ����� ���� �ڵ�
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('�����', '������');

-- 1-2) ������ J3, J7�� ����� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- �� ������ ���� ������ ���� ���ϱ�
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('�����', '������'));
                   
-- 2) �븮 �����ӿ��� ���� ���� �޿��� �� �ּ� �޿����� ���� �޴� ����� ��ȸ
-- ���, �̸�, ����, �޿�

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY > (SELECT MIN(SALARY)
              FROM EMPLOYEE
              JOIN JOB USING(JOB_CODE)
              WHERE JOB_NAME = '����'); --/ ���� ���� �� JOIN ����� �ϴ±���. ���� �ٸ� �����ϱ� �翬����.

-- ����� ����
-- 2-1. ���� ���� �޿�
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '����'

-- 2-2. �븮 �����̸鼭 ���� ��������� �ϳ��� ū ���
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '�븮'
  AND SALARY > ANY (SELECT SALARY
                 FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                 WHERE JOB_NAME = '����');
                 
-----------------------------------------------------------------------------------------------
/*
    3. ���߿� ���� ����
    ������� �� �������� ������ �÷� ���� ���� ���� ���
*/

-- 1) ������ ����� ���� �μ� �ڵ�, ���� ���� �ڵ忡 �ش��ϴ� ����� ��ȸ
-- �����, �μ� �ڵ�, ���� �ڵ�, �Ի���
--> ������ ���� ����
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������')
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '������');
--> ���߿� ���� ������ �ۼ�
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE --/ ���ϰ��� �ϴ� �÷��� ���� ������ SELECT �÷� ������ ��ġ�ؾ� ��
                                 FROM EMPLOYEE
                                WHERE EMP_NAME = '������');

-- 2) �ڳ��� ����� ���� ���� �ڵ�, ���� ����� ������ �ִ� ������� ���, �����, ���� �ڵ�, ��� ��ȣ ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '�ڳ���')
AND EMP_NAME != '�ڳ���';

-------------------------------------------------------------------------------------------------
/*
    4. ������ ���߿� ���� ����
    ���� ������ ��ȸ ������� ���� �� ���� ���� ���
*/

-- 1) �� ���޺� �ּ� �޿��� �޴� ��� ��ȸ(���, �����, ���� �ڵ�, �޿�)
--> �� ���޺� �ּ� �޿�
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

--> �� ���޺� �ּ� �޿��� �޴� ��� ��ȸ
--SELECT EMP_IDL EMP_NAME, JOB_CODE, SALARY
--FROM EMPLOYEE
--WHERE JOB_CODE = 'J2' AND SALARY = 3700000
--   OR JOB_CODE = 'J7' AND SALARY = 1380000
--   OR JOB_CODE = 'J7' AND SALARY = 3400000
--   ...

-- ���� ���� ����
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);
--/ �Ȱ��� �÷� ������ ��ġ�ؾ� �ϴµ�, �� ��Ʈ�� ���� �� �� �ϳ��� ��ġ�ϸ� �ȴٰ� IN���� �ɾ���

-- �� �μ��� �ְ� �޿��� �޴� ������� ���, �����, �μ� �ڵ�, �޿�
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                             FROM EMPLOYEE
                             GROUP BY DEPT_CODE); 
                             
-----------------------------------------------------------------------------------------
/*
    5. �ζ��� ��
    FROM ���� ���� ������ �ۼ��� ��
    ���� ������ ������ ����� ��ġ ���̺�ó�� ���
*/
/*
    
*/

-- ������� ���, �̸�, ���ʽ� ���� ����, �μ� �ڵ� ��ȸ
-- ��, ���ʽ� ���� ������ NULL�� �Ǹ� �� �ȴ�.
-- ��, ���ʽ� ���� ������ 3000���� �̻��� ����鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) AS "���ʽ�����", DEPT_CODE
FROM (SELECT *
     FROM EMPLOYEE
     WHERE (12 * ((SALARY * NVL(BONUS, 0)) + SALARY) >= 30000000);
     
SELECT ROWNUM, EMP_ID, EMP_NAME, 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) AS "���ʽ�����", DEPT_CODE
FROM EMPLOYEE
WHERE 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) >= 30000000
--/ FROM���� ȣ���� �� �̹� ROWNUM �̶�� �� �ο�
ORDER BY ���ʽ����� DESC;

--> �ζ��� �並 �ַ� ����ϴ� �� >> TOP-N �м� : ���� �� ���� ��ȸ
-- �� ���� �� �޿��� ���� ���� 5�� ��ȸ
-- ROWNUM : ����Ŭ���� �������ִ� �÷�, ��ȸ�� ������� 1���� ������ �ο����ִ� �÷�
--/ ROWNUM ������ ������ 1����, �ٸ� ������ ������ �� ����
--/ MYSQL������ ROWNUM�� ���� LIMIT�̶�� �ؼ� ���� �ɸ��� ���� ���� LIMIT 5; ó��

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--> ORDER BY ���� ����� ����� ������ ROWNUM �ο� -> ���� 5�� ��ȸ
SELECT EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC) --/ FROM ���� ���������� ����� ������ ���̺��� �ζ��κ�
WHERE ROWNUM <= 5;

--/ ROWNUM�� ��� FROM�� ȣ���ϴ� ���� �ڵ����� ù ��°���� �ο���
--/ ���ĵ� ���̺��� FROM���� ȣ���� ROWNUM�� �ٽ� �ٿ��ִ� ��




-- ���� �ֱٿ� �Ի��� ��� 5�� ��ȸ (�����, �޿�, �Ի���)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE --/ ��ȸ�ϰ� ���� �÷��� ���̺� �־�� �ϹǷ� ���⵵ ����� / *�� �����͵� ��
     FROM EMPLOYEE
     ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

--SELECT EMP_NAME, SALARY, HIRE_DATE
--FROM EMPLOYEE
--WHERE /�̰� �ζ��κ� ���� �� ���� ������

-- �� �μ��� ��� �޿��� ���� 3���� �μ� ��ȸ
SELECT DEPT_CODE, ��ձ޿� --/ AVG�� �Լ��� �ν��ϹǷ� �� �̸����� �� ���� ����
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "��ձ޿�" --/ ��Ī���� �ؾ� ��
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;

SELECT DEPT_CODE, AVG(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC;

-- �μ��� ��� �޿��� 270������ �ʰ��ϴ� �μ��鿡 ���ؼ�
-- �μ��ڵ�, �μ��� �� �޿� ��, �μ��� ��� �޿�, �μ��� ����� ��ȸ
--SELECT DEPT_CODE, SUM(SALARY), AVG(SALARY), COUNT(*)
--FROM (SELECT *
--        FROM EMPLOYEE
--        GROUP BY DEPT_CODE
--        WHERE AVG(SALARY) > 2700000)
--GROUP BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY), AVG(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 2700000
ORDER BY DEPT_CODE ASC;

SELECT *
FROM (SELECT DEPT_CODE, SUM(SALARY), AVG(SALARY) AS "���", COUNT(*)
        FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY DEPT_CODE ASC)
WHERE ��� >= 2700000;

-----------------------------------------------------------------------------
/*
    *�÷��� ������ �ű�� �Լ� (WINDOW FUNCTION)
    RANK() OVER(���� ����) | DANSE_RANK() OVER(���� ����)
    RANK() OVER(���� ����) : ������ ���� ������ ����� ������ �ο� ����ŭ �ǳʶٰ� ���� ���
    DANSE_RANK() OVER(���� ����) : ������ ������ �ִٰ� �ص� �� ���� ����� ������ 1�� ������Ŵ
    
    ������ SELECT �������� ��� ����
*/

-- �޿��� ���� ������� ������ �Űܼ� ��ȸ --/ �� �÷��� ������ �˰� ���� ��
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS "����"
FROM EMPLOYEE;
-- ���� 19�� 2�� �� ���� ����� 21������ �ϳ� �ǳʶ� ���� �� �� ����

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "����"
FROM EMPLOYEE;
--> 19���� ���������� �� �ڿ� 20���� �ٷ� ������ ���� �� �� �ִ�.

SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "����"
FROM EMPLOYEE)
WHERE ���� <= 5;