/*
    *DDL : 데이터 정의 언어
    오라클에서 제공하는 객체를 새로 만들고(CREATE), 구조를 변경하고(ALTER), 구조 자체를 삭제(DELETE) 하는 언어
    즉, 실제 데이터 값이 아닌 규칙 자체를 정의하는 언어
    
    오라클에서의 객체(구조) : 테이블, 뷰, 시퀀스, 인덱스, 패키지, 트리거
                         프로시저, 함수, 동의어, 사용자
    
    <CREATE>
    객체를 새로 생성하는 구문
*/

/*
    1. 테이블 생성
    - 테이블 : 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
              모든 데이터들은 테이블을 통해서 저장됨
              
    CREATE TABLE 테이블명 (
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형,
        ...
    )
    
    *자료형
    - 문자 (CHAR(바이트 크기) | VARCHAR2(바이트 크기)) /문자는 무조건 바이트 크기를 써줘야 함
        CHAR : 최대 2000바이트까지 지정 가능 / 고정 길이 (고정된 글자 수의 데이터가 담길 경우) //주민등록번호, 전화번호 등
        (지정한 크기보다 더 작은 값이 들어오면 공백으로라도 채워서 처음 지정한 크기를 만들어줌)
        VARCHAR2 : 최대 4000바이트까지 지정 가능 / 가변 길이(몇 글자의 데이터가 담길지 모르는 경우)
        (담긴 값에 따라서 공간 크기가 맞춰짐)
    - 숫자 (NUMBER)
    - 날짜 (DATE)

*/

-- 회원에 대한 데이터를 담기 위한 테이블 MEMBER 생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13), --/ 가변이면서도 13자리 정도면 충분히 들어가므로 설정한 값
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
); --/ 테이블 만드는 것만 함, 여기에 이것저것 설정을 넣어줄 것

SELECT * FROM MEMBER;

--------------------------------------------------------------------------
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
--/ 관리자 계정의 테이블 => 데이터베이스를 유지하기 위한 테이블들, 정렬이나 어떤 기능을 하기 위해
--/ 처음 만들 때부터 생성해둔 기본 테이블
SELECT * FROM USER_TABLES;
--/ 기존 DB에 있던 걸 다른 DB로 이전하는 것 : 마이그레이션
SELECT * FROM USER_TAB_COLUMNS;
--------------------------------------------------------------------------

/*
    2. 컬럼에 주석 달기(컬럼에 대한 간단한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    -> 잘못 작성 시 새로 수정하면 됨
*/

COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남/여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';


-- 테이블 삭제 : DROP TABLE 테이블명;
DROP TABLE MEMBER;
--/ 보통 테이블 생성 전에 꼬이지 말라고 삭제해줌

-- 테이블에 데이터를 추가시키는 구문(INSERT)
-- INSERT INTO 테이블명 VALUES(값, 값, 값, 값, 값, ... 값) /이 방법 사용 시 컬럼 처음부터 끝행까지 값을 다 넣어줘야 함
INSERT INTO MEMBER
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM', '24/02/23');

SELECT * FROM MEMBER;

INSERT INTO MEMBER
VALUES(2, 'USER2', 'PASS2', '이지수', '여', '010-5240-0484', NULL, SYSDATE);

INSERT INTO MEMBER
VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
--/ 이런 식의 데이터가 들어가면 안 됨, 기본키도 설정할 수 없고 데이터 자체도 없음

-------------------------------------------------------------------------
/*
    <제약조건>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해서 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 함
    --/ 내가 원하는 상태를 유지하는 게 무결성 보장, 그 상태가 깨지면 무결성이 깨진다고 함
    
    종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
*/

/* 
    *NOT NULL 제약 조건
    해당 컬럼에 반드시 값이 존재해야만 하는 경우 (즉, 절대 NULL이 들어오면 안 되는 경우)
    삽입 / 수정 시 NULL 값을 허용하지 않도록 제한
    
    제약 조건을 부여하는 방식은 크게 2가지 있음 (컬럼 레벨 방식 / 테이블 레벨 방식)
    NOT NULL 제약 조건은 무조건 컬럼 레벨 방식으로만 가능함
*/

CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),--/ 서비스 별로 필요한 내용인지를 확인하면 됨, 필수사항인지 선택사항인지
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

SELECT * FROM MEM_NOTNULL;

INSERT INTO MEM_NOTNULL
VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);

INSERT INTO MEM_NOTNULL
VALUES(3, NULL, 'PASS2', '홍길순', NULL, NULL, NULL);
-- 의도했던 대로 오류 발생 (NOT NULL 제약 조건에 위배되어 오류 발생)

INSERT INTO MEM_NOTNULL
VALUES(3, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);
-- 아이디가 중복 되었음에도 불구하고 잘 추가가 됨 => 이러면 안 됨

-------------------------------------------------------------------------
/*
    *UNIQUE 제약 조건
    해당 컬럼에 중복된 값이 들어가서는 안 될 경우 사용
    컬럼값에 중복값을 제한하는 제약 조건
    삽입 / 수정 시 기존에 있는 데이터 값 중 중복값이 있을 경우 오류를 발생시킴
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼 레벨 방식
    --/ 컬럼 레벨 방식이 직관적으로 어떤 설정이 있는지 눈에 더 잘 보임, 보통 컬럼 레벨을 선호
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),--/ 서비스 별로 필요한 내용인지를 확인하면 됨, 필수사항인지 선택사항인지
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50)
    -- UNIQUE(MEM_ID) -- 테이블 레벨 방식
);

SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER1', 'PASS2', '홍길순', '여', NULL, NULL);
-- UNIQUE 제약 조건에 위배되었으므로 INSERT 실패
--> 오류 구문을 제약 조건명으로 알려줌
--> 쉽게 파악하기 어려움
--> 제약 조건 부여 시 제약 조건명을 지정해주지 않으면 시스템에서 이름을 부여함
--/ UNIQUE 조건에 위배된다고 뜸
--/ 이때 오류에 뜨는 KH.SYS_C007024는 제약조건 이름, 해당 테이블의 제약 조건에 들어가보면 확인할 수 있는 코드

-----------------------------------------------------------------------
/*
    *제약 조건 부여 시 제약 조건 명까지 지어주는 방법
    > 컬럼 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 (CONSTRAINT 제약 조건명) 제약 조건 --/ 생략 가능, 없으면 시스템이 알아서 지정
    )
    
    > 테이블 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        (CONSTRAINT 제약 조건명) 제약 조건 (컬럼명)
    )
*/

DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER CONSTRAINT MEMNO_NT NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NT NOT NULL, 
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NT NOT NULL, 
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NT NOT NULL,
    GENDER CHAR(3), --/ 제약 조건 명은 다른 테이블이더라도 중복될 수 없음
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID) --/ 한 줄 길이가 길어지면 테이블 레벨로 빼도 됨
);
SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);

INSERT INTO MEM_UNIQUE
VALUES(3, 'USER3', NULL, '홍길순', '여', NULL, NULL); --/ 제약 조건 위배

INSERT INTO MEM_UNIQUE
VALUES(4, 'USER4', 'PASS4', NULL, NULL, NULL, NULL);

----------------------------------------------------------------------------
/*
    *CHECK(조건식)
    해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해줄 수 있음
    해당 조건을 만족하는 데이터 값만 담을 수 있음
*/
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- 남, 여 --/ F, M 어퍼케이스 같은 걸로 다 걸어주면 가져올 때마다 함수를 다 실행해야 함
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID) --/ 한 줄 길이가 길어지면 테이블 레벨로 빼도 됨
);

INSERT INTO MEM_CHECK
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK
VALUES(2, 'USER2', 'PASS2', '홍길순', 'ㅇ', NULL, NULL);
--> CHECK 제약 조건 때문에 에러가 발생함
--> 만일 GENDER 컬럼에 데이터를 넣고자 한다면 CHECK 제약 조건에 만족하는 값을 넣어야 함
INSERT INTO MEM_CHECK
VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);
--> NULL은 값이 없다는 뜻이기 때문에 가능
--/ NOT NULL만 없다면 들어갈 수 있음

-------------------------------------------------------------------------
/*
    PRIMARY KEY(기본키) 제약 조건
    테이블에서 각 행(ROW)을 식별하기 위해 사용될 컬럼에 부여하는 제약 조건(식별자 역할)
    
    EX) 회원번호, 학번, 군번, 부서코드, 직급코드, 주문번호, 택배 운송장 번호, 예약번호 등등
    PRIMARY KEY 제약 조건을 부여 -> NOT NULL + UNIQUE 와 같음
    --/ PRIMARY KEY는 각 테이블에 하나씩만 가능
    
    유의사항 : 한 테이블 당 오직 한 개만 설정 가능
*/

CREATE TABLE MEM_PRI(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- 남, 여 --/ F, M 어퍼케이스 같은 걸로 다 걸어주면 가져올 때마다 함수를 다 실행해야 함
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID) --PRIMARY KEY(MEM_NO)
);

INSERT INTO MEM_PRI
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_PRI
VALUES(1, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);
--> 기본키에 중복값을 담으려고 할 때(UNIQUE 제약 조건 위반)

INSERT INTO MEM_PRI
VALUES(2, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);

------------------------------------------------------------------------
CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL, 
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- 남, 여 --/ F, M 어퍼케이스 같은 걸로 다 걸어주면 가져올 때마다 함수를 다 실행해야 함
    PHONE VARCHAR2(13), 
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID),
    PRIMARY KEY(MEM_NO, MEM_ID)
);

-- 복합키 : 두 개의 컬럼을 동시에 하나의 PRIMARY KEY로 지정하는 것
--/ 다대다 관계는 서로 키를 가지고 있을 수 없음
--/ 유저가 상품을 찜했을 때 이건 1대다 관계가 됨
--/ 근데 같은 상품을 다시 찜할 수는 없음
--/ 따라서 유저의 기본키와 상품의 기본키를 합쳐서 찜하기 테이블에서 복합키로 사용
--/ 좋아요, 북마크, 즐겨찾기 등

CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

-- 회원 2명 (1번 2번) 존재
-- 가방A 가방B 상품 존재

--/ 참조할 컬럼명을 생략하면 그 테이블의 PRIMARY KEY로 참조함

--/ 삭제가 잘 되거나 해당 데이터를 사용하고 있던 자식 데이터도 같이 삭제 되는 것 중
--/ 어느 게 더 좋을까 -> 정책에 따라 다름
--/ 찜했던 상품, 사용자를 삭제하면 그 데이터는 사라져야 함


--/ 테이블 수정 시에는 DROP으로 삭제하고 다시 만드는 게 빠르지만
--/ 서비스 하는 도중에는 삭제할 수 없음
--/ 이럴 때 수정

--/ 서비스 굴러가고 있을 때 수정하는 게 많은데 굴러가고 잇을때 기존에 잇는 제약조건을 삭제할 경우는 거의 없음
--/ DROP으로 PRIMARY KEY 삭제하면 됨
--/ 기능 위치에 DROP 넣으면 되지만 거의 쓸 일 없음

--EMPLOYEE 테이블에 DEPT_cODE에 외래키 제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;
-- EMPLOYEE 테이블에 JOB_CODE에 외래키 제약조건 추가
-- DEPARTMENT 테이블에 LOCATION_ID에 외래키 제약 조건 추가