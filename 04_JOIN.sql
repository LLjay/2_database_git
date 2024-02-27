/*
    <JOIN>
    두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    조회 결과는 하나의 결과물(RESULT SET)로 나옴
    /JAVA에서 데이터를 받을 때 이 RESULT SET이라는 객체로 받음
    
    관계형 데이터베이스에서는 최소한의 데이터를 각각의 테이블에 담고 있음
    (중복 저장을 최소화하기 위해서 최대한 쪼개서 관리함)
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블 간 "관계"를 맺는 방법
    (무작정 다 조회해 오는 게 아니라 각 테이블 간 연결고리(외래키)를 통해 데이터를 매칭 시켜 조회해야 한다.)
    JOIN은 크게 "오라클 전용 구문"과 "ANSI 구문"(ANSI == 미국국립표준협회)
    
    [용어 정리]
    
                오라클 전용 구문           |             ANSI 구문
    ---------------------------------------------------------------------------
                등가 조인                 |             내부조인       
                (EQULA JOIN)            |  (INNER JOIN => JOIN USING/ON)
    ---------------------------------------------------------------------------
                포괄 조인                 |   왼쪽 외부 조인 (LEFT OUTER JOIN)
                (LEFT OUTER)            |   오른쪽 외부 조인 (RIGHT OUTER JOIN)
                (RIGHT OUTER)           |   전체 외부 조인 (FULL OUTER JOIN)
    ---------------------------------------------------------------------------
                자체 조인(SELF JOIN)      |             JOIN ON   
            비등가 조인(NON EQUAL JOIN)   | 
    ---------------------------------------------------------------------------
*/

-- 전체 사원들의 사번, 사원명, 부서 코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 전체 사원들의 사번, 사원명, 직급 코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

/*
    1. 등가 조인 (EQUAL JOIN) / 내부 조인(INNER JOIN)
    연결시키는 컬럼의 값이 일치하는 행들만 조회 (== 일치하는 값이 없는 행은 조회 제외)
    / DEPT_CODE가 NULL인 사람들은 조회하면 제외시킴
*/

-- 오라클 전용 구문
-- FROM 절에 조회하고자 하는 테이블을 나열 (,로 구분)
-- WHERE 절에 매칭 시킬 컬럼에 대한 조건을 제시

-- 1) 연결할 두 컬럼명이 다른 경우 (EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID)
-- 전체 사원들의 사번, 사원명, 부서 코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT --/ 여기까진 아직 매칭 안 된 상태고 매칭을 시켜줘야 함
WHERE DEPT_CODE = DEPT_ID; --/ 서로 매칭, 매칭된 새 테이블을 만듦

-- NULL, D3, D4, D7 데이터는 한쪽 테이블에서만 존재하기 때문에 제외된 것을 알 수 있다.
-- 일치하는 값이 없는 행은 조회에서 제외된 것을 확인할 수 있다.

-- 2) 연결할 두 컬럼명이 같은 경우 (EMPLOYEE : JOB_CODE / JOB : JOB_CODE)
-- 전체 사원들의 사번, 사원명, 직급 코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
--/ 별칭 사용도 가능

--------------------------ANSI 구분---------------------------
-- FROM 절의 기준이 되는 테이블 하나 기술
-- JOIN 절에 같이 조인하고자 하는 테이블 기술 + 매칭 시킬 컬럼에 대한 조건도 기술
-- JOIN USING / JOIN ON

-- 1. 연결할 두 컬럼명이 다른 경우(EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID)
-- JOIN ON
-- 전체 사원들의 사번, 사원명, 부서 코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE --/ 이 테이블이 기준이다.
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 두 컬럼명이 같은 경우 (EMPLOYEE : JOB_CODE / JOB : JOB_CODE)
-- 전체 사원들의 사번, 사원명, 직급 코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE); --/ 컬럼명이 같을 때는 USING도 무관, 다를 때는 무조건 ON
-- JOIN USING 같은 경우 연결하는 컬럼명이 같은 때만 사용 가능

-- 추가적인 조건도 제시
-- 직급이 대리인 사원의 사번, 사원명, 직급명, 급여 조회
-- 오라클 구문
SELECT EMP_ID, EMP_NAME, J.JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND J.JOB_NAME = '대리';
--/ 이 조건이 키인지 조건인지 헷갈릴 수가 있음

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J USING (JOB_CODE)
WHERE J.JOB_NAME = '대리';

----------------------------------문제-----------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름, 보너스를 조회
--> 오라클
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE = '인사관리부';

--> ANSI
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

-- 2. DEPARTMENT와 LOCATION 테이블을 참고하여 전체 부서의 부서 코드, 부서명, 지역 코드, 지역명 조회
--> 오라클
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

--> ANSI
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID);

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--> 오라클
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_ID = DEPT_CODE AND BONUS IS NOT NULL;

--> ANSI
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여 조회
--> 오라클
SELECT EMP_NAME, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_ID = DEPT_CODE AND DEPT_TITLE != '총무부';

--> ANSI
SELECT DEPT_ID, EMP_NAME, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE DEPT_TITLE != '총무부'
ORDER BY DEPT_ID;



----------------------------------------------------------------------------
/*
    2. 포괄 조인 / 외부 조인 (OUTER JOIN)
    두 테이블 간의 JOIN 시 일치하지 않는 행도 포함시켜 조회 가능
    단, 반드시 LEFT/RIGHT를 지정해야 한다.(기준 테이블을 정해야 한다.)
*/

-- 사원명, 부서명, 급여, 연봉
-- 내부 조인 시 부서 배치를 받지 않은 2명의 사원 정보가 누락된다.
SELECT *
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--/ 조회 시 전체 사원을 보고 싶은데 JOIN으로 누락되는 경우가 생김, 그럴 때 사용하는 것

-- 1) LEFT_JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN
-- 오라클
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); --/ 왼쪽에 있는 테이블이 기준이라고 명시해주는 것
--/ 원래 내부조인은 이쪽 테이블에서 하나, 그에 맞는 다른 테이블 정보 하나를 일일이 가져옴
--/ 외부조인은 기준 테이블 전체를 다 가져온 후에 다른 테이블 정보를 기입하는 것
--/ 기준 되는 테이블 = 추가할 테이블(+)

-- ANSI
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) RIGHT JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
-- 오라클
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- ANSI
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--/ 원래 풀명은 LEFT OUTER JOIN, RIGHT OUTER JOIN => 보통 OUTER는 생략

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회할 수 있다(오라클X)
-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

----------------------------------------------------------------------
/*
    3. 비등가 조인(NON EQUAL JOIN)
    매칭 시킬 컬럼에 대한 조건 작성 시 '='을 사용하지 않는 조인문
    ANSI 구문으로는 JOIN ON /USING은 사용 불가
*/

-- 사원명, 급여, 급여 레벨
--/ 외래키가 없어 강제로 테이블을 서로 매칭 시키는 게 비등가 조인
-- 오라클 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;
--/ 우리가 상식적으로 눈으로 보고 한 것들을 조건으로 걸어줌, 현업에서 많이 쓰지는 않음

-- ANSI 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY >= MIN_SAL AND SALARY <= MAX_SAL);
--/ ON(조건이 들어가는 자리) 이므로 이렇게 넣어서 비등가 조인 해도 됨

-----------------------------------------------------------------------------
/*
    4. 자체 조인(SELF JOIN)
    같은 테이블을 다시 한 번 조인하는 경우
*/
--/ 외래키로 내 테이블의 기본키를 가지고 있을 수도 있음

-- 전체 사원들의 사번, 사원명, 사원 부서 코드, --> EMPLOYEE E 
--            사수 사번, 사수명, 사수부서코드 --> EMPLOYEE M
-- 테이블이 같으니까 따로 별칭을 지어 구분해줘야 함
--> 오라클
SELECT E.EMP_ID AS "사원 사번", E.EMP_NAME AS "사원명", E.DEPT_CODE,
        M.EMP_ID AS "사수 사번", M.EMP_NAME AS "사수명", M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID
ORDER BY E.EMP_ID;

--> ANSI
SELECT E.EMP_ID AS "사원 사번", E.EMP_NAME AS "사원명", E.DEPT_CODE,
        M.EMP_ID AS "사수 사번", M.EMP_NAME AS "사수명", M.DEPT_CODE
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID)
ORDER BY E.EMP_ID;

-----------------------------------------------------------------------------
/*
    <다중 조인>
    2개 이상의 테이블을 가지고 JOIN 할 때
*/

-- 사번, 사원명, 부서명, 직급명
---> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE;

---> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

-- 사번, 사원명, 부서명, 지역명 조회
--SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
--FROM DEPARTMENT, EMPLOYEE, LOCATION
--WHERE DEPT_ID = DEPT_CODE
--AND LOCATION_ID = LOCAL_CODE;
--
--SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
--FROM DEPARTMENT
--JOIN EMPLOYEE ON (DEPT_ID = DEPT_CODE)
--JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 강사님 예시
-- 오라클
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;
--/ 앞의 EMPLOYEE와 DEPARTMENT가 먼저 매칭 되었으므로 두 테이블이 합쳐진 임시 테이블이 생성 되었을 것
--/ 따라서 그 이후에 DEPARTMENT와 LOCATION을 매칭 시켜줘도 임시 테이블과 LOCATION이 합쳐지는 것이므로 아무 상관 없음

-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--/ 나중에 가면 코드가 많아지므로 그냥 앞에서부터 하나씩 순서대로 매칭 시키면 됨

-----------------------------문제------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회
-- 오라클
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE);

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여 등급 조회
-- 오라클
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID
  AND E.JOB_CODE = J.JOB_CODE
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
  AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);