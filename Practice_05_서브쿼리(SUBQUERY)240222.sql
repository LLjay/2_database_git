-- 노옹철 사원과 같은 부서에 속한 사원들 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');

-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);

/*
    서브 쿼리의 결과에 따라 분류가 달라짐
    / 결과가 단일행인지, 다중행인지, 다중열인지, 다중행 다중열인지로 분류하는 것
    
    > 단일행 서브 쿼리 : 행과 열의 결과가 1개일 때
    > 다중행 서브 쿼리 : 조회 결과값이 컬럼은 1개고 컬럼값이 여러 개일 때
    > 다중열 서브 쿼리 : 조회 결과값이 행이 한 개고 결과 하나에 해당하는 컬럼값이 여러 개일 때
    > 다중행 다중열 서브 쿼리 : 조회 결과값이 여러 행 여러 컬럼일 때
*/

-- 단일행 서브 쿼리
-- 1) 전 직원의 평균 급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
-- AVG는 그룹 함수이고 아무런 그룹도 지어주지 않았으므로 전체가 하나의 그룹처럼 취급되어
-- 전 직원의 평균 결과 한 가지가 구해짐 => SALARY의 평균값 결과 한 가지가 나옴
-- 그 평균값 결과 한 가지와 SALARY는 비교 가능
-- SALARY가 평균보다 작은 사원들은 걸러내고 해당하는 사원들의 정보만 조회
-- / AVG(SALARY)는 SALARY 평균 결과 하나만 나오므로 단일행
                
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
--/EMPLOYEE의 DEPT_CODE를 기준으로 그룹으로 묶어주기 => 데이터가 DEPT_CODE 기준으로 출력될 것
--/ 그런데 그 그룹의 조건이? SUM(SALARY)가 최대값과 동일한 그룹
--/ 그치... 그룹의 SALARY 합이 저것과 같다고 해야 하니까
--/ WHERE는 모든 행에 대한 조건을 붙여주는 것
--/ HAVING은 묶은 그룹들의 데이터 즉 그룹함수 결과나 그룹의 카운트 등에 대한 조건을 붙여주는 것
--/ 여기서는 부서별 급여 합이 가장 큰 부서라고 했으니까 부서별로 그룹 지어서 급여 합 결과가 나옴
--/ 따라서 각각 개인에 대한 결과가 아닌 것, WHERE절로는 사용할 수 없는 조건
--/ 그룹에 대한 조건이므로 HAVING으로 조건을 붙여줘야 함
--/ 각 행의 개인의 데이터에 대한 조건이 아니다!!!
--/ 그룹에 대한 결과는 그룹에 대한 조건으로 붙을 수 있다!!!

-- 6) '전지연' 사원과 같은 부서의 사람들의 사번, 사원명, 전화번호, 입사일, 부서명을 조회
--    단, 전지연 사원은 제외
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_CODE = (SELECT DEPT_CODE --/ DEPT_CODE와 서브 쿼리의 결과값을 비교할 것이기 때문에 컬럼이 같아야 올바른 결과를 조회할 수 있음
                FROM EMPLOYEE
                WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';
-- DEPT_CODE가 서브 쿼리의 결과값과 같을 때, 즉 전지연이라는 컬럼값을 가진 부서 코드와 같을 때
-- 하지만 거기서 '전지연'이라는 컬럼값이 있는 행은 조회하지 않겠다.

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';
-- 부서 코드를 조회하겠다.
-- 단 EMP_NAME의 컬럼값이 '전지연'인 행의 부서 코드.

-- 다중행 서브 쿼리
-- 1) 유재식 또는 윤은해 사원과 같은 직급인 사원들의 사번, 사원명, 직급 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME IN ('유재식', '윤은해'));
-- JOB_CODE 즉 컬럼이 하나(같은 직급을 구함)
-- JOB_CODE에 해당하는 결과값이 여러 개(유재식 또는 윤은해)
-- 사원들의 결과가 궁금함 => 직급 코드가 둘 중 하나와 같으면 조회
-- 따라서 IN 절로 결과를 구함
-- OR로 일일이 유재식과 같다 또는 윤은해와 같다로 구할 수도 있지만
-- 서브 쿼리가 두 개 필요해지므로 IN절로 합쳐서 구해줌

-- 2) 대리 직급임에도 과장 직급 급여들 중 최소 급여보다 많이 받는 사원들 조회
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > (SELECT MIN(SALARY)
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '과장');

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');


--
--SELECT EMP_NAME, SALARY
--FROM EMPLOYEE
--WHERE SALARY > ANY BETWEEN 2000000 AND 2500000;

-- 직급 코드가 J4인 직원들의 최고 급여 보다 많이 받는 사원들 조회
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

-- 다중열 서브 쿼리
-- 1) 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들 조회
-- 사원명, 부서 코드, 직급 코드, 입사일
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '하이유');
-- 이름이 하이유 사원인 조건을 가진 컬럼의 부서 코드, 직급 코드를 추출
-- 부서 코드와 직급 코드의 조건이 그와 같음
-- 컬럼을 맞춰줘야 올바른 컬럼값으로 대조할 수 있음

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT 'D5', 'J5' FROM EMPLOYEE); --/ 오류

SELECT 'D5', 'J5' FROM EMPLOYEE; --/ 리터럴은 테이블과는 전혀 관계 없는 값이다?
--/ SELECT 뒤에 들어가는 건 컬럼명, 컬럼값을 SELECT에 직접 지정해줄 수는 없음
--/ 그럴거면 조회를 왜 해.
--/ 리터럴을 넣으면 모든 테이블의 행에 리터럴 값이 들어감


-- 2) 박나라 사원과 같은 직급 코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급 코드, 사수 번호 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라');
-- 서브 쿼리의 결과가 박나라라는 이름을 가진 행의 직급코드와 사수 컬럼값을 출력
--> 컬럼은 두 개, 행은 박나라 데이터 한 개
--> 따라서 메인 WHERE의 조건식에 사용되는 값은 행 데이터 한 가지 밖에 없음

-- 다중행 다중열 서브 쿼리
-- 1) 각 직급별 최소 급여를 받는 사원 조회(사번, 사원명, 직급 코드, 급여)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE)
ORDER BY JOB_CODE;
-- 직급별로 최소 급여를 받는 사원 => 서브 쿼리에 직급별 최소 급여 조건을 아예 걸러서 보여줌
-- 직급과 최소 급여 컬럼을 함께 가지는 임시 테이블 중 값이 하나라도 해당되는 경우 출력
-- => 형식을 맞춰서 보여줘야 함
-- IN절로 여러 값들 중 하나라도 해당되는 경우를 출력, 하나만 맞으면 되는 게 아님
-- 직급이 다른데 그 직급의 최소 급여와 같을 수도 있으니까 쌍으로 묶어줘야 함

-- 각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서 코드, 급여
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- 인라인 뷰 : FROM 절에 서브 쿼리가 들어가는 경우를 말함
-- 뷰 : 기존에 저장되어 있는 테이블 말고 사용자가 원하는 테이블의 정보를 엮어 만드는 임시 테이블
-- 따라서 인라인 뷰는 서브 쿼리로 만들어준 임시 테이블을 FROM으로 불러주는 것

-- 사원들의 사번, 이름, 보너스 포함 연봉, 부서 코드 조회
-- 단, 보너스 포함 연봉은 NULL이 되면 안 된다.
-- 단, 보너스 포함 연봉이 3000만원 이상인 사원들만 조회
SELECT ROWNUM, EMP_ID, EMP_NAME, 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) AS "보너스연봉", DEPT_CODE
FROM EMPLOYEE
WHERE 12 * ((SALARY * NVL(BONUS, 0)) + SALARY) >= 30000000;

-- 전 직원 중 급여가 가장 높은 5명만 조회
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

-- 가장 최근에 입사한 사원 5명 조회 (사원명, 급여, 입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;
-- ROWNUM이 무조건 1부터 인덱스 형태로 시작하는 것 같다. SQL은 JAVA와 다르게 인덱스가 무조건 1부터 시작이라고 했다.
-- JAVA도 인덱스가 음수로 넘어가는 경우는 없으니까...
-- 1부터 시작하는 ROWNUM이 5 이하니까 ROWNUM이 1부터 5까지인 결과를 출력하라는 거지.

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

-- 각 부서별 평균 급여가 높은 3개의 부서 조회
SELECT DEPT_CODE, "평균급여"
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "평균급여"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC)
        -- 이 서브 쿼리에서는 데이터가 모든 행이 그룹으로 묶인 상태, 테이블이 EMPLOYEE니까
        -- 근데 결과값은 그룹으로 묶인 데이터로 나올 것
        -- AVG(SALARY)도 결국 부서별로 하나의 데이터 값만 나올 것
        -- 그러니까 이 결과값 자체를 테이블로 쓰는 메인 쿼리는 그룹으로 묶을 수가 없음
        -- 이미 단일행으로 치환된 상태니까
        -- 각 사원들의 데이터는 이 테이블에 없는 상태 왜냐면 그룹으로 묶인 데이터가 결과값이니까!
GROUP BY DEPT_CODE
HAVING ROWNUM <= 3;

SELECT DEPT_CODE, "평균 급여" --/ 사이에 공백이 있을 경우 쌍따옴표를 써주지 않으면 오류남
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "평균 급여"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;


SELECT DEPT_CODE, AVG(SALARY) AS "평균급여"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY AVG(SALARY) DESC;
        
-- 부서별 평균 급여가 270만원을 초과하는 부서들에 대해서
-- 부서코드, 부서별 총 급여 합, 부서별 평균 급여, 부서별 사원수 조회
SELECT DEPT_CODE, SUM(SALARY), AVG(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 2700000;

SELECT DEPT_CODE, "급여합", "급여평균", "사원수"
FROM (SELECT DEPT_CODE, SUM(SALARY) AS "급여합", AVG(SALARY) AS "급여평균", COUNT(*) AS "사원수"
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY AVG(SALARY))
WHERE "급여평균" > 2700000;


-- 컬럼에 순위를 매기는 함수
-- 급여가 높은 순서대로 순위를 매겨서 조회


