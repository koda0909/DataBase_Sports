-- 데이터베이스 생성 (DDL: Data Definition Language)
-- CREATE DATABASE sportscenter;

-- 회원 테이블 tbs_테이블명, viw_뷰명(DDL)

CREATE TABLE members
(
    member_id  SERIAL  PRIMARY KEY,
    name       VARCHAR(30) NOT NULL,
    gender     CHAR(1)     NOT NULL,
    birth_year SMALLINT    NOT NULL,
    phone      VARCHAR(20),
    email      VARCHAR(50),
    region     VARCHAR(10),
    join_date  DATE        NOT NULL
);

-- 회원등록
-- INSERT INTO members (컬럼1, 컬럼2, 컬럼3) VALUES (컬럼값1, 컬럼값2, 컬럼값3);

-- INSERT INTO members VALUES (모든 컬럼, , , ,)
-- INSERT INTO members SELECT * FROM WHERE ~~~

-- INSERT INTO members (컬럼1, 컬럼2, 컬럼3) 
-- VALUES 
-- (컬럼값1, 컬럼값2, 컬럼값3),
-- (컬럼값1, 컬럼값2, 컬럼값3),
-- (컬럼값1, 컬럼값2, 컬럼값3),
-- (컬럼값1, 컬럼값2, 컬럼값3)

-- Data Manipulate Language (DML) - 데이터 조작 언어

INSERT INTO members 
(
    name, 
    gender, 
    birth_year, 
    phone, 
    email, 
    region, 
    join_date
)
VALUES
(
    '김하늘', 
    'F', 
    1995, 
    '010-1234-5678', 
    'haneul@example.com', 
    '마포구', 
    '2026-09-01'
);

-- 종목 개설강좌 테이블
CREATE TABLE sports
(
    sports_id    SERIAL   PRIMARY KEY,
    sports_name  VARCHAR(20) NOT NULL
);

INSERT INTO sports (sports_name) VALUES ('수영');
INSERT INTO sports (sports_name) VALUES ('헬스');

-- 개설 강좌
CREATE TABLE courses
(
    course_id       SERIAL      PRIMARY KEY,
    sports_id       INT         NOT NULL REFERENCES sports(sports_id), -- 외래키 (Foreign Key)
    course_name     VARCHAR(30) NOT NULL,
    level           VARCHAR(10) NOT NULL,
    class_days      VARCHAR(10) NOT NULL,
    start_time      TIME        NOT NULL,
    capacity        SMALLINT    NOT NULL,
    fee             INT         NOT NULL
);

INSERT INTO courses (sports_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (1, '수영 초급 새벽반', '초급', '월수금', '06:00', 20, 70000);
INSERT INTO courses (sports_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (2, '헬스 자유이용', '자유', '매일', '06:00', 50, 50000);

INSERT INTO courses (sports_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (30, '헬스 자유이용', '자유', '매일', '06:00', 50, 50000);

-- 1:1 사물함 테이블
CREATE TABLE lockers(
    locker_no      INT      PRIMARY KEY,
    member_id      INT      NOT NULL UNIQUE REFERENCES members(member_id) ON DELETE CASCADE,
    asign_date     DATE     NOT NULL
);

INSERT INTO lockers VALUES (101, 1, '2026-11-01');

INSERT INTO lockers VALUES (102, 3, '2026-11-01');

--  수강 신청 테이블
CREATE TABLE enrollments
(
    member_id        INT           NOT NULL REFERENCES members(member_id),
    course_id        INT           NOT NULL REFERENCES courses(course_id),
    enroll_month     CHAR(7)       NOT NULL,
    status           VARCHAR(10)   NOT NULL,
    pay_amount       NUMERIC(10,2) NOT NULL CHECK (pay_amount >= 0),
    PRIMARY KEY (member_id, course_id, enroll_month)
);

INSERT INTO enrollments 
VALUES (1, 1, '2026-11', '수료', 50000);

INSERT INTO enrollments 
VALUES (2, 2, '2026-11', '수료', 70000);

INSERT INTO enrollments 
VALUES (2, 2, '2026-11', '수료', 60000);

-- 강사 테이블
DROP TABLE IF EXISTS instructors CASCADE;

CREATE TABLE instructors
(
    instructor_id      SERIAL      PRIMARY KEY,
    name               VARCHAR(20) NOT NULL,
    sports_id          INT         NOT NULL REFERENCES sports(sports_id),
    phone              VARCHAR(20),
    hire_date          DATE        NOT NULL
);

INSERT INTO instructors (name, sports_id, phone, hire_date)
VALUES 
('고다형', 1, '010-3928-9329', '2026-01-01'),
('고질라', 2, '010-3938-9329', '2026-01-10');


-- 테이블 수정 ALTER TABLE

ALTER TABLE courses
ADD COLUMN instructor_id INT REFERENCES instructors (instructor_id);

SELECT
course_name AS 강좌명,
fee AS 수강료,
fee * 3 AS "3개월 수강료"
FROM courses
LIMIT 5;

SELECT DISTINCT region FROM members;  ### 멤버들 사는지역 중복제거후 정리

SELECT DISTINCT sport_id, level FROM courses;   ### 아이디및 코스정리

SELECT * FROM members WHERE member_id <= 7;   ### 아이디가 7번까지인 놈들

SELECT * FROM members WHERE region = '마포구';  ### 마포구있는놈들만

SELECT * FROM members WHERE email IS NULL;      ### 이메일 없는놈들만
SELECT COUNT(*) FROM members WHERE email IS NULL;  ### 이메일 없는놈들만 몇명인지
SELECT COUNT(*) AS "E-MAIL 미기재" FROM members WHERE email IS NULL;  ### 이메일 없는놈들만 몇명인지

SELECT * FROM members WHERE birth_year BETWEEN 1995 AND 2000;  ### 생년월일이 1995~ 2000인 놈들

SELECT * FROM courses WHERE course_id IN (1, 5, 10);  ### 1, 5, 10 코스는 어떤것인가

SELECT * FROM members WHERE name LIKE '김%';    ### 김씨만 모으기