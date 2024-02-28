/*
    <트리거>
    내가 지정한 테이블에 INSERT, UPDATE, DELETE 등 DML문에 의해 변경 사항이 생길 때
    (테이블에 이벤트가 발생했을 때) /뭔가 데이터가 변경되는 행위가 발생하면 이벤트라고 함
    자동으로 매번 실행할 내용을 미리 정의해 둘 수 있음
    / 트리거도 구조 중 하나
    
    EX)
    회원 탈퇴 시 기존의 회원 테이블의 데이터 DELETE 후 곧바로 탈퇴한 회원들만 따로 보관하는 테이블에
    자동으로 INSERT 시켜야 함
    / -> 쿼리가 두 개, 매번 똑같은 쿼리를 두 번씩 써줘야 함
    
    신고 횟수가 일정 수를 넘었을 때 묵시적으로 해당 회원이 블랙리스트에 올라가도록 처리
    -> UPDATE 횟수 혹은 신고 내역을 INSERT
    
    입출고에 대한 데이터가 기록(INSERT)될 때마다 해당 상품에 대한 재고 수량을 매번 수정(UPDATE)해야 함
    
    *트리거 종류
    - SQL문의 실행 시기에 따른 분류
    > BEFORE TRIGGER : 내가 지정한 테이블에 이벤트가 발생되기 바로 직전에 트리거 실행
    > AFTER TRIGGER : 내가 지정한 테이블에 이벤트가 발생된 후 트리거 실행
    
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
    > 문장 트리거 : 이벤트가 발생한 SQL문에 대해 딱 한 번만 트리거 실행
    > 행 트리거 : 해당 SQL문 실행할 때마다 매번 트리거 실행
                (FOR EACH ROW 옵션 기술해야 함)
                > :OLD -BEFORE UPDATE(수정 전 자료), BEFORE DELETE(삭제 전 자료)
                > :NEW -AFTER INSERT(추가된 자료), AFTER UPDATE(수정 후 자료)
                --/ 이라는 변수가 자동으로 생김
    
    *트리거 생성 구문
    
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE | AFTER              INSERT | UPDATE | DELETE    ON 테이블명
    [FOR EACH ROW] /어떤 행위인지 기술
    [DECLARE 변수 선언] /트리거에 대한 PLSQL
    BEGIN / 이걸로 인해 트리거 실행
        실행 내용(행당 위에 지정된 이벤트 발생 시 묵시적(자동)으로 실행할 구문)
    [EXCEPTION 예외처리]
    END;
    /
*/

-- EMPLOYEE 테이블에 새로운 행이 INSERT 될 때마다 자동으로 출력되는 트리거 정의
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님, 환영합니다.');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES (500, '이순신', '111111-1111111', 'D7', 'J7', SYSDATE);
--/ 삽입되었습니다 구문은 실제 삽입 시간과 전혀 상관 없음
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES (501, '김유신', '111111-1111111', 'D8', 'J8', SYSDATE);

------------------------------------------------------------------------------------
-- 상품 입고 및 출고 관련 예시
--> 필요한 테이블 및 시퀀스 생성

-- 1. 상품에 대한 데이터를 보관하는 테이블 (TB_PRODUCT)
--DROP TABLE TB_PRODUCT;
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- 상품 번호
    PNAME VARCHAR2(30) NOT NULL, -- 상품명
    BRAND VARCHAR2(30) NOT NULL, -- 브랜드
    PRICE NUMBER, -- 가격
    STOCK NUMBER DEFAULT 0 -- 재고
);

SELECT * FROM TB_PRODUCT;

-- 상품번호 중복 안 되게끔 매번 새로운 상품 번호를 발생 시키기 위한 시퀀스 생성
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

-- 샘플 데이터 추가
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시24', '샘송', 1400000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰15', '아이폰15', 1300000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤우미', 700000, 20);

COMMIT; --/ 데이터 INSERT, UPDATE, DELETE 등 데이터 변경 사항에 관련된 행위 하면 무조건 커밋하는 습관

-- 2. 상품 입출고 상세 이력 테이블 생성(TB_PRODETAIL)
-- 어떤 상품이 어떤 날짜에 몇 개가 입고 또는 출고가 되는지 데이터를 기록
CREATE TABLE TB_PRODETAIL(
    DECODE NUMBER PRIMARY KEY, -- 이력 번호
    PCODE NUMBER REFERENCES TB_PRODUCT, -- 상품 번호
    PDATE DATE NOT NULL, -- 입출고일
    AMOUNT NUMBER NOT NULL, -- 입출고 수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고')) -- 상태(입고, 출고)
);

SELECT * FROM TB_PRODETAIL;

-- 이력 번호 매번 새로운 번호를 발생 시켜 들어갈 수 있게 도와줄 시퀀스 생성 /객체에 대한 정보, 그 객체에 사용할 시퀀스
CREATE SEQUENCE SEQ_DECODE
NOCACHE;

-- 200번 상품이 오늘 날짜로 10개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 200, SYSDATE, 10, '입고');

-- 200번 상품의 재고 수량을 10 증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT;

-- 205번 상품이 오늘 날짜로 20개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 205, SYSDATE, 20, '입고');

-- 205번 상품의 재고 수량을 20 증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 205;

--/ 이게 완벽하게 지켜지리라는 보장이 없음

-- TB_PRODETAIL 테이블에 INSERT 이벤트 발생 시
-- TB_PRODUCT 테이블에 매번 자동으로 재고수량 UPDATE 되게끔 트리거 작성
/*
    - 상품이 입고된 경우 -> 해당 상품을 찾아서 재고 수량 증가 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK + 현재 입고된 수량(INSERT 된 자료 AMOUNT)
    WHERE PCODE = 입고된 상품 번호(INSERT 된 자료의 PCODE);
    
        - 상품이 출고된 경우 -> 해당 상품을 찾아서 재고 수량 감소 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK - 현재 출고된 수량(INSERT 된 자료 AMOUNT)
    WHERE PCODE = 출고된 상품 번호(INSERT 된 자료의 PCODE);
*/
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW --/ OLD 혹은 NEW 변수를 쓰겠다
BEGIN
    IF(/*이거 자체가 트리거 생성 시 생기는 변수*/:NEW.STATUS = '입고')
        THEN  UPDATE TB_PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
    
    IF(:NEW.STATUS = '출고')
        THEN UPDATE TB_PRODUCT
             SET STOCK = STOCK - :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

--/ 보통 INSERT는 이 이후에 해야함, INSERT 되어 생성된 데이터를 가져와서 쓸 것이기 때문에
--/ 같은 이유로 DELETE는 이전

-- 210번 상품이 오늘 날짜로 7개 출고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 210, SYSDATE, 7, '출고');

-- 210번 상품이 오늘 날짜로 100개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 200, SYSDATE, 100, '입고');