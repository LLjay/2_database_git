-- 항상 만든 것들을 삭제해주는 코드를 파일 맨 위에 써주는 게 좋음(생성 역순으로)
-- 시퀀스는 만든 시퀀스 바로 위에
-- 하고 처음부터 스크립트 쭉 실행하면 됨

DROP TABLE MEMBER;
DROP TABLE TEST;

CREATE TABLE TEST(
    TNO NUMBER,
    TNAME VARCHAR2(20),
    TDATE DATE
);

SELECT * FROM TEST;
DELETE TEST;
ROLLBACK;

COMMIT;

-------------------------------------------------------------------------
CREATE TABLE MEMBER(
    USERNO NUMBER PRIMARY KEY, -- 번호
    USERID VARCHAR2(15) NOT NULL UNIQUE, -- 아이디
    USERPWD VARCHAR2(15) NOT NULL, -- 비밀번호
    USERNAME VARCHAR2(20) NOT NULL, -- 이름
    GENDER CHAR(1) CHECK(GENDER IN ('M', 'F')), -- 성별
    AGE NUMBER, -- 나이
    EMAIL VARCHAR2(30), -- 이메일
    PHONE CHAR(11), -- 전화번호
    ADDRESS VARCHAR2(100), -- 주소
    HOBBY VARCHAR2(50), -- 취미
    ENROLLDATE DATE DEFAULT SYSDATE NOT NULL -- 가입일
);

SELECT * FROM MEMBER;

DROP SEQUENCE SEQ_USERNO;
CREATE SEQUENCE SEQ_USERNO
NOCACHE;

INSERT INTO MEMBER
VALUES(SEQ_USERNO.NEXTVAL, 'admin', '1234', '관리자', 'F', 45, 'admin@iei.or.kr', '01012345678', '서울', null, '2021-07-27');

INSERT INTO MEMBER
VALUES(SEQ_USERNO.NEXTVAL, 'user01', 'pass01', '홍길동', NULL, 23, 'user01@iei.or.kr', '01022222222', '부산', '등산, 영화보기', '2021-08-07');

COMMIT;

