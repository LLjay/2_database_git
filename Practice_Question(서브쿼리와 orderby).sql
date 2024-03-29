CREATE OR REPLACE VIEW VW_ADVICE
AS (SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO))
    ORDER BY DEPARTMENT_NAME;
    
CREATE TABLE TB_TEST
AS (SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
    ORDER BY DEPARTMENT_NAME);
    
DROP TABLE TB_TEST;

CREATE OR REPLACE VIEW VW_ADVICE
AS (SELECT STUDENT_NAME, DEPARTMENT_NO, COACH_PROFESSOR_NO
    FROM TB_STUDENT
    ORDER BY DEPARTMENT_NO);
    
CREATE OR REPLACE VIEW VW_ADVICE
AS (SELECT STUDENT_NAME, DEPARTMENT_NO, COACH_PROFESSOR_NO
    FROM TB_STUDENT)
    ORDER BY DEPARTMENT_NO;
    
CREATE TABLE TB_ADVICE
AS (SELECT STUDENT_NAME, DEPARTMENT_NO, COACH_PROFESSOR_NO
    FROM TB_STUDENT)
    ORDER BY DEPARTMENT_NO;

DROP TABLE TB_ADVICE;
DROP VIEW VW_ADVICE;

SELECT STUDENT_NAME
FROM (SELECT STUDENT_NAME, DEPARTMENT_NO, COACH_PROFESSOR_NO
    FROM TB_STUDENT
    ORDER BY DEPARTMENT_NO);
    
SELECT STUDENT_NAME, DEPARTMENT_NAME
FROM (SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
    ORDER BY DEPARTMENT_NAME);


SELECT STUDENT_NAME
FROM (SELECT STUDENT_NAME, DEPARTMENT_NO
        FROM (SELECT *
              FROM TB_STUDENT
              ORDER BY DEPARTMENT_NO)); --이건 왜 되냐? 이건 인라인 뷰니까
              
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                         FROM TB_STUDENT
                         WHERE STUDENT_NAME = '이지수')
ORDER BY STUDENT_NAME;

