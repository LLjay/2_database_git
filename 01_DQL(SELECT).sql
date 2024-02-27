/*
    <SELECT>
    SELECT 가져 오고 싶은 정보 FROM 테이블;
    SELECT (*) 컬럼1, 컬럼2, 컬럼3... FROM 테이블; // (*)는 전부
*/

-- 모든 사원의 정보를 보여줘
SELECT * FROM EMPLOYEE;

-- 모든 사원의 이름, 주민등록번호, 핸드폰번호
SELECT EMP_NAME, EMP_NO, PHONE -- 세미콜론이 뒤에 있음, 가독성 위한 것?
FROM EMPLOYEE; -- 컬럼 이름

----------------------실습------------------------
SELECT EMP_ID FROM EMPLOYEE;
SELECT EMAIL FROM DK;

-- JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;

-- DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;

-- DEPARTMENT 테이블의 부서 코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

-- EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE; -- / 인터프리터 언어라 세미콜론이 많이 중요하구나


-- <컬럼값을 통한 산술연산>
-- SELECT절 컬럼명 작성 부분에 산술 연산을 할 수 있다.

-- EMPLOYEE 테이블의 사원명, 사원의 연봉(SALARY * 12)을 조회
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉, 보너스 포함 연봉 조회(급여 + (급여 * 보너스)) * 12
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + (SALARY * BONUS)) * 12
FROM EMPLOYEE;
-- 산술 연산 과정 중에 NULL 데이터가 포함되어 있다면 무조건 결과값은 NULL

-- 사원명, 입사일, 근무일수를 조회
-- 현재 시간 - 입사일 = 근무한 시간
-- DATE - DATE => 결과는 무조건 일 로 표시
-- SYSDATE : 코드 실행 시 날짜를 표시하는 상수 [년/월/일/시/분/초]
-- / 그냥 SYSDATE만 쓸 경우 현재 날짜와 시간을 가져다줌
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

-- / SYSDATE는 상수이므로 가져와줄 값이 없음
SELECT SYSDATE FROM DUAL;
-- / DUAL은 오라클에서 제공하는 빈 테이블, 상수이므로 뷰를 못 가져오므로 여기에 가져옴
-- / SYSDATE 날짜 옆에 더블클릭 해보면 연필로 뜸
-- / 더미데이터 : 가상 인물로 만들어서 돌릴 수 있음
-- DUAL : 오라클에서 제공해주는 가상데이터 테이블(더미데이터)
-- 현재 시각은 저 구문을 실행한 순간의 데이터가 뜸

/*
    <컬럼명에 별칭 지정하기>
    산술 연산을 하게 되면 컬럼명이 지저분해진다. 이때 컬럼명에 별칭을 부여해서 깔끔하게 가져올 수 있다. 
/ 컬럼명 아니어도 별칭 지정 가능
    
    [표현법]
    컬럼명 별칭 / 컬럼명 AS 별칭 / 컬럼명 "별칭"
*/

-- / 한글로 쓸 일은 거의 없지만 그래도 쓸 수는 있음
SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS "보너스", SALARY * 12 AS "연봉",
       (SALARY + (SALARY * BONUS)) * 12 AS "총 소득"
FROM EMPLOYEE;

/*
    <리터럴>
/ 의미 없는 값을 넣고 싶을 때
    임의로 지정한 문자열(' ')
    조회된 결과 (RESULT SET 또는 VIEW)의 모든 행에 반복적으로 출력
*/

-- EMPLOYEE 테이블의 사번, 사원명, 급여
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM EMPLOYEE;
-- / 임시의 상수를 만들 수 있음 : 리터럴
SELECT EMP_ID, EMP_NAME, SALARY || 원 
FROM EMPLOYEE;
/*
    <연결연산자 : ||>
    여러 컬럼값들을 마치 하나의 컬럼처럼 연결할 수 있다.
*/
-- 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_NAME || EMP_NAME || SALARY
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 모든 사원의 월급을 조회한다. 다음과 같이 결과가 나오도록 출력하라.
-- XX의 월급은 XX원입니다.

SELECT EMP_NAME || '의 월급은 ' || SALARY || '원입니다.' AS "급여"
FROM EMPLOYEE;

/*
    <DISTINCT>
    중복 제거 - 칼럼에 표시된 값을 한 번씩만 조회하고자 할 때
*/

-- EMPLOYEE 직급코드 조회
SELECT DISTINCT FOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE 부서코드를 조회 (중복제거)
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE
-- 위처럼 작성하면 에러 발생, DISTINCT는 한 번만 사용 가능
SELECT DISTINCT JOB_CODE, DEPT_CODE
-- 위처럼 사용 시 (JOB_CODE, DEPT_CODE)를 쌍으로 묶어서 중복을 제거한 값을 보여준다.
FROM EMPLOYEE;

-----------------------------------------------------------------------------------------
--/ 조회 시에는 보통 통으로 가져오는 것도 있지만 검색 등을 할 경우 특정 조건을 만족하는 아이들만 가져와야 함

/*
    <WHERE 절>
    조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만을 조회할 때 사용
    조건식에서도 다양한 연산자 사용이 가능
    
    [표현법]
    SELECT 컬럼, 컬럼, 컬럼 연산
    FROM 테이블
    WHERE 조건;
    
    /당연히 WHERE은 혼자 사용할 수 없음
    
    >> 비교연산자 << /를 많이 사용
    >, <, >=, <=    : 대소비교
    =               : 동등비교 (양쪽이 같다)
    !=, ^=, <>      : 동등비교 (양쪽이 다르다)
    AND, OR         : 조건연결, 둘 다 TRUE 거나 한 쪽만 TRUE거나
*/

--EMPLOYEE에서 부서코드가 'D9'인 사원들만 조회(모든 컬럼)
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--/ SQL이 대소문자를 구분하지 않는다는 건 명령어에 한함, 데이터는 대소문자를 구분

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드 조회

SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

--/ SQL은 돌릴 때마다 네트워크에 접속해서 하는 것, 내 컴퓨터의 데이터베이스에 계속 접속해서 뭔가를 주고받고 하기 때문에 가끔 렉이 걸림

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
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY * 12 AS 연봉
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. 연봉이 5천만원 이상인 사원들의 사원명, 급여, 연봉(별칭 -> 연봉), 부서코드 조회
SELECT EMP_NAME, SALARY, SALARY * 12 AS "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE SALARY * 12 >= 50000000;
-- WHERE 연봉 >= 5000000; -> 에러 발생
-- 이유 : 실행 순서가 FROM -> WHERE -> SELECT 이기 때문
--/ 한 번에 실행하려면 한 쿼리로 만들어야 함? / 조건 자리는 조건문만 가능
--/ 쿼리 QUERY : 질의문, 데이터베이스에 정보를 요청하는 것
--/ 그럼 쿼리는 세미콜론으로 구문을 구분하나?

-- 3. 직급 코드가 'J3'가 아닌 사원들의 사번, 사원명, 직급 코드, 퇴사 여부 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

-- 4. 급여가 350만원 이상 600만원 이하인 모든 사원의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;


----------------240216----------------

/*
    <AND, OR 연산자>
    조건을 여러 개 연결할 때 사용한다.
    [표현법]
    조건A AND 조건B -> 조건A와 조건B 모두 만족하는 값만 가지고 온다.
    조건A OR 조건B -> 조건A와 조건B 중 하나라도 만족하는 값은 가지고 온다.
    
    <BETWEEN AND>
    조건식에 사용되는 구문
    몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 사용하는 연산자(이상, 이하만 가능)
    [표현법]
    비교대상 컬럼 BETWEEN 하한값 AND 상한값
*/

-- 급여가 350만원 이상 600만원 이하인 모든 사원의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 급여가 350만원 미만 600만원 초과인 모든 사원의 사원명 사번 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY < 3500000 OR SALARY > 6000000;

SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
--/ WHERE SALARY NOT BETWEEN 3500000 AND 6000000; 도 가능
--/ 그 사이 샐러리를 부정하느냐 그 사이를 부정한 걸 샐러리에 넣느냐

-- NOT : 논리 부정 연산자
-- 컬럼명 앞 또는 BETWEEN 앞에 선언 가능

-- 입사일이 '90/01/01' ~ '01/01/01' 사원을 조회
SELECT *
FROM EMPLOYEE
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01'; -- DATE 타입도 연산이 가능하다.
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

------------------------------------------------------------

/*
    <LIKE>
    비교하고자 하는 컬럼값이 내가 제시한 특정 패턴을 만족할 경우 조회
    
    [표현법]
    비교할 대상 컬럼 LIKE '특정 패턴';
    
    특정 패턴을 제시할 때 와일드 카드라는 특정 패턴이 정의되어 있다.
    '%' : 포함문자 검색 (0글자 이상 전부 조회)
    EX) 비교할 대상 컬럼 LIKE '문자%' : 비교대상 컬럼값 중에서 해당 문자로 시작하는 값들만 조회
        비교할 대상 컬럼 LIKE '%문자' : 비교대상 컬럼값 중에서 해당 문자로 끝나는 값들만 조회
        비교할 대상 컬럼 LIKE '%문자%': 비교대상 컬럼값 중에서 해당문자가 포함된 값 조회

    '_' : 1글자를 대체하는 검색
    EX) 비교할 대상 컬럼 LIKE '_문자' : 비교대상 컬럼값 문자 앞에 아무 글자나 N개 있는 값을 조회
    --/ '____문자'도 됨
        비교할 대상 컬럼 LIKE '문자_' : 비교대상 컬럼값 문자 뒤에 아무 글자나 N개 있는 값을 조회
        비교할 대상 컬럼 LIKE '_문자_' : 비교대상 컬럼값 문자 앞뒤에 아무 글자나 N개 있는 값을 조회

*/

-- 사원들 중 성이 전씨인 사원들의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- 사원들 중에서 이름이 '하'라는 글자가 포함된 사원의 이름, 전화번호 목록 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 사원들 중에서 이름에 중간 글자가 '하'인 사원의 이름 전화번호 목록 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

-- 전화번호의 3번째 자리가 1인 사원들의 사번, 사원명, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- 이메일 중 _앞글자가 3글자인 사원들의 사번, 이름, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
-- WHERE EMAIL LIKE '___%';  --> 와일드카드 문자 때문에 정상 출력되지 않는다.
-- 와일드 카드들의 문자와 일반 문자의 구분이 필요하다.
-- 데이터 값으로 취급하고 싶은 와일드카드 문자 앞에 나만의 탈출 문자를 제시해서 탈출 시켜주면 된다.
-- ESCAPE OPTION을 등록해서 사용해야 한다.
-- WHERE EMAIL LIKE '___\%' ESCAPE '\';-- 와일드 카드 뒤에 오는 다른 일반 카드는 이거야 라고 알려주는 것 -> 이스케이프 옵션
WHERE NOT EMAIL LIKE '___|%'ESCAPE '\';

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___|_%__' ESCAPE '|';

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '2_%' ESCAPE '2';

-----------------------------실습-----------------------------
-- 1. 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
--SELECT EMP_NAME, HIRE_DATE
--FROM EMPLOYEE
--/ WHERE EMP_NAME LIKE '__연';
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 2. 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

-- 3. 이름에 '하'가 포함되어 있고 급여가 240만 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2400000;

-- 4. 부서테이블에 해외영업부인 부서들의 부서코드, 보서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

--------------------------------------------------------------------

/*
    <IN>
    WHERE절에서 비교대상 컬럼값이 내가 제시한 목록 중에 일치하는 값이 있는지 검사
    
    [표현법]
    비교대상 컬럼값 IN ('값1', '값2'...);
*/

-- 부서코드가 D6이거나 D8이거나 D5인 부서원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';
--/ 양이 늘어나면 쓰기 힘들어짐
WHERE DEPT_CODE IN ('D6', 'D8', 'D5');

--------------------------------------------------------------------

/*
    <IS NULL & IS NOT NULL>
    컬럼값에 NULL이 있을 경우 NULL 값을 비교하기 위해서는 위의 연산자를 사용해야 함
*/

-- 보너스를 받지 않은 사원들의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
--/ WHERE BONUS = NULL; 이걸로는 못 찾아서 값이 안 나옴 
WHERE BONUS IS NULL;

-- 보너스를 받는 사원들의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- 사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서 배치를 아직 받지 않았고 보너스를 받은 사원들의 이름, 보너스, 부서코드를 조회
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

--------------------------------------------------------------------------

/*
    <연산자 우선순위>
    1. 산술연산자
    2. 연결연산자 (||)
    3. 비교연산자 
    4. IS NULL / LIKE / IN
    5. BETWEEN A AND B
    6. 부정연산자 (NOT)
    7. AND
    8. OR
*/

-- 직급 코드가 J7이거나 J2인 사원들 중에 급여가 200만원 이상인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
--WHERE JOB_CODE = 'J7' OR JOB_CODE = 'J2' AND SALARY >= 2000000;
--/ 우선순위가 AND부터 들어가서 코드가 J2고 2백인 사람이거나 J7인 사람이 나옴
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;


---------------------------실습---------------------------
-- 1. 사수가 없고 부서 배치도 받지 않은 사원들의 사원명, 사번, 부서코드 조회
SELECT EMP_NAME, EMP_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 2. 연봉(보너스 미포함)이 3천만원 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
--/WHERE SALARY * 12 >= 30000000 AND BONUS IS NULL;
WHERE (SALARY * 12) >= 30000000 AND BONUS IS NULL;

-- 3. 입사일이 '95/01/01' 이상이고 부서 배치를 받지 않은 사원들의 사번, 사원명, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NULL;

-- 4. 급여가 200만원 이상이고 500만원 이하인 사원 중 입사일이 '01/01/01' 이상이고
--    보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 AND (HIRE_DATE >= '01/01/01') AND BONUS IS NULL;
--/ 그냥 명시적으로 써준건가보다

-- 5. 보너스를 포함한 연봉이 NULL이 아니고 이름에 '하'가 포함된 사원들의 사번, 사원명, 급여, 보너스 포함 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY, (SALARY + (SALARY * BONUS)) * 12 AS "보너스 포함 연봉"
FROM EMPLOYEE
WHERE (SALARY + (SALARY * BONUS)) * 12 IS NOT NULL AND EMP_NAME LIKE '%하%';
-- 보너스 포함 연봉이면 어차피 보너스가 없으면 null이 나오므로 BONUS IS NOT NULL로도 할 수 있음
