/*
    *서브 쿼리 (SUBQUERY)
    - 하나의 SQL문 안에 포함된 또다른 SELECT문
    - 메인 SQL문을 위해 보조 역할을 하는 쿼리
*/

-- 간단한 서브 쿼리 예시1
-- 노옹철 사원과 같은 부서에 속한 사원들 조회

-- 1) 노옹철 사원의 부서 코드
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 부서 코드가 D9인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 두 단계를 하나의 쿼리문으로 저장
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '노옹철');
                   
-- 간단한 서브 쿼리 예시2
-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
-- 1) 전 직원의 평균 급여
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE; -- 3047663

-- 2) 3047663 보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- 두 단계를 하나로 합하기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY))
                   FROM EMPLOYEE); --/ AVG의 결과가 하나, 이럴 때는 비교연산 많이 씀
                   
/*
    *서브 쿼리의 구분
    서브 쿼리를 수행한 결과값이 몇 행 몇 열로 나오냐에 따라서 분류
    
    -- 단일행 서브 쿼리 : 서브 쿼리의 조회 결과값의 개수가 오로지 1개일 때
    -- 다중행 서브 쿼리 : 서브 쿼리의 조회 결과값이 여러 행일 때(여러 행, 한 열) /컬럼이 하나
    -- 다중열 서브 쿼리 : 서브 쿼리의 조회 결과값이 한 행이지만 컬럼이 여러 개일 때
    -- 다중행 다중열 서브 쿼리 : 서브 쿼리의 조회 결과값이 여러 행 여러 컬럼일 때
    
    >> 서브 쿼리의 종류가 무엇이냐에 따라서 서브 쿼리 앞에 붙는 연산자가 달라짐
*/

/*
    1. 단일행 서브 쿼리
    서브 쿼리의 조회 결과값의 개수가 오로지 1개일 때 (한행한열)
    일반 비교연산자 사용 가능
    = != > <= ...
*/

-- 1) 전 직원의 평균 급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
-- 2) 최저 급여를 받는 사원의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);

-- 3) 노옹철 사원의 급여보다 많이 받는 사원들의 사번, 이름, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- 4) 노옹철 사원의 급여보다 많이 받는 사원들의 사번, 이름, 부서명, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- 5) 부서별 급여 합이 가장 큰 부서의 부서 코드 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

-- 6) '전지연' 사원과 같은 부서의 사람들의 사번, 사원명, 전화번호, 입사일, 부서명을 조회
--    단, 전지연 사원은 제외
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';

/*
    2. 다중행 서브 쿼리
    서브 쿼리를 수행한 결과값이 여러 행일 때 (컬럼은 한 개)
    
    IN (서브 쿼리) : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면 조회 / 동등비교
    > ANY (서브 쿼리) : 여러 개의 결과값 중에서 한 개라도 클 경우 / 대소비교
    < ANY (서브 쿼리) : 여러 개의 결과값 중에서 한 개라도 작을 경우
        비교대상 > ANY (서브 쿼리의 결과값 => 값1, 값2, 값3...)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
        
    > ALL (서브 쿼리) : 여러 개의 모든 결과값들보다 클 경우 조회
    < ALL (서브 쿼리) : 여러 개의 모든 결과값들보다 작을 경우 조회
        비교대상 > ALL (서브 쿼리의 결과값 => 값1, 값2, 값3...)
        비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3...
*/
-- 1) 유재식 또는 윤은해 사원과 같은 직급인 사원들의 사번, 사원명, 직급 코드, 급여 조회
-- 1-1) 유재식 또는 윤은해 사원의 직급 코드
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('유재식', '윤은해');

-- 1-2) 직급이 J3, J7인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 두 쿼리를 서브 쿼리를 통해 합하기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('유재식', '윤은해'));
                   
-- 2) 대리 직급임에도 과장 직급 급여들 중 최소 급여보다 많이 받는 사원들 조회
-- 사번, 이름, 직급, 급여

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > (SELECT MIN(SALARY)
              FROM EMPLOYEE
              JOIN JOB USING(JOB_CODE)
              WHERE JOB_NAME = '과장'); --/ 양쪽 쿼리 다 JOIN 해줘야 하는구나. 서로 다른 쿼리니까 당연하지.

-- 강사님 예시
-- 2-1. 과장 직급 급여
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'

-- 2-2. 대리 직급이면서 위의 결과값보다 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
  AND SALARY > ANY (SELECT SALARY
                 FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                 WHERE JOB_NAME = '과장');
                 
-----------------------------------------------------------------------------------------------
/*
    3. 다중열 서브 쿼리
    결과값은 한 행이지만 나열된 컬럼 수가 여러 개일 경우
*/

-- 1) 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들 조회
-- 사원명, 부서 코드, 직급 코드, 입사일
--> 단일행 서브 쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '하이유')
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '하이유');
--> 다중열 서브 쿼리로 작성
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE --/ 구하고자 하는 컬럼과 서브 쿼리의 SELECT 컬럼 순서가 일치해야 함
                                 FROM EMPLOYEE
                                WHERE EMP_NAME = '하이유');

-- 2) 박나라 사원과 같은 직급 코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급 코드, 사수 번호 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '박나라')
AND EMP_NAME != '박나라';

-------------------------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브 쿼리
    서브 쿼리의 조회 결과값이 여러 행 여러 열일 경우
*/

-- 1) 각 직급별 최소 급여를 받는 사원 조회(사번, 사원명, 직급 코드, 급여)
--> 각 직급별 최소 급여
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

--> 각 직급별 최소 급여를 받는 사원 조회
--SELECT EMP_IDL EMP_NAME, JOB_CODE, SALARY
--FROM EMPLOYEE
--WHERE JOB_CODE = 'J2' AND SALARY = 3700000
--   OR JOB_CODE = 'J7' AND SALARY = 1380000
--   OR JOB_CODE = 'J7' AND SALARY = 3400000
--   ...

-- 서브 쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);
--/ 똑같이 컬럼 순서는 일치해야 하는데, 이 세트가 여러 행 중 하나와 일치하면 된다고 IN절을 걸어줌

-- 각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서 코드, 급여
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                             FROM EMPLOYEE
                             GROUP BY DEPT_CODE); 
                             
-----------------------------------------------------------------------------------------
/*
    5. 인라인 뷰
    FROM 절에 서브 쿼리를 작성한 것
    서브 쿼리를 수행한 결과를 마치 테이블처럼 사용
*/
/*
    
*/

-- 사원들의 사번, 이름, 보너스 포함 연봉, 부서 코드 조회
-- 단, 보너스 포함 연봉은 NULL이 되면 안 된다.
-- 단, 보너스 포함 연봉이 3000만원 이상인 사원들만 조회
SELECT EMP_ID, EMP_NAME, 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) AS "보너스연봉", DEPT_CODE
FROM (SELECT *
     FROM EMPLOYEE
     WHERE (12 * ((SALARY * NVL(BONUS, 0)) + SALARY) >= 30000000);
     
SELECT ROWNUM, EMP_ID, EMP_NAME, 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) AS "보너스연봉", DEPT_CODE
FROM EMPLOYEE
WHERE 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) >= 30000000
--/ FROM절을 호출할 때 이미 ROWNUM 이라는 걸 부여
ORDER BY 보너스연봉 DESC;

--> 인라인 뷰를 주로 사용하는 예 >> TOP-N 분석 : 상위 몇 개만 조회
-- 전 직원 중 급여가 가장 높은 5명만 조회
-- ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
--/ ROWNUM 시작은 무조건 1부터, 다른 수부터 시작할 수 없음
--/ MYSQL에서는 ROWNUM이 없고 LIMIT이라고 해서 리밋 걸리는 수만 써줌 LIMIT 5; 처럼

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--> ORDER BY 절이 수행된 결과를 가지고 ROWNUM 부여 -> 상위 5명 조회
SELECT EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC) --/ FROM 절에 서브쿼리를 사용해 가져온 테이블이 인라인뷰
WHERE ROWNUM <= 5;

--/ ROWNUM은 모든 FROM을 호출하는 순간 자동으로 첫 번째부터 부여됨
--/ 정렬된 테이블을 FROM에서 호출해 ROWNUM을 다시 붙여주는 것




-- 가장 최근에 입사한 사원 5명 조회 (사원명, 급여, 입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE --/ 조회하고 싶은 컬럼이 테이블에 있어야 하므로 여기도 써야함 / *로 가져와도 됨
     FROM EMPLOYEE
     ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

--SELECT EMP_NAME, SALARY, HIRE_DATE
--FROM EMPLOYEE
--WHERE /이걸 인라인뷰 없이 할 수가 없구나

-- 각 부서별 평균 급여가 높은 3개의 부서 조회
SELECT DEPT_CODE, 평균급여 --/ AVG를 함수로 인식하므로 이 이름으로 쓸 수가 없음
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "평균급여" --/ 별칭으로 해야 함
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;

SELECT DEPT_CODE, AVG(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC;

-- 부서별 평균 급여가 270만원을 초과하는 부서들에 대해서
-- 부서코드, 부서별 총 급여 합, 부서별 평균 급여, 부서별 사원수 조회
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
FROM (SELECT DEPT_CODE, SUM(SALARY), AVG(SALARY) AS "평균", COUNT(*)
        FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY DEPT_CODE ASC)
WHERE 평균 >= 2700000;

-----------------------------------------------------------------------------
/*
    *컬럼에 순위를 매기는 함수 (WINDOW FUNCTION)
    RANK() OVER(정렬 기준) | DANSE_RANK() OVER(정렬 기준)
    RANK() OVER(정렬 기준) : 동일한 순위 이후의 등수를 동일한 인원 수만큼 건너뛰고 순위 계산
    DANSE_RANK() OVER(정렬 기준) : 동일한 순위가 있다고 해도 그 다음 등수를 무조건 1씩 증가시킴
    
    무조건 SELECT 절에서만 사용 가능
*/

-- 급여가 높은 순서대로 순위를 매겨서 조회 --/ 각 컬럼의 순위가 알고 싶은 것
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE;
-- 공동 19등 2명 그 뒤의 등수는 21등으로 하나 건너뛴 것을 알 수 있음

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE;
--> 19등이 공동이지만 그 뒤에 20등이 바로 나오는 것을 알 수 있다.

SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE)
WHERE 순위 <= 5;