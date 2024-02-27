/*
    <DCL : 데이터 제어문>
    
    계정에게 시스템 권한 또는 객체 접근 권한을 부여하거나 회수하는 구문
    
    > 시스템 권한 : DB에 접근하는 권한, 객체를 생성할 수 있는 권한
    > 객체 접근 권한 : 특정 객체들을 조작할 수 있는 권한
    
    CREATE USER 계정명 IDENTIFIED BY 비밀번호;
    GRANT 권한(RESOURCE, CONNECT) TO 계정;
*/  
SELECT *
FROM ROLE_SYS_PRIVS;

/*
    <TCL : 트랜잭션 제어문>
    /데이터베이스의 연산단위, 연산을 한 번에 처리하는 것을 트랜잭션이라고 함
    /보통 기본은 한 번에 한 쿼리만 실행 -> 하나 할 때마다 저장을 해줌
    /데이터가 변하는 것들만 트랜잭션으로 들어감(INSERT, DELETE 등)
    /데이터가 변하면 실제 데이터가 변하는 게 아니라 임시로 저장해주는 것?
    /여러 쿼리를 한 번에 묶어서 처리

    *트랜잭션
    - 데이터베이스의 논리적 연산 단위
    - 데이터의 변경 사항(DML) 등을 하나의 트랜잭션에 묶어서 처리
      DML문 한 개를 수행할 때 트랜잭션이 존재하지 않는다면 트랜잭션을 만들어서 묶음
                          트랜잭션이 존재한다면 해당 트랜잭션에 묶어서 처리
      COMMIT하기 전까지의 변경 사항들을 하나의 트랜잭션에 담음
      > 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE
      / SELECT는 있는 값을 조회하는 것이기 때문에 데이터의 수정이 아니므로 포함되지 않음
      
      COMMIT(트랜잭션 종료 처리 후 확정)
      ROLLBACK(트랜잭션 취소)
      SAVEPOINT(임시저장)
      
    - COMMIT : 한 트랜잭션에 담겨 있는 변경사항들을 실제 DB에 반영 시키겠다는 의미
    - ROLLBACK : 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT 시점으로 돌아감
    - SAVEPOINT 포인트명 : 현재 시점을 해당 포인트명으로 임시 저장을 해두는 것
*/

DROP TABLE EMP_01;
CREATE TABLE EMP_01
AS (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));
SELECT * FROM EMP_01;

-- 사번이 200번, 201번인 사람 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 200;

DELETE FROM EMP_01
WHERE EMP_ID = 201;

ROLLBACK;

--------------------------------------------------------------
-- 사번이 200번, 201번인 사람 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 200;

DELETE FROM EMP_01
WHERE EMP_ID = 201;

SELECT * FROM EMP_01;
COMMIT; --/ 트랜잭션 영역에 쌓이던 걸 데이터베이스에 실제로 저장, 따라서 트랜잭션 영역은 깔끔해진 상태

--------------------------------------------------------------
-- 217, 216, 214 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (217, 216, 214);
SELECT * FROM EMP_01;
--/ 트랜잭션 영역에 삭제한 것이 담겨있음

SAVEPOINT SP; --/ 217, 216, 214 사원들 삭제한 상태

INSERT INTO EMP_01
VALUES(801, '김말똥', '기술지원부');

DELETE FROM EMP_01
WHERE EMP_ID = 210;

SELECT * FROM EMP_01;

ROLLBACK TO SP; --/ SP 세이브포인트 지점으로 돌아감
ROLLBACK; --/ 세이브포인트 무시하고 전체 다 돌아감
COMMIT;

------------------------------------------------
DELETE FROM EMP_01
WHERE EMP_ID = 210;

-- DDL문 실행
CREATE TABLE TEST(
    TID NUMBER
);

ROLLBACK;
SELECT * FROM EMP_01;

-- DDL문(CREATE, ALTER, DROP)을 수행하는 순간 기존의 트랜잭션에 있던 변경사항들은
-- 무조건 COMMIT이 됨(실제 DB반영이 됨)
-- 즉 DDL문 수행 전 변경사항들이 있다면 정확하게 픽스 후 할 것
