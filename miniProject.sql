DROP SEQUENCE SEQ_ROLLNO;
DROP SEQUENCE SEQ_INOUTNO;
DROP SEQUENCE SEQ_PRONO;
DROP SEQUENCE SEQ_DVNO;
DROP SEQUENCE SEQ_MEMNO;

DROP TABLE TB_MEMROLL;
DROP TABLE TB_INOUTLIST;
DROP TABLE TB_PRODUCTION;
DROP TABLE TB_DEVICE;
DROP TABLE TB_MEMBER;

-- 회원가입 한 멤버
CREATE TABLE TB_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) NOT NULL UNIQUE,
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    USER_GRADE CHAR(9) DEFAULT '회원' NOT NULL CHECK(USER_GRADE IN ('관리자', '회원')),
    USER_POINT NUMBER DEFAULT 0,
    ENROLL_DATE DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN TB_MEMBER.USER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.USER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.USER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.USER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.USER_GRADE IS '등급';
COMMENT ON COLUMN TB_MEMBER.USER_POINT IS '포인트';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

-- 장비 리스트
CREATE TABLE TB_DEVICE(
    DV_NO NUMBER PRIMARY KEY,
    DV_CATEGORY VARCHAR2(15) CHECK (DV_CATEGORY IN ('MovingLight', 'Convention', 'Line')) NOT NULL,
    DV_NAME VARCHAR2(40) NOT NULL,
    DV_MANUFACTURE VARCHAR2(30),
    DV_TOTALQTY NUMBER DEFAULT 0 NOT NULL,
    DV_POWER NUMBER,
    DV_WEIGHT NUMBER,
    DV_LAMP VARCHAR2(9)
);

COMMENT ON COLUMN TB_DEVICE.DV_NO IS '장비번호';
COMMENT ON COLUMN TB_DEVICE.DV_CATEGORY IS '장비종류';
COMMENT ON COLUMN TB_DEVICE.DV_NAME IS '장비명';
COMMENT ON COLUMN TB_DEVICE.DV_MANUFACTURE IS '제조사';
COMMENT ON COLUMN TB_DEVICE.DV_TOTALQTY IS '총수량';
COMMENT ON COLUMN TB_DEVICE.DV_POWER IS '전력량(W)';
COMMENT ON COLUMN TB_DEVICE.DV_WEIGHT IS '무게(kg)';
COMMENT ON COLUMN TB_DEVICE.DV_LAMP IS '램프';

-- 프로덕션 리스트
CREATE TABLE TB_PRODUCTION(
    PRO_NO NUMBER PRIMARY KEY,
    PRO_CATEGORY VARCHAR(20) NOT NULL,
    PRO_TITLE VARCHAR2(60) NOT NULL,
    PRO_THEATRE VARCHAR(50) NOT NULL,
    PRO_OPENING DATE NOT NULL,
    PRO_CLOSING DATE NOT NULL
);

COMMENT ON COLUMN TB_PRODUCTION.PRO_NO IS '공연번호';
COMMENT ON COLUMN TB_PRODUCTION.PRO_CATEGORY IS '공연분류';
COMMENT ON COLUMN TB_PRODUCTION.PRO_TITLE IS '공연명';
COMMENT ON COLUMN TB_PRODUCTION.PRO_THEATRE IS '극장';
COMMENT ON COLUMN TB_PRODUCTION.PRO_OPENING IS '개막일';
COMMENT ON COLUMN TB_PRODUCTION.PRO_CLOSING IS '폐막일';

-- 프로덕션 별 장비 수량 저장하는 중계테이블
CREATE TABLE TB_INOUTLIST(
    INOUTNO NUMBER PRIMARY KEY,
    PRO_NO NUMBER REFERENCES TB_PRODUCTION(PRO_NO) NOT NULL,
    DV_NO NUMBER REFERENCES TB_DEVICE(DV_NO) NOT NULL,
    OUT_QTY NUMBER,
    IN_QTY NUMBER,
    OUT_DATE DATE,
    IN_DATE DATE,
    MEMO VARCHAR2(1500)
);

COMMENT ON COLUMN TB_INOUTLIST.INOUTNO IS '반입출번호';
COMMENT ON COLUMN TB_INOUTLIST.PRO_NO IS '공연번호';
COMMENT ON COLUMN TB_INOUTLIST.DV_NO IS '장비번호';
COMMENT ON COLUMN TB_INOUTLIST.OUT_QTY IS '반출수량';
COMMENT ON COLUMN TB_INOUTLIST.IN_QTY IS '반입수량';
COMMENT ON COLUMN TB_INOUTLIST.OUT_DATE IS '반출일';
COMMENT ON COLUMN TB_INOUTLIST.IN_DATE IS '반입일';
COMMENT ON COLUMN TB_INOUTLIST.MEMO IS '비고란';

-- 프로덕션 별 역할 멤버 저장하는 중계테이블
CREATE TABLE TB_MEMROLL(
    MEMBER_NO NUMBER REFERENCES TB_MEMBER(USER_NO) NOT NULL,
    PRO_NO NUMBER REFERENCES TB_PRODUCTION(PRO_NO) NOT NULL,
    ROLL_NAME VARCHAR2(30) NOT NULL,
    PRIMARY KEY(MEMBER_NO, PRO_NO)
);

COMMENT ON COLUMN TB_MEMROLL.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMROLL.PRO_NO IS '공연번호';
COMMENT ON COLUMN TB_MEMROLL.ROLL_NAME IS '직책명';


CREATE SEQUENCE SEQ_MEMNO
NOCACHE;

CREATE SEQUENCE SEQ_DVNO
NOCACHE;

CREATE SEQUENCE SEQ_PRONO
NOCACHE;

CREATE SEQUENCE SEQ_INOUTNO
NOCACHE;

CREATE SEQUENCE SEQ_ROLLNO
NOCACHE;

INSERT INTO TB_MEMBER
VALUES(SEQ_MEMNO.NEXTVAL, 'admin', 'admin', 'Administrator', '관리자', DEFAULT, '20/01/01');

INSERT INTO TB_DEVICE
VALUES(SEQ_DVNO.NEXTVAL, 'MovingLight', 'sola spot pro cmy', 'highend', 30, 720, 40, 'LED');
INSERT INTO TB_DEVICE (DV_NO, DV_CATEGORY, DV_NAME, DV_MANUFACTURE, DV_TOTALQTY, DV_POWER, DV_WEIGHT)
VALUES(SEQ_DVNO.NEXTVAL, 'Convention', 'f101', 'adb', 100, 1200, 25.5);
INSERT INTO TB_DEVICE (DV_NO, DV_CATEGORY, DV_NAME, DV_TOTALQTY)
VALUES(SEQ_DVNO.NEXTVAL, 'Line', 'extension 10m', 50);

INSERT INTO TB_PRODUCTION
VALUES(SEQ_PRONO.NEXTVAL, '뮤지컬', '하데스타운', 'LG아트센터', '24/06/28', '24/09/15');
INSERT INTO TB_PRODUCTION
VALUES(SEQ_PRONO.NEXTVAL, '연극', '네이처오브포겟팅', '아트원씨어터 2관', '24/10/05', '24/12/25');
INSERT INTO TB_PRODUCTION
VALUES(SEQ_PRONO.NEXTVAL, '뮤지컬', '위키드', '블루스퀘어', '24/11/30', '25/02/26');

COMMIT;

CREATE OR REPLACE VIEW VW_INOUTLIST
AS (SELECT * FROM TB_PRODUCTION
    LEFT JOIN TB_INOUTLIST USING (PRO_NO)
    LEFT JOIN TB_DEVICE USING (DV_NO));



--SELECT * FROM TB_DEVICE;
--SELECT * FROM TB_PRODUCTION;
--SELECT * FROM TB_MEMROLL;
--SELECT * FROM TB_MEMBER;

CREATE OR REPLACE TRIGGER TRG_PLUSPOINT
AFTER INSERT ON TB_MEMROLL
FOR EACH ROW
BEGIN
    UPDATE TB_MEMBER
    SET USER_POINT = USER_POINT + 1
    WHERE USER_NO = :NEW.MEMBER_NO;
    
--    IF 멤버 포인트가 30이라면 회원등급 관리자로 업데이트
END;
/

CREATE OR REPLACE VIEW VW_MEMROLL
AS (SELECT * FROM TB_PRODUCTION
    LEFT JOIN TB_MEMROLL USING (PRO_NO)
    LEFT JOIN TB_MEMBER ON (MEMBER_NO = USER_NO));

INSERT INTO TB_MEMBER
VALUES(SEQ_MEMNO.NEXTVAL, 'user01', 'user01', '어시', '회원', 29, '21/01/01');

COMMIT;