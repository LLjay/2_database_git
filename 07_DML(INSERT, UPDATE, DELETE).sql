/*
    DQL (QUERY 데이터 정의어) : SELECT / 보통 DML에 포함되어 일컬음
    DML (MANIPULATION 데이터 조작어) : INSERT, UPDATE, DELETE /실제 ROW데이터에 대한 기능
    -> CR6? 취업하기 위한 필수?
    DDL (DEFINITION 데이터 정의어) : CREATE, ALTER, DROP
    DCL (CONTROL 데이터 제어) : GRANT, REVOKE
    TCL (TRANSCTION 트랜잭션 제어) : COMMIT, ROLLBACK
    
    <DML>
    : 데이터 조작 언어
    
    테이블 값을 삽입(INSERT)하거나, 수정(UPDATE)하거나, 삭제(DELETE)하는 구문
*/

/*
    1. INSERT
       테이블에 새로운 행을 추가하는 구문
       
    [표현식]
    1) INSERT INTO 테이블명 VALUES(값, 값, 값...)
        > 테이블의 모든 컬럼에 대한 값을 직접 제시해서 한 행을 INSERT 하고자 할 때
        > 컬럼의 순번을 지켜서 VALUES에 값을 나열해야 함
    
    부족하게 값을 제시할 경우 -> not enough values 오류
    값을 더 많이 제시할 경우 -> too many values 오류
*/

SELECT * FROM EMPLOYEE;
INSERT INTO EMPLOYEE 
VALUES(900, '이소근', '880914-1456789', 'SG8809@naver.com', '01075966900',
        'D7', 'J5', 4000000, 0.2, 200, SYSDATE, NULL);
        --/ "not enough values"
INSERT INTO EMPLOYEE 
VALUES(900, '이소근', '880914-1456789', 'SG8809@naver.com', '01075966900',
        'D7', 'J5', 4000000, 0.2, 200, SYSDATE, NULL, 'N', NULL);
        --/ "too many values"
--/ 값을 딱 맞게 넣어줘야 오류가 나지 않는다

/*
    2) INSERT INTO 테이블명(컬럼, 컬럼, 컬럼) VALUES(값, 값, 값)
    / 내가 제시한 컬럼의 데이터만 써서 넣어주면 됨
    테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
    그래도 한 행 단위로 추가되기 때문에 선택 안 된 컬럼은 기본적으로 NULL이 들어감
    => NOT NULL 제약 조건이 걸려있는 컬럼은 반드시 직접 값을 넣어줘야 함
    단, 기본값이 지정되어 있으면 NULL이 아닌 기본값이 들어감
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(901, '이지수', '440701-1234567', 'J7', SYSDATE);

SELECT * FROM EMPLOYEE;

INSERT
  INTO EMPLOYEE
    (
      EMP_ID
     ,EMP_NAME
     ,EMP_NO
     ,JOB_CODE
     ,HIRE_DATE
    )
VALUES
    (
      902
     ,'김개똥'
     ,'870105-224510'
     ,'J7'
     ,SYSDATE
     );
--/ 보통 현업에서는 이런 식으로 씀, 데이터의 길이가 길어지면 쭉 나열하는 게 상당히 불편함
--/ 반드시 매칭이므로 세로로 쓰는 게 편함

/*
    3) INSERT INTO 테이블명 (서브쿼리);
    VALUES로 값을 직접 명시하는 것 대신
    서브쿼리로 조회된 결과값을 통째로 INSERT 가능
*/

-- 테이블 새로 만들기
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

INSERT INTO EMP_01 (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
                    FROM EMPLOYEE
                    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));
                    
----------------------------------------------------------------------

/*
    2. INSERT ALL
    두 개 이상의 테이블에 각각 INSERT 할 때
    이 때 사용되는 서브쿼리가 동일한 경우
*/

--> 테스트 테이블
CREATE TABLE EMP_DEPT
AS (SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1 = 0); --/ 데이터 말고 컬럼만 가져오고 싶으면 조건절에 말도 안 되는 조건을 넣어주면 됨
--/ 어떤 테이블을 복사하려면 AS 테이블명 쓰면 됨

CREATE TABLE EMP_MANAGER
AS (SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1 = 0);
    
-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수 사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';
--/ 이 서브쿼리를 위의 두 개의 테이블에 동시에 INSERT 하고 싶을 때

/*
    [표현식]
    INSERT ALL
    INTO 테이블명1 VALUES(컬럼, 컬럼, 컬럼...)
    INTO 테이블명2 VALUES(컬럼, 컬럼...)
    서브쿼리;
*/

INSERT ALL
    INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
        (SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
           FROM EMPLOYEE
          WHERE DEPT_CODE = 'D1');
        
SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

----------------------------------------------------------------------
/*
    3. UPDATE
    / 회원정보 수정처럼 이미 들어가 있는 ROW 정보를 수정
    테이블에 기록되어 있는 기존의 데이터를 수정하는 구문
    
    [표현식]
    UPDATE 테이블명
    SET 컬럼 = 값,
        컬럼 = 값,
        ... -- AND로 연결하는 것이 아니라 , 로 연결함
    [WHERE 조건] --> 생략 시 전체 모든 행의 데이터 변경
    
    *업데이트 시에도 제약조건을 잘 확인해야 함
    /EX) NOT NULL인데 NULL을 넣거나
*/

CREATE TABLE DEPT_TABLE
AS (SELECT * FROM DEPARTMENT);
SELECT * FROM DEPT_TABLE;

-- D9 부서의 부서명을 '전략기획팀으로 변경'
UPDATE DEPT_TABLE
SET DEPT_TITLE = '전략기획팀' --/ 여기서 업데이트 하면 모든 타이틀 컬럼값이 다 바뀜
WHERE DEPT_ID = 'D9';

CREATE TABLE EMP_SALARY
AS (SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
      FROM EMPLOYEE);
      
SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블에서 변경
-- 노옹철 사원의 급여를 100만원으로 변경
UPDATE EMP_SALARY
SET SALARY = 1000000
WHERE EMP_NAME = '노옹철';

-- 선동일 사원의 급여를 700만원, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '선동일';

-- 전체 사원의 급여를 기존 급여에서 10프로 인상된 금액으로 변경(기존 급여 * 1.1)
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

-- UPDATE 시 서브쿼리 사용하기

/*
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    WHERE 조건
*/

-- 방명수 사원의 급여와 보너스 값을 유재식 사원의 급여와 보너스 값으로 변경
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
                FROM EMP_SALARY
               WHERE EMP_NAME = '유재식'),
    BONUS = (SELECT BONUS
               FROM EMP_SALARY
              WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY
WHERE EMP_NAME = '방명수' OR EMP_NAME = '유재식';

-- 다중열로 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                         FROM EMP_SALARY
                        WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

-- ASIA 지역에서 근무하는 사원들의 보너스 값을 0.3으로 변경
UPDATE EMP_SALARY
SET BONUS = 0.3
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE LOCATION_CODE IN ('L1', 'L2', 'L3');

-- 강사님 예시
SELECT EMP_ID, EMP_NAME
FROM EMP_SALARY 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

-- 해당 사원들의 보너스 값을 0.3으로 변경
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                 FROM EMP_SALARY 
                 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');
                 
SELECT * FROM EMP_SALARY;

COMMIT;
--/ DML의 변경사항 저장
------------------------------------------------------------------

/*
    4. DELETE
    테이블에 기록된 데이터를 삭제하는 구문(한 행 단위로 삭제됨)
    
    [표현식]
    DELETE FROM 테이블명 --/ 역시 조건 안 걸어주면 싹 날아감
    [WHERE 조건] --> WHERE절 제시 안 하면 전체 행 다 삭제됨
*/

DELETE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;

ROLLBACK;
--/ DML의 변경사항을 마지막 COMMIT 지점으로 돌리기

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '이소근';

DELETE FROM EMPLOYEE
WHERE EMP_ID = '901';
--/ 지우는 건 보통 프라이머리 키로 함

COMMIT;

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';
--/ integrity constraint (KH.SYS_C007053) violated - child record found
--/ 제약조건이 기본
-- D1의 값을 가져다 쓰는 자식 데이터가 있기 때문에 삭제 되지 않음