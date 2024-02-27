-- 모든 사원의 정보를 보여줘
SELECT * FROM EMPLOYEE;

-- 모든 사원의 이름, 주민등록번호, 핸드폰번호
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE;

SELECT EMP_NAME, PHONE, EMP_NO
FROM EMPLOYEE;

----------------------실습------------------------
-- JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;

-- DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;

-- DEPARTMENT 테이블의 부서 코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 사원의 연봉(SALARY * 12)을 조회
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉, 보너스 포함 연봉 조회(급여 + (급여 * 보너스)) * 12
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12 AS "연봉", (SALARY + (SALARY * BONUS)) *12 AS "보너스연봉"
FROM EMPLOYEE;

-- 사원명, 입사일, 근무일수를 조회
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

SELECT SYSDATE FROM DUAL;
-- 이미 정해져 있는 상수니까 애초에 어디에선가 가져올 수가 없음, 더미데이터인 DUAL에서 가져오겠다고 명시해주는 것
-- SYSDATE로 현재의 년 월 일 시 분 초 를 표현할 수 있음

-- 현재 날짜 조회
SELECT SYSDATE FROM DUAL;

-- EMPLOYEE 테이블의 사번, 사원명, 급여
SELECT EMP_ID, EMP_NAME, SALARY, '원'
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '원' 
FROM EMPLOYEE;

-- 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 모든 사원의 월급을 조회한다. 다음과 같이 결과가 나오도록 출력하라.
-- XX의 월급은 XX원입니다.
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' AS SALARY
FROM EMPLOYEE;

-- EMPLOYEE 직급코드 조회
SELECT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE 부서코드를 조회 (중복제거)
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE 부서코드, 직급코드 중복 제거해서 조회
SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

--EMPLOYEE에서 부서코드가 'D9'인 사원들만 조회(모든 컬럼)
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드 조회
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원들의 사원명, 급여, 부서코드 조회
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE != 'D1';

-- 월급이 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

---------------------------실습---------------------------
-- 1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉(별칭 -> 연봉) 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY * 12 AS "연봉"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. 연봉이 5천만원 이상인 사원들의 사원명, 급여, 연봉(별칭 -> 연봉), 부서코드 조회


-- 3. 직급 코드가 'J3'가 아닌 사원들의 사번, 사원명, 직급 코드, 퇴사 여부 조회


-- 4. 급여가 350만원 이상 600만원 이하인 모든 사원의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;