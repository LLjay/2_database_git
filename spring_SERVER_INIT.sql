----------삭제-------------
--접속유저의 모든 테이블 및 제약조건 삭제
BEGIN
    FOR C IN (SELECT TABLE_NAME FROM USER_TABLES) LOOP
    EXECUTE IMMEDIATE ('DROP TABLE '||C.TABLE_NAME||' CASCADE CONSTRAINTS');
    END LOOP;
END;
/

--접속유저의 모든 시퀀스 삭제
BEGIN
FOR C IN (SELECT * FROM USER_SEQUENCES) LOOP
  EXECUTE IMMEDIATE 'DROP SEQUENCE '||C.SEQUENCE_NAME;
END LOOP;
END;
/

--접속유저의 모든 뷰 삭제
BEGIN
FOR C IN (SELECT * FROM USER_VIEWS) LOOP
  EXECUTE IMMEDIATE 'DROP VIEW '||C.VIEW_NAME;
END LOOP;
END;
/
------------------------------

---------------------------------------
-------------MEMBER관련---------------------
------------------------------------------
CREATE TABLE MEMBER(
    USER_ID VARCHAR2(30) PRIMARY KEY,
    USER_PWD VARCHAR2(100) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    EMAIL VARCHAR2(100),
    GENDER VARCHAR2(1) CHECK (GENDER IN ('M','F')),
    AGE NUMBER,
    PHONE VARCHAR(13),
    ADDRESS VARCHAR2(100),
    ENROLL_DATE DATE DEFAULT SYSDATE,
    MODIFY_DATE DATE DEFAULT SYSDATE,
    STATUS VARCHAR2(1) DEFAULT 'Y' CHECK (STATUS IN('Y', 'N'))
);

COMMENT ON COLUMN MEMBER.USER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.USER_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.USER_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.PHONE IS '회원전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '회원이메일';
COMMENT ON COLUMN MEMBER.GENDER IS '회원성별';
COMMENT ON COLUMN MEMBER.AGE IS '회원나이';
COMMENT ON COLUMN MEMBER.ADDRESS IS '회원주소';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원가입일';
COMMENT ON COLUMN MEMBER.MODIFY_DATE IS '정보수정일';
COMMENT ON COLUMN MEMBER.STATUS IS '상태값(Y/N)';

INSERT INTO MEMBER
VALUES ('admin', '1234', '관리자', 'admin@kh.or.kr', 'F', 30, '010-1111-2222', '서울시 강남구 역삼동', '20230101', '20230101', DEFAULT);

INSERT INTO MEMBER
VALUES ('user01', 'pass01', '홍길동', 'user01@kh.or.kr', 'M', 25, '010-3333-4444', '서울시 양천구 목동', '20230201', '20230201', DEFAULT);

INSERT INTO MEMBER
VALUES ('user02', 'pass02', '김말똥', 'user02@kh.or.kr', 'F', 23, '010-5555-6666', '서울시 강서구 마곡', '20230301', '20230301', DEFAULT);


-------------------------------------------------
------------NOTICE관련------------------------
--------------------------------------------


CREATE TABLE NOTICE(
    NOTICE_NO NUMBER PRIMARY KEY,
    NOTICE_TITLE VARCHAR2(30) NOT NULL,
    NOTICE_WRITER VARCHAR2(30) NOT NULL,
    NOTICE_CONTENT VARCHAR2(200) NOT NULL,
    CREATE_DATE DATE DEFAULT SYSDATE,
    FOREIGN KEY(NOTICE_WRITER) REFERENCES MEMBER(USER_ID) ON DELETE CASCADE
);

COMMENT ON COLUMN NOTICE.NOTICE_NO IS '공지사항번호';
COMMENT ON COLUMN NOTICE.NOTICE_TITLE IS '공지사항제목';
COMMENT ON COLUMN NOTICE.NOTICE_WRITER IS '작성자아이디';
COMMENT ON COLUMN NOTICE.NOTICE_CONTENT IS '공지사항내용';
COMMENT ON COLUMN NOTICE.CREATE_DATE IS '공지사항작성일';

CREATE SEQUENCE SEQ_NNO
NOCACHE;

INSERT INTO NOTICE VALUES (SEQ_NNO.NEXTVAL, '관리자 공지', 'admin',
                            '공지서비스를 게시합니다. 많이 이용해주세요',
                            '20230201');
                            
INSERT INTO NOTICE VALUES (SEQ_NNO.NEXTVAL, '공지서비스 오픈 환영', 'admin',
                            '드디어 오픈되었군요. 많이 이용하겠습니다.',
                            '20230201');

INSERT INTO NOTICE VALUES (SEQ_NNO.NEXTVAL, '공지서비스 이용안내', 'admin',
                            '공지서비스는 회원만 이용할 수 있습니다. 회원가입하세요.',
                            '20230201');

COMMIT;

-------------------------------------------------------
----------------- BOARD 관련 ------------------------
-------------------------------------------------------

CREATE TABLE BOARD(
    BOARD_NO NUMBER PRIMARY KEY,
    BOARD_TITLE VARCHAR2(100) NOT NULL,
    BOARD_WRITER VARCHAR2(15) NOT NULL,
    BOARD_CONTENT VARCHAR2(4000) NOT NULL,
    ORIGIN_NAME VARCHAR2(100),
    CHANGE_NAME VARCHAR2(100),
    COUNT NUMBER DEFAULT 0,
    CREATE_DATE DATE DEFAULT SYSDATE,
    STATUS VARCHAR2(1) DEFAULT 'Y' CHECK (STATUS IN('Y', 'N')),
    FOREIGN KEY (BOARD_WRITER) REFERENCES MEMBER ON DELETE CASCADE
);

COMMENT ON COLUMN BOARD.BOARD_NO IS '게시글번호';
COMMENT ON COLUMN BOARD.BOARD_TITLE IS '게시글제목';
COMMENT ON COLUMN BOARD.BOARD_WRITER IS '작성자아이디';
COMMENT ON COLUMN BOARD.BOARD_CONTENT IS '게시글내용';
COMMENT ON COLUMN BOARD.ORIGIN_NAME IS '첨부파일원래이름';
COMMENT ON COLUMN BOARD.CHANGE_NAME IS '첨부파일변경이름';
COMMENT ON COLUMN BOARD.COUNT IS '게시글조회수';
COMMENT ON COLUMN BOARD.CREATE_DATE IS '게시글작성일';
COMMENT ON COLUMN BOARD.STATUS IS '게시글상태값(Y/N)';

CREATE SEQUENCE SEQ_BNO
NOCACHE;

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '관리자 게시글', 'admin',
        '저희 사이트를 이용해 주셔서 감사합니다.', NULL, NULL,
        DEFAULT, '20220210', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'MVC Model2 패턴이란', 'user01',
        '웹 애플리케이션 설계 방식 중 하나입니다.', NULL, NULL,
        DEFAULT, '20220211', DEFAULT);  
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '설계방식 2', 'user02',
        '웹 애플리케이션 설계 방식 중 두번째 방식은 각 서블릿 구동 앞에 First Controller를 두는 것입니다.', 
        NULL, NULL, DEFAULT, '20220212', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '설계방식 3', 'user02',
        '웹 애플리케이션 설계 방식 중 세번째 방식은 Front Controller 다음에 연결되는 컨트롤러들을 서블릿이 아닌 자바 클래스로 작성해서 연결하는 방식입니다.', 
        NULL, NULL, DEFAULT, '20220220', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'MVC Modell 패턴', 'user01',
        '웹 애플리케이션 설계 방식 중 JSP 파일이 뷰와 컨트롤러 두가지 다를 처리하는 방식입니다.', 
        NULL, NULL, DEFAULT, '20220220', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'JSP란', 'user02',
        'Java Server Page를 말함', 
        NULL, NULL, DEFAULT, '20220221', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'Servlet이란', 'admin',
        '서버에서 구동되는 웹 규약이 적용된 Java EE모듈이 제공하는 서비스 처리용 클래스임.', 
        NULL, NULL, DEFAULT, '20220221', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'HTML5', 'user02',
        '새로운 웹 표준기술로 모든 디바이스 장치와 브라우저에서 동일하게 작동되는 웹페이지를 만들기 위한 기술을 제공한다.', 
        NULL, NULL, DEFAULT, '20220301', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'CSS3', 'user02',
        '웹 페이지를 꾸미기 위한 스타일시트로 HTML5 버전에 맞추어 속성들이 업그레이드 되었다.', 
        NULL, NULL, DEFAULT, '20220301', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'jQuery 란', 'admin',
        '자바스크립트 오픈 소스 라이브러리의 하나로 html 요소들을 css 선택자를 이용해서 쉽게 선택할 수 있는 기능들을 제공한다.', 
        NULL, NULL, DEFAULT, '20221021', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, 'ajax 란', 'admin',
        'asynchronos javascript and xml의 줄임말로 서버의 서블릿과 직접 통신하는 자바스크립트 기술이다.', 
        NULL, NULL, DEFAULT, '20221021', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '필터(Filter) 란', 'user02',
        '클라이언트 요청한 서비스가 서블릿으로 전달되기 전에 먼저 구동되는 클래스이다.', 
        NULL, NULL, DEFAULT, '20221021', DEFAULT);
        
INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '래퍼(Wrapper) 란', 'user01',
        '필터가 낚아챈 요청에 대한 데이터 처리를 담당하는 클래스이다.', 
        NULL, NULL, DEFAULT, '20221021', DEFAULT);
        
        
--------------------------------------------------------------------------
------------------------ REPLY 관련 ---------------------------
--------------------------------------------------------------------

CREATE TABLE REPLY(
    REPLY_NO NUMBER PRIMARY KEY,
    REPLY_CONTENT VARCHAR2(400) NOT NULL,
    REF_BNO NUMBER NOT NULL,
    REPLY_WRITER VARCHAR2(15) NOT NULL,
    CREATE_DATE DATE DEFAULT SYSDATE NOT NULL,
    STATUS VARCHAR2(1) DEFAULT 'Y' CHECK (STATUS IN ('Y','N')),
    FOREIGN KEY (REF_BNO) REFERENCES BOARD(BOARD_NO),
    FOREIGN KEY (REPLY_WRITER) REFERENCES MEMBER(USER_NO)
);

COMMENT ON COLUMN REPLY.REPLY_NO IS '댓글번호';
COMMENT ON COLUMN REPLY.REPLY_CONTENT IS '댓글내용';
COMMENT ON COLUMN REPLY.REF_BNO IS '참조하는게시글번호';
COMMENT ON COLUMN REPLY.REPLY_WRITER IS '댓글작성자아이디';
COMMENT ON COLUMN REPLY.CREATE_DATE IS '댓글작성일';
COMMENT ON COLUMN REPLY.STATUS IS '상태값(Y/N)';

CREATE SEQUENCE SEQ_RNO
NOCACHE;

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '첫번째 댓글입니다.', 1, 'admin', '20220213', DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '첫번째 댓글입니다.', 13, 'user01', '20221030', DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '두번째 댓글입니다.', 13, 'user02', '20221030', DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '마지막 댓글입니다.', 13, 'admin', '20221030', DEFAULT);

COMMIT;