/*
    <PL / SQL>
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어 있는 절차적 언어
    SQL 문장 내에서 변수의 정의, 조건(IF), 반복(FOR, WHILE) 등을 지원하여 SQL의 단점을 보완
    다수의 SQL문을 한 번에 실행 가능
    / 필수는 아님, 편의를 위한 것
    
    *PL/SQL 구조
    - [선언부] : DECLARE로 시작, 변수나 상수를 선언 및 초기화 하는 부분
    - 실행부 : BEGIN으로 시작 END;/ 로 종료, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
    - [예외처리부] : EXCEPTION으로 시작, 예외 발생 시 해결하기 위한 구문 / 자바의 TRY-CATCH와 같음
*/

SET SERVEROUTPUT ON;
--/ 이걸 해야 작성 가능?

-- HELLO ORACLE 출력
BEGIN
    --SYSTEM.OUT.PRINTLN("HELLO ORACLE"); -> 자바
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE'); --/SYSO와 동일
END;
/ 

--/ 슬래시 안 써도 출력은 되는데 왜 써주는 거지...
--/ 슬래시 옆에 주석이 들어가 있으면 인식하지 못함
----------------------------------------------------------------------------------------
/*
    1. DECLARE 선언부
       변수 및 상수를 선언하는 공간(선언과 동시에 초기화 가능)
       일반 타입 변수, 레퍼런스 타입 변수, ROW 타입 변수
       
    1-1) 일반 타입 변수 선언 및 초기화
        [표현식] 변수명 [CONSTANT] 자료형 [:= 값];
        / 대입연산자 :=
*/

DECLARE --/ 변수를 만들기 위해 쓰는 것
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14; --/ CONSTANT는 상수
BEGIN
    EID := &번호;
    ENAME := '&이름';
    --> 대체 변수, 값을 입력하라고 뜸 / 번호는 그대로, 문자열 및 리터럴은 작은따옴표 안에
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI); --DDFLKSDJFLK
END;
/ 
--여기만 안 되나? 그러네...

------------------------------------------------------------------------------------------
-- 1-2) 레퍼런스 타입 변수 선언 및 초기화(어떤 테이블의 어떤 컬럼의 데이터 타입을 참조해서 그 타입으로 지정)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; --/얘도 똑같은 자료형으로 됨
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
--    EID := 800;
--    ENAME := '이지수';
--    SAL := 1000000;

-- 사번이 200번인 사원의 사번, 사원명, 급여 조회해서 각 변수에 대입
SELECT EMP_ID, EMP_NAME, SALARY
INTO EID, ENAME, SAL --/ SELECT문으로 가져온 값을 각각 어느 변수에 대입해줄지 INTO 사용해서 매칭
FROM EMPLOYEE
WHERE EMP_ID = 200;

DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);

SELECT EMP_ID, EMP_NAME, SALARY
INTO EID, ENAME, SAL --/ SELECT문으로 가져온 값을 각각 어느 변수에 대입해줄지 INTO 사용해서 매칭
FROM EMPLOYEE
WHERE EMP_ID = &사번;

DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);

END;
/

----------------------------------------실습-------------------------------------------
/*
    레퍼런스 타입 변수로 EID, ENAME, JCODE, SAL, DTITLE을 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT(DEPT_TITLE) 등을 참조하도록
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회 후 각 변수에 담아 출력
*/
-- 내 예시
DECLARE
    EID VARCHAR2(20);
    ENAME VARCHAR2(20);
    JCODE VARCHAR2(5);
    SAL NUMBER;
    DTITLE VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
END;
/

-- 강사님 예시
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
END;
/

-----------------------------------------------------------------------------------
-- 1-3) ROW 타입 변수 선언
--      테이블의 한 행에 대한 모든 컬럼값을 한 번에 담을 수 있는 변수
--      [표현식] 변수명 테이블명%ROWTYPE;

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
--    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(BONUS, 0)); 어느 BONUS인지 설정해줘야 함? 왜?
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, 0));
END;
/

-------------------------------------------------------------------------------------
/*
    2. BEGIN 실행부
    <조건문>
    1) IF 조건식 THEN 실행 내용 END IF; (IF문만 단독으로 사용할 때)
*/

-- 입력 받은 사번에 해당하는 사원의 사번, 이름, 급여, 보너스 출력
-- 단, 보너스를 받지 않은 사원은 보너스 출력 전 '보너스를 지급 받지 않은 사원입니다' 출력

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);

    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않은 사원입니다.');
    END IF;
    -- IF 문에 걸리면 여기서 끝낸다는 거구나
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS); -- 끝낸다는 게 아니라 그냥 값이 없어 실행되지 않는 건가?
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);

    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않은 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || (BONUS * 100 || '%'));
    END IF;
END;
/

------------------------------------실습-----------------------------------------
--DECLARE
--  레퍼런스 타입 변수 (EID, ENAME, DTITLE, NCODE)
--          참조 컬럼 (EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE)
--      일반 타입 변수 (TEAM 문자열) < == 이따가 국내팀, 해외팀 분리해서 담을 예정
--BEGIN
--  사용자가 입력한 사번의 사원의 사번, 사원명, 부서명, 근무국가코드 조회 후 각 변수에 대입
-- 
--  NCODE 값이 KO일 경우 --> TEAM --> '국내팀' 대입
--             아닐 경우 --> TEAM --> '해외팀' 대입
--
--  사번, 이름, 부서, 소속에 대해 출력
--END;
--/


DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &사번;
    
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE 
        TEAM := '해외팀';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME || ', ' || DTITLE || ', ' || NCODE || ', ' || TEAM);
END;
/

-- 3) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2 ... [ELSE 실행내용] END IF;

DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고 학점은 ' || GRADE || '등급                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          입니다.');
END;
/

---------------------------------실습------------------------------------
-- 사용자에게 입력 받은 사번의 사원의 급여를 조회해서 SAL변수 대입
-- 500만원 이상이면 '고급'
-- 400만원 이상이면 '중급'
-- 300만원 이상이면 '초급'
-- '해당 사원의 급여 등급은 XX입니다.'

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000
        THEN GRADE := '고급';
    ELSIF SAL >= 4000000
        THEN GRADE := '중급';
    ELSIF SAL >= 3000000
        THEN GRADE := '초급';
    ELSE
        GRADE := '인턴';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
END;
/

--------------------------------------------------------------------
-- 4)CASE 비교대상자 WHEN 동등비교값1 THEN 결과값 ... ELSE 결과값 END;
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사팀'
                WHEN 'D2' THEN '회계팀'
                WHEN 'D3' THEN '마케팅팀'
                WHEN 'D4' THEN '국내영업팀'
                WHEN 'D5' THEN '총무팀'
                ELSE '해외영업팀'
            END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은 ' || DNAME || '입니다.');
END;
/

-----------------------------------------------------------------------

/*
    1) BASIC LOOP 문
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        *반복문을 빠져나갈 수 있는 구문
    END LOOP;
    
    *반복문을 빠져나갈 수 있는 구문
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
--        IF I = 6 THEN EXIT; END IF;
        EXIT WHEN I = 6;
    END LOOP;
END;
/

---------------------------------------------------------------------------------------
/*
    2) FOR LOOP문
    [표현식]
    FOR 변수 IN [REVERSE] 초기값..최종값
    LOOP
        반복적으로 실행할 문장
    END LOOP;
*/

BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

DROP TABLE TEST;

CREATE TABLE TEST (
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

SELECT * FROM TEST;

CREATE SEQUENCE SEQ_TNO
START WITH 1
INCREMENT BY 2
MAXVALUE 1000
NOCYCLE
NOCACHE;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUE(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/
-- 왜 안 돼
----------------------------------------------------------------------

/*
    WHILE LOOP문
    
    [표현식]
    WHILE 반복문이 수행될 조건
    LOOP 
        반복 수행하는 문장
    END LOOP;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP  
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
    END LOOP;
END;
/

-----------------------------------------------------------------------------------------

/*
    3. 예외처리부
    예외(EXCEPTION) : 실행 중 발생하는 오류
    
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1;
        WHEN 예외명2 THEN 예외처리구문2;
        ...
    
    *시스템 예외(오라클에서 미리 정의해둔 예외)
    - NO_DATE_FOUND : SELECT한 결과가 한 행도 없을 때
    - TOO_MANY_ROWS : SELECT한 결과가 여러 행일 경우 /너무 많을 때
    - ZERO_DIVIDE : 0으로 나눌 때
    - DUP_VAL_ON_INDEX : UNIQUE 제약 조건에 위배 되었을 경우
    ...
*/

-- 사용자가 입력한 수로 나눗셈 연산한 결과 출력
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
EXCEPTION
    -- WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산 시 0으로 나눌 수 없습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('나누기 연산 시 0으로 나눌 수 없습니다.'); --/ 예외를 다 받아주는 구문
END;
/

-- UNIQUE 제약 조건 위배
-- ALTER TABLE EMPLOYEE ADD PRIMARY KEY(EMP_ID);

BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&변경할사번'
    WHERE EMP_NAME = '노옹철'; -- 200 입력 시 200 사번이 이미 있으므로 예외 발생
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/