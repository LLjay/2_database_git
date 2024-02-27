/*
    <GROUP BY절>
    그룹 기준을 제시할 수 있는 구문 (해당 그룹 기준별로 여러 그룹으로 묶을 수 있음)
    여러 개의 값들을 하나의 그룹으로 묶어서 처리하는 목적으로 사용
*/

-- 각 부서별 총 급여
-- 각 부서들이 전부 그룹
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- DEPT_CODE를 같은 값을 가진 행끼리 같이 묶어 모아둠

-- 각 부서별 사원수
SELECT COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE 
GROUP BY DEPT_CODE; --/ 이건 이미 그룹이 지어진 상태이므로 그 기준으로 구해짐, 가능

--SELECT DEPT_CODE, COUNT(*)
--FROM EMPLOYEE; --/ 이건 그룹 함수와 각 행이 섞이므로 안 됨

SELECT DEPT_CODE, COUNT(*), SUM(SALARY) ----- 3
FROM EMPLOYEE ----- 1
GROUP BY DEPT_CODE ----- 2
ORDER BY DEPT_CODE; ----- 4

-- 각 직급별 총 사원수, 보너스를 받는 사원 수, 급여 합, 평균 급여, 최저 급여, 최고 급여 (정렬 : 직급 오름차순)
SELECT JOB_CODE AS "직급", COUNT(*) AS "총 사원수"
        , COUNT(BONUS) AS "보너스를 받는 사원수"
        , SUM(SALARY) AS "급여 합", ROUND(AVG(SALARY)) AS "평균 급여"
        , MIN(SALARY) AS "최저 급여", MAX(SALARY) AS "최고 급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE; --/ 됨
SELECT SALARY
FROM EMPLOYEE
GROUP BY DEPT_CODE;--/ 안 됨

-- GROUP BY 절에 함수식 사용 가능 
-- 남자 사원의 수, 여자 사원의 수
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별", COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);
--/ 그룹 바이에 들어갈 수 있는 건 컬럼별로 그룹만 잘 나눠지면 됨

-- GROUP BY 절에 여러 컬럼 기술 가능
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE; --/ 그룹을 중복해서 지어줄 때는 두 그룹이 한 쌍

-------------------------------------------------------------------------

/*
    [HAVING 절]
    그룹에 대한 조건을 제시할 때 사용하는 구문 (주로 그룹함수식을 가지고 조건을 만듦)
*/

-- 각 부서별 평균 급여 조회(부서 코드, 평균 급여)
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 부서들만 조회 (부서 코드, 평균 급여)
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
--WHERE AVG(SALARY) >= 3000000; => 오류남, WHERE은 모든 행에 대한 조건을 쓰는 것
HAVING AVG(SALARY) >= 3000000;

--------------------------------------------------------------------

-- 직급별 직급 코드, 총 급여 합(단 직급별 급여 합이 천만 원 이상인 직급만 조회)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 부서별 보너스를 받는 사원이 없는 부서의 부서 코드
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
    SELECT * | 조회하고 싶은 컬럼 AS 별칭 | 함수식 | 산술연산식 ----- 5
    FROM 조회하고자 하는 테이블 | DUAL    ----- 1
    WHERE 조건식 (연산자들을 활용하여 기술) / 각 행에 대한 조건 ----- 2
    GROUP BY 그룹 기준이 되는 컬럼 | 함수식 ----- 3
    HAVING 조건식 (그룹 함수로 기술) ----- 4
    ORDER BY 컬럼 | 별칭 | 순서 [ASC | DESC] [NULLS FIRST | NULLS LAST] ----- 6
*/
--/ 무조건 가져오는 게 먼저, 그 다음에 조건 걸어주기, 걸어준 것들을 가지고 다시 그룹으로 묶기,
--/ 그룹으로 묶은 것들로 다시 조건 걸고 가져오고 싶은 것들을 선택 후 정렬
--/ 쿼리를 쓰는 경우 나중에는 데이터를 어디까지 끊어 쓸 것인가를 고민하게 됨
--/ 테이블을 여러 개 뭉쳐서 가져올 수 있게 됨, 그 적정선이 속도가 최대치고 에러가 안 나는 정도의 양으로 가져와야 함
--/ 서비스화가 이미 되어 있는 회사를 들어가는 게 좋음, 0.3초 안에 끊어져야 하는데 어느 부분에서는 속도가 확 늘어남
--/ 그걸 그렇게 되지 않도록 나중에 쪼개고 경험을 쌓게 됨




/*
    집합 연산자 == SET OPERATION
    여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자

    - UNION : OR | 합집합(두 쿼리문 수행한 결과값을 더한다)
    - INTERSECT : AND | 교집합(두 쿼리문을 수행한 결과값 중 중복된 결과값
    - UNION ALL : 합집합 + 교집합 (중복되는 게 두 번 표현될 수 있다.
    - MINUS : 차집합(선행 결과값에 후행 결과값을 뺀 나머지)
*/

-- 1. UNION (중복은 제거됨)
-- 부서 코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 사번, 이름, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5') OR SALARY > 3000000;

-- 부서 코드가 D5인 사원들의 사번, 이름, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5');

-- 급여가 300만원 초과인 사원들의 사번, 이름, 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION으로 합하기
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION --/ 사실 쿼리는 두 개인데 그냥 둘을 합쳐주는 것
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--/ 쿼리가 길어지면 OR로 깔끔하게 잘 안 나눠 떨어질 때가 있음, 그럴 때 UNION으로 합쳐줌

-- 2. INTERSECT(교집합) (중복만 추출)
-- 부서 코드가 D5이면서 급여도 300만원 초과인 사원들의 사번, 이름, 부서 코드, 급여 조회
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
-- 집합 연산자 사용 시 주의사항
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION --/ 사실 쿼리는 두 개인데 그냥 둘을 합쳐주는 것
SELECT EMP_ID, EMP_NAME, DEPT_CODE --/ SALARY를 지운 경우 오류남
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- 컬럼의 개수는 똑같아야 함

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION 
SELECT EMP_ID, EMAIL, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY > 3000000;
--/ 개수가 똑같으면 EMP_NAME 자리에 EMAIL 컬럼값이 포함된 형태로 들어감
--/ 만약 조건을 둘 다 만족하면 EMP_NAME, EMAIL 포함해 결과가 둘 나옴

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- 컬럼 자리마다 동일한 타입으로 기술해야 한다.

--------------------------------------------------------------------------
-- 3. UNION ALL : 여러 개의 쿼리 결과를 무조건 다 더하는 연산자 (중복 제거 안 됨)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_ID;
--/ 둘 다 만족하면 결과가 중복이어도 둘 다 가져옴

-- 4. MINUS : 선생 SELECT 결과에서 후행 SELECT 결과를 뺀 나머지(차집합) (중복을 뺌)
-- 부서 코드가 D5인 사원들 중 급여가 300만원 초과인 사원들을 제외하고 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5')
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_ID;

