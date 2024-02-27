/*
    /인라인 뷰는 SELECT 문 안에서 쓰기 때문에 인라인 뷰
    /서브쿼리를 SELECT로 저장해놓고 테이블처럼 필요할 때 가져와 쓰겠다
    
    <VIEW 뷰>
    
    SELECT문(쿼리문)을 저장해둘 수 있는 객체
    (자주 사용하는 SELECT 문을 저장해두면 긴 SELECT문을 매번 다시 기술할 필요가 없음)
    임시테이블 같은 존재(실제 데이터가 담겨있는 것은 아님 => 논리적인 테이블)
*/

-- 한국에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
--/ 대부분 이렇게 조회, 어떤 항목에 해당하는 것들을 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE) --> 이거 자체를 뷰로 만들어두면 여기서 WHERE만 걸어주면 편하게 가능
WHERE NATIONAL_NAME = '일본';

--------------------------------------------------------------
/*
    1. VIEW 생성 방법
    
    [표현식]
    CREATE VIEW 뷰명
    AS 서브쿼리
*/

--/ 뷰는 FROM 절에서 사용하게 될 것

-- 테이블 : TB_
-- 뷰 : VW_
--/ 회사마다 테이블은 표기가 없는 등 각각 다를 수 있음
--/ FROM 절에서 사용하니까 헷갈리지 않도록

CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
     JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
     JOIN NATIONAL USING (NATIONAL_CODE);
--/ 이 뷰를 불러올 때는 그냥 이 서브쿼리를 한 번 실행하는 것
--/ SELECT 절을 가져온 거니까 당연히 제약조건 란도 없음
-- Ask your database administrator or designated security
--           administrator to grant you the necessary privileges

--GRANT CREATE VIEW TO KH; -- 관리자 계정으로

SELECT * FROM VW_EMPLOYEE;
--/ 왼쪽의 뷰에 이름 붙어서 생김

-- 실제 실행 되는 것은 아래와 같이 서브쿼리로 실행 된다고 볼 수 있음
SELECT * FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
                 FROM EMPLOYEE
                 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 JOIN NATIONAL USING (NATIONAL_CODE));
                 
-- 한국에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

-- 일본에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, BONUS
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
     JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
     JOIN NATIONAL USING (NATIONAL_CODE);
     --/ 실제 테이블은 안 되는 건데 뷰는 어차피 불러오는 거니까 그냥 덮어씌워도 됨
     --/ 덮어씌우는 문법을 제공
     --/ 있으면 덮어씌우고 없으면 만들어줌
     --/ 뷰는 만들 때 CREATE OR REPLACE로 만들면 편함
     
----------------------------------------------------------------------------
/*
    *뷰 컬럼에 별칭 부여
    서브 쿼리의 SELECT절에 함수식이나 산술 연산식이 기술 되어있을 경우 반드시 별칭을 지정해야 함
*/
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별",
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
     FROM EMPLOYEE
     JOIN JOB USING (JOB_CODE); --/"must name this expression with a column alias"
     --/ 산술연산식이 별칭 없이 그대로 들어가 있는 경우 오류남
SELECT * FROM VW_EMP_JOB;

CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 이름, 직급명, 성별, 근무년수) --/ 혹은 이런 식으로 별칭을 다 나열해서 지어도 됨
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING (JOB_CODE);
     
SELECT *
FROM VW_EMP_JOB
WHERE 근무년수 >= 20;

-- 뷰를 삭제하고 싶을 때
DROP VIEW VW_EMP_JOB;

----------------------------------------------------------------------------
-- 생성된 뷰를 통해서 (INSERT, UPDATE, DELETE) 사용 가능
-- 뷰를 통해서 조작하게 되면 실제 데이터가 담겨 있는 테이블에 반영이 됨

CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
     FROM JOB;

SELECT * FROM VW_JOB; -- 논리 테이블(실제 데이터가 담겨있지 않음)
SELECT * FROM JOB;

-- 뷰를 통해서 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴');
--/ 논리 테이블이지만 이걸 통해 INSERT 가능

-- 뷰를 통해서 UPDATE
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- 뷰를 통해서 DELETE
DELETE VW_JOB
WHERE JOB_CODE = 'J8';

--/ 복잡한 SELECT니까 뷰로 가져와서 하는 것 -> 굳이 복잡하게 만들어져 있는 SELECT절을 통해
--/ DML을 쓸 경우는 많이 없음

--------------------------------------------------------------
/*
    *DML 명령어로 조작이 불가능한 경우가 많음
    
    1) 뷰에 정의되어 있지 않은 컬럼을 조작하려고 하는 경우
    2) 뷰에 정의되어 있지 않은 컬럼 중 베이스테이블 상에서 NOT NULL 제약조건이 지정되어 있는 경우 (?)
    3) 산술연산식 또는 함수식으로 정의가 되어있는 경우
    4) 그룹 함수나 GROUP BY 절이 포함된 경우
    5) DISTINCT 구문이 포함된 경우
    6) JOIN을 이용해서 여러 테이블을 연결 시켜놓은 경우
    
    대부분 뷰는 조회를 목적으로 생성, 뷰를 통한 DML은 안 쓰는 게 좋음
*/
/*
    VIEW 옵션
    
    [상세표현식]
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE : 기존의 동일한 뷰가 있을 경우 갱신하고, 존재하지 않을 경우 새로 생성해라
    2) FORCE | NOFORCE
        > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성 되도록 하는 옵션
        > NOFORCE(기본값) : 서브쿼리에 기술된 테이블이 존재하는 테이블이어야만 뷰가 생성 되도록 하는 옵션
    3) WITH CHECK OPTION : DML 시 서브쿼리에 기술된 조건에 부합한 값으로만 DML이 가능하도록 하는 옵션
    4) WITH READ ONLY : 뷰의 조회만 가능하도록 하는 옵션
*/

-- 2) FORCE | NOFORCE
CREATE OR REPLACE NOFORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT; --/table or view does not exist

-- 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 우선은 생기게 됨
CREATE OR REPLACE FORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT; --/ 경고: 컴파일 오류와 함께 뷰가 생성되었습니다.
--/ 나중에 테이블을 만들고 뷰를 먼저 만들겠다는 것
SELECT * FROM VW_EMP;

CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(30)
);

-- 3) WITH CHECK OPTION : 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정 시 오류 발생
-- WITH CHECK OPTION 안 씀
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000;

SELECT * FROM VW_EMP;

-- 200번 사원의 급여를 200만원으로 변경(SALARY >= 3000000 조건에 맞지 않는 변경)이 되지 않음
UPDATE VW_EMP
SET SALARY = 2000000
WHERE EMP_ID = 200; --/ 조건에 맞지 않아 아예 데이터가 사라져버림

ROLLBACK;

CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
WITH CHECK OPTION;

UPDATE VW_EMP
SET SALARY = 2000000
WHERE EMP_ID = 200; --/ view WITH CHECK OPTION where-clause violation
--/ 조건에 맞지 않는 범위의 값을 갖지 않도록 체크 옵션이 막아주는 것

-- 4) WITH READ ONLY : 뷰에 대해 조회만 가능하도록 함
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
    WITH READ ONLY;

SELECT * FROM VW_EMP;

DELETE FROM VW_EMP
WHERE EMP_ID = 200; --/ cannot perform a DML operation on a read-only view
--/ READ ONLY 뷰라 수정할 수 없는 오류