-- 한 줄 주석
/*

여러 줄
주석

*/

SELECT * FROM DBA_USERS; -- 현재 모든 계정들에 대해서 조회하는 명령문
-- 명령문 한 구문 실행 (위쪽의 재생 버튼 클릭 | CTRL + ENTER
-- // 특히 SQL은 세미콜론이 중요, 세미콜론 없으면 그냥 한 줄

-- 일반 사용자 계정을 생성하는 구문(오직 관리자 계정에서만 할 수 있다.)
-- [표현법] CREATE USER 계정명 IDENTIFIED BY 비밀번호;

CREATE USER KH IDENTIFIED BY KH;
-- 계정의 비밀번호는 대소문자를 구분한다.

-- 위에서 생성된 일반 사용자 계정에 최소한의 권한 (접속, 데이터 관리) 부여
-- // 이걸 안 해주면 테스트 단계에서 생성할 수 없다고 뜸
-- [표현법] GRANT 권한1, 권한2... TO 계정명;
GRANT RESOURCE, CONNECT TO KH;
GRANT CREATE VIEW TO KH;
-- // 데이터에 접근할 수 있는 권한 RESOURCE, 접속할 수 있는 권한 CONNECT, 뷰를 만들 수 있는 권한 CREATE VIEW

CREATE USER WK IDENTIFIED BY WK;
GRANT RESOURCE, CONNECT, CREATE VIEW TO WK;

CREATE USER JDBC IDENTIFIED BY JDBC;
GRANT RESOURCE, CONNECT TO JDBC;

CREATE USER LTPROJECT IDENTIFIED BY LTPROJECT;
GRANT RESOURCE, CONNECT, CREATE VIEW TO LTPROJECT;

CREATE USER SERVER IDENTIFIED BY SERVER;
GRANT RESOURCE, CONNECT, CREATE VIEW TO SERVER;

CREATE USER mybatis IDENTIFIED BY mybatis;
GRANT RESOURCE, CONNECT, CREATE VIEW TO mybatis;

CREATE USER spring IDENTIFIED BY spring;
GRANT RESOURCE, CONNECT, CREATE VIEW TO spring;