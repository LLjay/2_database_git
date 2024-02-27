--/ JAVA는 있는 FUNCTION이거나 만들어 쓰거나
--/ SQL은 거의 다 있는 함수를 씀

SELECT EMP_ID, EMP_NAME, SALARY ----- 3
FROM EMPLOYEE ----- 1
WHERE DEPT_CODE IS NULL; ----- 2

/*
    <ORDER BY 절> /:
    SELECT문 가장 마지막 줄에 작성, 실행 순서 또한 가장 마지막에 실행
    
    [표현법]
    SELECT 조회할 컬럼...
    FROM 조회할 테이블
    WHERE 조건식
    ORDER BY 정렬 기준이 될 컬럼명 | 별칭 | 컬럼 순번 [ASC | DESC] [NULL FIRST | NULL LAST]
    / 가져와서 조건으로 거르고 다 출력한 후이기 때문에 별칭 사용 가능
    / 대괄호 안은 생략 가능
    
    - ASC : 오름차순 (작은 값으로 시작해서 값이 점점 커짐) -> 기본값, 생략하면 ASC
    - DESC : 내림차순 (큰값으로 시작해서 값이 점점 줄어듦)
    
    - NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL이 있을 경우 해당 데이터 맨 앞에 배치(DESC일 때 기본값) / NULL이 가장 크다는 게 디폴트값
    - NULLS LAST : 정렬하고자 하는 컬럼값에 NULL이 있을 경우 해당 데이터 맨 마지막에 배치(ASC일 때 기본값)
*/

SELECT *
FROM EMPLOYEE
--ORDER BY BONUS; -- 기본값이 오름차순
--ORDER BY BONUS ASC NULLS FIRST; -- NULL끼리는 기준 없음, 생성된 대로 기준없이 배치
--ORDER BY BONUS DESC; -- NULLS FIRST 기본
ORDER BY BONUS DESC, SALARY ASC;
-- 정렬 기준에 컬럼값이 동일할 경우 그 다음 차순을 위해서 여러 개를 제시할 수 있다.

-- 전 사원의 사원명, 연봉(보너스 제외) 조회(이 때 연봉별 내림차순 정렬)
SELECT EMP_NAME, SALARY * 12 AS "연봉"
FROM EMPLOYEE
--ORDER BY SALARY * 12 DESC;
--ORDER BY 연봉 DESC; / 3번에서 별칭 쓴 후에 4번째로 실행되는 구문이기 때문에 별칭으로 하는 게 가능
ORDER BY 2 DESC; --/ SELECT의 컬럼 순서 기준, 순서로도 써줄 수 있으나 선호하지는 않음
-- 순번 사용 가능 오라클은 전부 1부터 시작

----------------------------------------------------------------------------
/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환
    
    - 단일행 함수 : N개의 값을 읽어들여서 N개의 결과값을 리턴(매행마다 함수 실행 결과를 반환)
    - 그룹 함수 : N개의 값을 읽어들여서 1개의 결과값을 리턴(그룹을 지어 그룹별로 함수 실행 결과 반환)
    
    >> SELECT 절에 단일행 함수와 그룹 함수를 함께 사용하지 못함
       결과 행의 개수가 다르기 때문에
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절 WHERE절 ORDER BY절 GROUP BY절 HAVING절
*/

-----------------------------<단일행 함수>----------------------------
/*
    <문자 처리 함수>
    
    *LENGTH(컬럼 | '문자열') : 해당 문자열의 글자 수를 반환
    *LENGTHB(컬럼 | '문자열') : 해당 문자열의 바이트 수를 반환
    
    '전' '지' 한글은 글자 당 3BYTE /글자수가 많아서 표현해야 하는 글자도 많아서 3바이트 정도는 있어야 함
    영문자, 숫자, 특수문자는 글자 당 1BYTE
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; --/ 오라클은 어디 테이블에 포함되어 있는 데이터가 아니니까

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), --/ 특정 컬럼을 넣어서 그 컬럼의 함수값을 출력하는 형태로 사용
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE; --/ 단일행 함수이므로 전부 다 출력

-----------------------------------------------------------------------------

/*
    *INSTR
    문자열로부터 특정 문자의 시작 위치를 찾아서 반환
    
    INSTR(컬럼 | '문자열', '찾고자 하는 문자', ['찾을 위치의 시작값', '순번']) => 결과 NUMBER로 나옴
*/

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 앞쪽에 있는 첫 B는 3번째 위치에 있다고 나옴
SELECT INSTR('AABAACAABBAA', 'B', 1, 1) FROM DUAL; --/ 디폴트값
-- 찾을 위치 시작값 : 1, 순번 : 1 => 기본값
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- 뒤에서부터 찾지만 읽을 때는 앞으로 읽어서 알려줌
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; -- 순번을 제시하려면 찾을 위치의 시작값을 표시해야 함
--/ 오버로딩 된 것, 매개변수 자리가 정해져 있으므로 순서대로 넣어야 함
SELECT INSTR('AABAACAABBAA', 'B', 1, 3) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, 'a') AS "LOCATION", INSTR(EMAIL, '@') AS "@위치"
FROM EMPLOYEE; --/ 없으면 0으로 나오는군 없으니까 NULL 아니고 0

/*
    *SUBSTR / 자주 쓰임
    문자열에서 특정 문자열을 추출해서 반환
    
    [표현법]
    SUBSTR(STRING, POSITION, [LENGTH])
    - STRING : 문자 타입의 컬럼 | '문자열'
    - POSITION : 문자열 추출할 시작 위치의 값
    - LENGTH : 추출할 문자 개수(생략하면 끝까지)
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;

-- SHOWME
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) AS "성별"
FROM EMPLOYEE;

-- 사원들 중 여사원들만 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

-- 사원들 중 남사원들만 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1' OR SUBSTR(EMP_NO, 8, 1) = '3'
ORDER BY EMP_NAME;

-- 함수 중첩 사용 가능
-- 이메일 아이디 부분만 추출
-- 사원 목록에서 사원명, 이메일, 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, (INSTR(EMAIL, '@') - 1)) AS "아이디"
FROM EMPLOYEE;

----------------------------------------------------------------

/* / 자바에도 있긴 있는데 잘 안 씀
    *LPAD / RPAD
    문자열을 통일감 있게 조회 하고자 할 때 사용
    
    [표현법]
    LPAD / RPAD(STRING, 최종적으로 반환할 문자의 길이, [덧붙이고자 하는 문자])
    
    문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 붙여서 최종 N길이 만큼의 문자열을 반환
*/

-- 20만큼의 길이 중 EMAIL 컬럼값은 오른쪽으로 정렬하고 나머지 부분은 공백으로 채운다
SELECT EMP_NAME, LPAD(EMAIL, 20, '#') --/무조건 길이는 20이고 오른쪽으로 정렬하겠다
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT RPAD('980724-2', 14, '*')
FROM DUAL;

-- 사원들의 사원명 주민등록번호 조회(980724-2****** 형식으로)
SELECT EMP_NAME, RPAD((SUBSTR(EMP_NO, 1, 8)), 14, '*')
-- SELECT EMP_NAME, (SUBSTR(EMP_NO, 1, 8) || '******')
FROM EMPLOYEE
ORDER BY EMP_NO;

--------------------------------------------------------------
/*
    *LTRIM / RTRIM
    문자열에서 특정 문자를 제거한 나머지를 반환
    LTRIM / RTRIM(STRING, [제거하고자 하는 문자들])
    
    문자열의 왼쪽 혹은 오른쪽에서 제거하고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
*/

SELECT LTRIM('    K   H ') FROM DUAL; -- 앞에서부터 다른 문자가 나올 때까지만 공백 제거
SELECT LTRIM('123123KH123', '123') FROM DUAL;
--SELECT LTRIM('123123KH123', '312') FROM DUAL;
SELECT LTRIM('ACABACCKH', 'ABC') FROM DUAL; -- 제거하는 건 문자열이 아닌 문자들, 문자가 후보 중에 있나를 검사
SELECT LTRIM('ACABACCKHABC', 'ABC') FROM DUAL;
SELECT RTRIM('545345KH345', '0123456789') FROM DUAL;

/*
    *TRIM
    문자열의 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    TRIM([LEADING | TRAILING | BOTH] 제거하고자 하는 문자열 FROM 문자열)
*/

SELECT TRIM('    K  H   ') FROM DUAL; -- 양쪽에 있는 공백을 제거
SELECT TRIM('Z' FROM 'ZZZKHZZZZZZZZ') FROM DUAL; -- 양쪽에 있는 특정 문자 제거

SELECT TRIM(LEADING 'Z' FROM 'ZZZZKHZZZZZ') FROM DUAL; -- LTRIM과 유사한 기능
SELECT TRIM(TRAILING 'Z' FROM 'ZZKHZZZZ') FROM DUAL; -- RTRIM과 유사한 기능
SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZZZ') FROM DUAL; -- 양쪽에 있는 특정 문자 제거

/*
    *LOWER / UPPER / INITCAP
    
    LOWER : 다 소문자로 변경한 문자열 반환
    UPPER : 다 대문자로 변경한 문자열 반환
    INITCAP : 띄어쓰기 기준 첫 글자마다 대문자로 변경한 문자열 반환
*/

SELECT LOWER('Welcome To My World!') FROM DUAL;
SELECT UPPER('Welcome To My World!') FROM DUAL;
SELECT INITCAP('welcome to my world!') FROM DUAL;

----------------------------------------------------------------------

/*
    *CONCAT
    문자열 두 개를 전달 받아 하나로 합친 후 반환
    CONCAT(STRING1, STRING2)
*/

SELECT CONCAT('가나다', 'ABC') FROM DUAL; -- 두 개의 문자열만 가능
SELECT '가나다' || 'ABC' FROM DUAL;

----------------------------------------------------------------------

/*
    *REPLACE
    특정 문자열에서 특정 부분을 다른 부분으로 교체
    REPLACE(문자열, 찾을 문자열, 변경할 문자열)
*/

SELECT EMAIL, REPLACE(EMAIL, 'KH.or.kr', 'gmail.com')
FROM EMPLOYEE;




----------------------------------------------------------------------
                          --NUMBER FUNCTION
----------------------------------------------------------------------

/*
    <숫자 처리 함수>
    
    *ABS
    숫자의 절대값을 구해주는 함수
*/

SELECT ABS(-10), ABS(-6.3) FROM DUAL;

--------------------------------------------------------------------

/*
    *MOD
    두 수를 나눈 나머지 값을 반환
    MOD(NUMBER, NUMBER)
*/

SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL; --/ 결과를 반올림 하지 않고 그냥 1.9로 나옴, 모든 수는 NUMBER 형으로 통일되어 있어 형변환이랄 게 없음

/*
    *ROUND
    반올림한 결과를 반환
    
    ROUND(NUMBER, [위치])
*/

SELECT ROUND(123.456) FROM DUAL; -- 기본 자릿수는 소수점 첫 번째 자리에서 반올림 : 0
SELECT ROUND(123.456, 0) FROM DUAL; 
SELECT ROUND(123.456, -1) FROM DUAL; -- 음수로 감소할수록 소수점 앞자리로 이동 --/ 소수점 기준으로 거꾸로 감
SELECT ROUND(123.456, 1) FROM DUAL; -- 양수로 증가할수록 소수점 뒤로 한 칸씩 이동

/*
    *CEIL
    올림처리를 위한 함수
    
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.456) FROM DUAL;

/*
    *FLOOR
    버림처리 함수
    [표현법]
    FLOOR(NUMBER)
*/

SELECT FLOOR(123.955) FROM DUAL;

/*
    TRUNC
    버림처리 함수
    [표현법]
    TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.952) FROM DUAL;
SELECT TRUNC(123.952, 1) FROM DUAL;
SELECT TRUNC(123.952, -1) FROM DUAL;

----------------------QUIZ------------------------
-- 검색하고자 하는 내용
-- JOB_CODE가 J7이거나 J6이면서 SALARY값이 200만원 이상이고
-- BONUS가 있고 여자이며 이메일 주소는 _앞에 3글자만 있는 사원의
-- 이름, 주민등록번호, 직급코드, 부서코드, 급여, 보너스를 조회하고 싶다.
-- 정상적으로 조회되면 결과가 2개

SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE (JOB_CODE IN ('J7', 'J6')) --/ IN의 컬럼값은 ' ' 안에 들어가야 한다
        AND (SALARY >= 2000000)
        AND (BONUS IS NOT NULL)
        AND (SUBSTR(EMP_NO, 8, 1) = 2)
        AND (EMAIL LIKE '___|_%' ESCAPE '|'); --/ '(탈출할 문자)(일반카드로 인식할 문자)'% ESCAPE '탈출할 문자'
        
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J6') AND (SALARY >= 2000000) AND
      (BONUS IS NOT NULL) AND (EMAIL LIKE '___\_%' ESCAPE '\') AND
      SUBSTR(EMP_NO, 8, 1) IN ('2','4');

-----------------------------------------------------------------------------

/*
    <날짜 처리 함수
*/

-- *SYSDATE : 시스템의 현재 날짜 및 시간을 반환
SELECT SYSDATE FROM DUAL;
--/ 데이터베이스도 서버, 데이터베이스의 시간과 서버의 시간이 다르면 제대로 찍혀나오지 않을 수 있음

-- *MONTHS_BETWEEN : 두 날짜 사이의 개월 수
-- 사원들의 사원명, 입사일, 근무일수, 근무 개월수 조회

SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE; --/ 날짜 사이니까 개월로 딱 안 떨어져서 소수점 자리 나옴

SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE)
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE),
       FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE),
       CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' AS "근속개월"
FROM EMPLOYEE;

-- *ADD_MONTHS : 특정 날짜에 NUMBER 개월수를 더해서 반환
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;

-- 근로자 테이블에서 사원명, 입사일, 입사 후 3개월의 날짜 조회(정규직 전환일)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3) AS "정규직 전환일"
FROM EMPLOYEE;

-- *NEXT_DAY(DATE, 요일(문자 | 숫자)) : 특정 날짜 이후 가장 가까운 요일의 날짜를 반환
SELECT NEXT_DAY(SYSDATE, '토요일') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '토') FROM DUAL;
-- 1 : 일, 2 : 월, ... 7 : 토
SELECT NEXT_DAY(SYSDATE, 7) FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; --/ 언어팩이 한국어라서 안 됨

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- *LAST_DAY(DATE) : 해당 월의 마지막 날짜 구해서 반환
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 사원 테이블에서 사원명, 입사일, 입사 달의 마지막 날짜, 입사 달의 근무일수 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), (LAST_DAY(HIRE_DATE) - HIRE_DATE) AS "입사 달 근무일수"
FROM EMPLOYEE;

/*
    *EXTRACT : 특정 날짜로부터 년도|월|일 값을 추출해서 반환하는 함수
    
    [표현법]
    EXTRACT(YEAR FROM DATE) : 연도만 추출
    EXTRACT(MONTH FROM DATE) : 월만 추출
    EXTRACT(DAY FROM DATE) : 일만 추출
      => 결과는 NUMBER
*/

-- 사원의 사원명, 입사년도, 입사월, 입사일을 조회
SELECT EMP_NAME,
    EXTRACT(YEAR FROM HIRE_DATE) AS "입사년도",
    EXTRACT(MONTH FROM HIRE_DATE) AS "입사월", 
    EXTRACT(DAY FROM HIRE_DATE) AS "입사일"
FROM EMPLOYEE
ORDER BY 2, 3, 4;


-----------------------------------------------------------------------
/*
    [형변환 함수]
    *TO_CHAR : 숫자 타입 또는 날짜 타입의 값을 문자 타입으로 변환 시켜주는 함수
    
    [표현법]
    TO_CHAR(숫자|날짜, [포맷])
*/

-- 숫자 타입 -> 문자 타입
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '999999') AS "NUMBER" FROM DUAL; -- 9의 자릿수 만큼 공간 확보, 오른쪽 정렬, 빈칸 공백
--/ 9라는 숫자가 오면 공간 확보를 할게 라고 정해진 것?
SELECT TO_CHAR(1234, '00000') AS "NUMBER" FROM DUAL; -- 0의 자릿수 만큼 공간 확보, 오른쪽 정렬, 0으로 채움
--/ 맨 앞자리는 변환한 것 아님
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재 설정된 나라의 로컬 화폐 단위 포함
SELECT TO_CHAR(1234, '$99999') FROM DUAL;
--/ 맨 앞자리는 허수
SELECT TO_CHAR(3500000, 'L9,999,999') FROM DUAL;

--사원들의 사원명, 월급, 연봉을 조회
SELECT EMP_NAME, TO_CHAR(SALARY, 'L9,999,999') AS "월급", TO_CHAR(SALARY * 12, 'L99,999,999') AS "연봉" 
FROM EMPLOYEE;

--SELECT EMP_NAME, TO_CHAR(SALARY, 'L9,999,999'), TO_CHAR(SALARY * 12, 'L9,999,999') AS "연봉" 
--FROM EMPLOYEE; => 자릿수 부족해서 연봉에 #######등의 표기만 뜸

-- 날짜 타입 => 문자 타입
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL; -- AM, PM 어떤 것을 쓰던 형식에 맞춰 나옴
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL; -- 24시간으로 표현
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

-- 사원들의 이름, 입사 날짜(0000년 00월 00일) 조회
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') AS "입사날짜" -- 정해진 형식대로만 사용 가능
FROM EMPLOYEE; --/ 지정된 형식이 있어서 안에 년월일 이라는 스트링을 대입하려면 큰따옴표 안에 넣어줘야 함

-- 년도와 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'),
        TO_CHAR(SYSDATE, 'YY'),
        TO_CHAR(SYSDATE, 'RRRR'), -- RR 룰이 따로 존재 -> 50년 이상 값이 + 100 -> EX) 1954 
        TO_CHAR(SYSDATE, 'RR'), --/ 1900년도 당시에 2000년을 넘어가는 값을 표현하기 위해 사용했음, 현업에서 잘 안 씀
        TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

SELECT HIRE_DATE, TO_CHAR(HIRE_DATE) FROM EMPLOYEE;

-- 월과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'MM'), -- 이번 달 숫자 두 자리
        TO_CHAR(SYSDATE, 'MON'),
        TO_CHAR(SYSDATE, 'MONTH')
FROM DUAL;

-- 일과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 오늘이 이번 년도에서 몇 번째 일수
        TO_CHAR(SYSDATE, 'DD'), -- 오늘 일자
        TO_CHAR(SYSDATE, 'D') -- 요일 표시 -> 숫자
FROM DUAL;

-- 요일에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'),
        TO_CHAR(SYSDATE, 'DY')
FROM DUAL;

---------------------------------------------------------------------
/* 
    TO_DATE : 숫자 타입 또는 문자 타입을 날짜 타입으로 변경하는 함수
    
    TO_DATE(숫자 | 문자, [포맷]) -> DATE
*/

SELECT TO_DATE(20100101) FROM DUAL;
SELECT TO_DATE(240219) FROM DUAL;
SELECT TO_DATE(650219) FROM DUAL; -- 50년 미만은 자동으로 20XX로 설정, 50년 이상은 19XX로 설정된다. 

SELECT TO_DATE(020505) FROM DUAL; -- 숫자는 0으로 시작하면 안 됨
SELECT TO_DATE('020505') FROM DUAL;
SELECT TO_DATE('20240809') FROM DUAL;

SELECT TO_DATE('20240219 128000') FROM DUAL; -- 포맷을 정해줘야 시, 분, 초를 표시할 수 있다.
SELECT TO_DATE('20240219 128000', 'YYYYMMDD HH24MISS') FROM DUAL;

-----------------------------------------------------------------------
/*
     TO_NUMBER : 문자 타입의 데이터를 숫자 타입으로 변환 시켜주는 함수
     
     [표현법]
     TO_NUMBER(문자, [포맷])
*/

SELECT TO_NUMBER('05123456789') FROM DUAL;

SELECT '100000' + '500000' FROM DUAL;
SELECT '100,000' + '55,000' FROM DUAL;
SELECT TO_NUMBER('100,000', '999,999') + TO_NUMBER('55,000', '99,000')
FROM DUAL;
--뒤에 똑같이 형식을 써줘야 변환이 가능?

------------------------------------------------------------------------

/*
    [NULL 처리 함수]
*/

-- *NVL(컬럼, 해당 컬럼이 NULL일 경우 보여줄 값)
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

-- 전사원의 이름, 보너스 포함 연봉
--SELECT EMP_NAME, (SALARY + (SALARY * BONUS)) * 12
SELECT EMP_NAME, (SALARY + (SALARY * NVL(BONUS, 0))) * 12
FROM EMPLOYEE;

-- NVL2 (컬럼, 반환값1 반환값2)
-- 반환값 1 : 해당 컬럼이 존재할 경우 보여줄 값
-- 반환값 2 : 해당 컬럼이 NULL일 경우 보여줄 값

SELECT EMP_NAME, BONUS, NVL2(BONUS, 'O', 'X')
FROM EMPLOYEE;

-- 사원들의 사원명과 부서 배치 여부(배정 완료 또는 미배정 표시) 조회
SELECT EMP_NAME, NVL2(DEPT_CODE, '배정 완료', '미배정')
FROM EMPLOYEE;

-- *NULLIF(비교대상1, 비교대상2)
-- 두 값이 일치하면 NULL 일치하지 않는다면 비교대상1 반환
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;

--------------------------------------------------------------------

/*
    [선택함수]
    *DECODE(비교하고자 하는 대상(컬럼, 연산식, 함수식), 비교값1, 결과값1, 비교값2, 결과값2, 비교값3... 결과값N)
    
    SWITCH(비교대상) {
    CASE 비교값1 :
        실행코드
    CASE 비교값2 :
        실행코드
    } --/ 와 비슷
    
    / 해당하는 값이 없고 그 값에 대한 디폴트값을 정해주지 않았을 경우 해당 결과는 NULL로 나옴
*/

-- 사번, 사원명, 주민번호, 성별 조회
SELECT EMP_ID, EMP_NAME, EMP_NO,
        DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '외계인') AS "성별"
FROM EMPLOYEE; --/ 외계인은 디폴트

-- 직원의 성명, 기존 급여, 인상된 급여 조회 * 각 직급별로 인상해서 조회
-- J7인 사원은 급여를 10% 인상(SALARY * 1.1)
-- J6인 사원은 급여를 15% 인상
-- J5인 사원은 급여를 20% 인상
-- 그 외 사원은 급여를 5% 인상

SELECT EMP_NAME, SALARY AS "기존 급여"
       , DECODE(JOB_CODE 
       , 'J7', SALARY * 1.1 
       , 'J6', SALARY * 1.15
       , 'J5', SALARY * 1.2
             , SALARY * 1.05) AS "인상 급여"
FROM EMPLOYEE;

/*
    *CASE WHEN THEN
    
    CASE 
         WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값
    END
*/

SELECT EMP_NAME, SALARY,
        CASE WHEN SALARY >= 5000000 THEN '고급'
             WHEN SALARY >= 3500000 THEN '중급'
             ELSE '초급'
        END
FROM EMPLOYEE;
        
        
----------------------------------그룹 함수----------------------------------
-- 1. SUM(숫자 타입 컬럼) : 해당 컬럼 값들의 총 합계를 구해서 반환해주는 함수

-- 근로자 테이블의 전시원의 총 급여를 구해라
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 남자 사원들의 총 급여 합

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1');

--SELECT EMP_NO
--FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO, 8, 1) IN ('1');

-- 부서 코드가 D5인 사원들의 총 연봉(급여 * 12)
SELECT SUM(SALARY * 12)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5');

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5');

-- 2. AVG(NUMBER) : 해당 컬럼값들의 평균값을 구해서 반환
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- SELECT ROUND(), AVG() => 결과 개수가 다르므로 안 됨
-- SELECT ROUND(AVG()) => AVG의 그룹함수 결과 하나를 단일행 함수에 넣는 것

-- 3. MIN(모든 타입 가능) : 해당 컬럼값 중 가장 작은 값 구해서 반환
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE; --/ 글자는 사전 상에서 가장 빨리 시작하는 게 가장 작은 값
--/ 시간은 과거로 갈수록 작고 미래로 갈수록 커짐

-- 4. MAX(모든 타입 가능) : 해당 컬럼값 중 가장 큰 값 구해서 반환
SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

-- 5. COUNT(* | 컬럼 | DISTINCT 컬럼) : 해당 조건에 맞는 행의 개수를 세서 반환
-- COUNT(*) : 조회된 결과의 모든 행의 개수를 세서 반환
-- COUNT(컬럼) : 제시한 해당 컬럼값이 NULL이 아닌 것만 행의 개수를 세서 반환
-- COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복을 제거한 후 행의 개수를 세서 반환

-- 전체 사원 수
SELECT COUNT(*) FROM EMPLOYEE; --/ 행의 개수가 출력된 것

-- 여자 사원 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL; --/ 그냥 넣으면 이렇게 해주겠다고 약속

-- 부서 배치를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 현재 사원들이 총 몇 개의 부서에 분포되어 있는지 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;