-- 2) ���� �� ���� ������ ��� �ڵ�, �����, ����, �μ���, ���޸�
SELECT EMP_ID, EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'YY')),
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 2) >= ALL (SELECT SUBSTR(EMP_NO, 1, 2)
                                    FROM EMPLOYEE);
-- �� 1900�����̶� �׷���, 2000������ ���� ������ ��� ����?

-- 10) ���ʽ� ������ ������ ���� 5���� ���, �̸�, �μ���, ����, �Ի���, ���� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, ROWNUM, 12 * ((SALARY * BONUS) + SALARY) AS "����"
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) DESC)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE ROWNUM <= 5;
-- �� 2�� ������ NULL�� ������?

-- 11) �μ��� �޿� ���� ��ü �޿� �� ���� 20%���� ���� �μ��� �μ���, �μ��� �޿� �� ��ȸ
-- 11-1) JOIN�� HAVING ���
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE --/ �� DEPT_CODE�� �� ����? ������ ���� ������ �����°� �Ƴ�?
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2
                        FROM EMPLOYEE);


-- 11-2) �ζ��� �� ���
SELECT DEPT_TITLE, "�޿���"
FROM (SELECT DEPT_TITLE, SUM(SALARY) AS "�޿���"
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        GROUP BY DEPT_TITLE)
WHERE "�޿���" > SUM("�޿���") * 0.2;

-- 11-3) WITH ���

-- 13) WITH�� �̿��Ͽ� �޿� �հ� �޿� ��� ��ȸ





-- JOIN �� ���� ��ġ�ϴ� ���� ���� ���� �ܷ�Ű�� ������ ���� ���� ����ΰ�?
