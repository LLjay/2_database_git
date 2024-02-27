/*
    <시퀀스 SEQUENCE>
    자동으로 번호를 발생 시켜주는 역할을 하는 객체
    정수값을 순차적으로 일정값씩 증가 시키면서 생성해줌
    
    EX) 회원번호, 사원번호, 게시글번호...
    
    [표현식]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작 숫자] --> 처음 발생 시킬 시작값 지정[기본값 1]
    [INCREMEMT BY 숫자] --> 몇 씩 증가시킬 건지[기본값 1]
    [MAXVALUE 숫자] --> 최대값 지정[기본값은 매우 큰 수]
    [MINVALUE 숫자] --> 최소값 지정[기본값 1] --/ 최대값에 도달했을 때 순환할건지 지정 가능
    [CYCLE | NOCYCLE] --> 값의 순환여부 지정 [기본값 NOCYCLE]
    [NOCACHE | CACHE 바이트크기] --> 캐시메모리 할당[기본값 CACHE 20]
    --/ 캐시메모리를 미리 만들어 놓고 데이터가 왔을 때 그냥 주기만 하면 됨
    --/ 그럼 조금 더 빨라짐
    
    *캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                매번 호출될 때마다 새로 번호를 생성하는 게 아니라
                캐시메모리 공간에 미리 생성된 값들을 가져다 쓸 수 있음 (속도가 빨라짐)
                
    테이블명 : TB_
    뷰명 : VW_
    시퀀스명 : SEQ_
    트리거 : TRG_
*/

--/ 기본키를 사람이 넣어주게 되면 실수가 날 수 있음
--/ 시퀀스로 값을 자동으로 넣어줄 것

CREATE SEQUENCE SEQ_TEST;

--[참고] 현재 계정이 소유하고 있는 시퀀스들의 구조를 보고자 할 때
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

SELECT * FROM USER_SEQUENCES;

/*
    2. 시퀀스 사용
    시퀀스명.CURRVAL : 현재 시퀀스 값 (마지막으로 성공한 NEXTVAL의 값)
    / CURRENT
    시퀀스명.NEXTVAL : 시퀀스 값에 일정값을 증가 시켜 발생한 값
                     현재 시퀀스 값에서 INCREMENT BY 값만큼 증가된 값
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 에러
--> NEXTVAL을 한 번도 수행하지 않은 이상 CURRVAL를 실행할 수 없음
--/NEXTVAL을 한 번도 수행하지 않음, 따라서 CURRVAL로 가져올 수 없음
--> CURRVAL는 마지막으로 성공한 NEXTVAL의 값을 저장해서 보여주는 임시값

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
--/ 시작값을 300부터 주기로 했으니까.
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305, 310

SELECT * FROM USER_SEQUENCES;
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 315가 나와야 하는데 MAX를 310으로 했으니 에러 발생

--/ 외래키로 쓸 때 CURRVAL 가끔 씀
--/ 방금 생성된 저 테이블의 기본키를 내가 쓸 수 있음

/*
    3. 시퀀스의 구조 변경
    
    ALTER SEQUENCE 시퀀스명 /수정 한다는 것은 이미 생성되어 사용하고 있는 시퀀스라는 뜻
    X [START WITH 시작 숫자] : 이미 만든 것이므로 변경 불가
    [INCREMEMT BY 숫자] --> 몇 씩 증가시킬 건지[기본값 1]
    [MAXVALUE 숫자] --> 최대값 지정[기본값은 매우 큰 수]
    [MINVALUE 숫자] --> 최소값 지정[기본값 1] --/ 최대값에 도달했을 때 순환할건지 지정 가능
    [CYCLE | NOCYCLE] --> 값의 순환여부 지정 [기본값 NOCYCLE]
    [NOCACHE | CACHE 바이트크기] --> 캐시메모리 할당[기본값 CACHE 20]
    
    *START WITH는 변경 불가
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;

-- 4. 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;

-----------------------------------------------------------------------
CREATE SEQUENCE SEQ_EID
START WITH 400
NOCACHE;

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '김말똥', '111111-2222222', 'J6', SYSDATE);
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '김새똥', '111111-2222222', 'J6', SYSDATE);
SELECT * FROM EMPLOYEE;
--/ 자바에서 똑같이 ID를 넣어줘도 되지만 자바는 데이터를 보유하고 있는 곳이 아니므로
--/ 그 정보를 신뢰할 수 없음 => 데이터베이스에 들어간 정보여야 무결하다고 볼 수 있음
