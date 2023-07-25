-- Drop the existing tables (if they exist)
DROP TABLE IF EXISTS Student_Course;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Professor;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Department;

-- Create Department table
CREATE TABLE Department (
  department_code INT PRIMARY KEY,
  department_name VARCHAR(50)
);

-- Create Student table
CREATE TABLE Student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  height DECIMAL(5,2),
  department_code INT
);

-- Create Professor table
CREATE TABLE Professor (
  professor_code INT PRIMARY KEY AUTO_INCREMENT,
  professor_name VARCHAR(50),
  department_code INT
);

-- Create Course table
CREATE TABLE Course (
  course_code INT PRIMARY KEY AUTO_INCREMENT,
  course_name VARCHAR(50),
  professor_code INT,
  start_date DATE,
  end_date DATE
);

-- Create Student_Course table
CREATE TABLE Student_Course (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  course_code INT
);
-- Add foreign key constraints using ALTER TABLE
ALTER TABLE Student
ADD CONSTRAINT FK_Student_Department
FOREIGN KEY (department_code) REFERENCES Department(department_code);

ALTER TABLE Professor
ADD CONSTRAINT FK_Professor_Department
FOREIGN KEY (department_code) REFERENCES Department(department_code);

ALTER TABLE Course
ADD CONSTRAINT FK_Course_Professor
FOREIGN KEY (professor_code) REFERENCES Professor(professor_code);

ALTER TABLE Student_Course
ADD CONSTRAINT FK_Student_Course_Student
FOREIGN KEY (student_id) REFERENCES Student(student_id);

ALTER TABLE Student_Course
ADD CONSTRAINT FK_Student_Course_Course
FOREIGN KEY (course_code) REFERENCES Course(course_code);

-- 학과
-- Insert data into Department table
INSERT INTO Department (department_code, department_name) VALUES
(1, '수학과'),
(2, '국어문학과'),
(3, '정보통신학과'),
(4, '모바일공학과');



-- 학생
-- Insert data into Student table
INSERT INTO Student (name, height, department_code) VALUES
('가길동', 170.5, 1),
('나길동', 165.2, 1),
('다길동', 180.0, 2),
('라길동', 175.8, 3),
('마길동', 160.7, 4),
('바길동', 168.3, 1),
('사길동', 172.1, 2),
('아길동', 175.0, 1);

-- 교수
-- Insert data into Professor table
INSERT INTO Professor (professor_name, department_code) VALUES
('가 교수', 1),
('나 교수', 1),
('다 교수', 2),
('빌 게이츠', 3),
('스티브 잡스', 4);

-- 개설과목
-- Insert data into Course table
INSERT INTO Course (course_name, professor_code, start_date, end_date) VALUES
('교양 영어', 1, '2023-07-01', '2023-08-15'),
('데이터베이스 입문', 2, '2023-07-01', '2023-08-31'),
('회로이론', 3, '2023-07-15', '2023-09-15'),
('공학수학', 4, '2023-07-15', '2023-09-30'),
('객체지향 프로그래밍', 5, '2023-07-01', '2023-08-31');

-- 수강
-- Insert data into Student_Course table
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema work
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
-- -----------------------------------------------------
-- Schema reals
-- -----------------------------------------------------
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`student` ;

CREATE TABLE IF NOT EXISTS `mydb`.`student` (
  `student_id` INT NOT NULL,
  `student_name` VARCHAR(10) NOT NULL,
  `seat` INT NOT NULL,
  PRIMARY KEY (`student_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`subject`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`subject` ;

CREATE TABLE IF NOT EXISTS `mydb`.`subject` (
  `subject_id` INT NOT NULL AUTO_INCREMENT,
  `subject_name` VARCHAR(45) NOT NULL,
  `teacher` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`subject_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`course` ;

CREATE TABLE IF NOT EXISTS `mydb`.`course` (
  `num` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `score` INT NOT NULL,
  `subject_id` INT NOT NULL,
  PRIMARY KEY (`num`),
  INDEX `cc_idx` (`student_id` ASC) VISIBLE,
  INDEX `ss_idx` (`subject_id` ASC) VISIBLE,
  CONSTRAINT `cc`
    FOREIGN KEY (`student_id`)
    REFERENCES `mydb`.`student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ss`
    FOREIGN KEY (`subject_id`)
    REFERENCES `mydb`.`subject` (`subject_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Insert data into Student_Course table
INSERT INTO Student_Course (student_id, course_code) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 5);



select * from Professor
where professor_name like "%교수%";

-- 정보통산공학과의 학생정보(학생번호, 이름, 학과명) 출력하기
select student_id, name, department_name from  Student s
inner join Department d
on s.department_code =d.department_code
where department_name = "정보통신학과";
-- 조인 없이 출력
select student_id, name, department_name from student s, department d
where s.department_code = d.department_code and department_name = "정보통신학과";

select student_id, name, department_name from student s, department d
where s.department_code=d.department_code and d.department_name =(select department_name from department where department_name = "정보통신학과");

-- 정보통신학과의 교수 이름을 출력하세요
select * from Professor
inner join department
on Professor. department_code = Department. department_code
where  Department.department_name = "정보통신학과";


-- 학과 별 교수의 수
select department_code, count(professor_name) "교수 수" from Professor
group by department_code;
-- 학과별 교수 수 학과명 사용하기
select department_name 학과명 , count(professor_name) "교수 수" from Professor
join department
on professor.department_code = department.department_code
group by department_name
-- 오름 차순 정렬(order by count(professor_name) asc;)
having count(professor_name)>=2;

-- 아씨 성을 쓰는 사람
select d. department_name, s.name from student s, department d
where s.department_code = d.department_code
and s.name like '아%';

-- 키가 175~190 사이 사람들의 
select count(student_id) from student
where height >=175 and height <=190;

-- 다길동 학생과 같은 학과에 속한 학생의 이름을 출력
select * from student
where department_code=(select department_code from student where name = "다길동"); 

-- 빌게이츠가 가르키는 과목
select p.professor_name,c.course_name from Professor p
join course c
on p.professor_code =c.professor_code
where p.professor_name = "빌 게이츠";

-- 스티브 잡스가 가르키는 과목을 수강신청 한 사람들의 수(서브퀴리 2개)
select count(student_id) from student_course
where course_code =
(select count(student_id) from Course
where professor_code=(select professor_code from Professor where professor_name = "스티브 잡스"));

-- 개설과목이름별 수강자 수를 출력하세요
select count( from course;
select * from haksa.student_course;
