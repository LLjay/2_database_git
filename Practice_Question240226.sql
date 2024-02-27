-- 2) 나이 상 가장 막내의 사원 코드, 사원명, 나이, 부서명, 직급명
SELECT EMP_ID, EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'YY')),
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 2) >= ALL (SELECT SUBSTR(EMP_NO, 1, 2)
                                    FROM EMPLOYEE);
-- 다 1900년대생이라 그렇지, 2000년대생이 끼어 있으면 어떻게 하지?

-- 10) 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서명, 직급, 입사일, 순위 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, ROWNUM, 12 * ((SALARY * BONUS) + SALARY) AS "연봉"
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) DESC)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE ROWNUM <= 5;
-- 왜 2위 연봉이 NULL이 나오지?

-- 11) 부서별 급여 합이 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합 조회
-- 11-1) JOIN과 HAVING 사용
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE --/ 왜 DEPT_CODE는 안 되지? 어차피 같은 행으로 나오는거 아냐?
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2
                        FROM EMPLOYEE);


-- 11-2) 인라인 뷰 사용
SELECT DEPT_TITLE, "급여합"
FROM (SELECT DEPT_TITLE, SUM(SALARY) AS "급여합"
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
        GROUP BY DEPT_TITLE)
WHERE "급여합" > SUM("급여합") * 0.2;

-- 11-3) WITH 사용

-- 13) WITH를 이용하여 급여 합과 급여 평균 조회





-- JOIN 시 서로 일치하는 값이 없는 경우는 외래키를 가지고 있지 않은 경우인가?
