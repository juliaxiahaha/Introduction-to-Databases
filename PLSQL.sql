--Author: Jingwen Xia
--Assignment# 3 / Part 2
--Date due: 04/06/2025
--I pledge that I have completed this assignment without collaborating
--with anyone else, in conformance with the NYU School of Engineering
--Policies and Procedures on Academic Misconduct.

--Q1
DELIMITER //
DROP PROCEDURE IF EXISTS track_student//

CREATE PROCEDURE track_student (IN student_first VARCHAR(50))
BEGIN
    SELECT CONCAT(s.s_first, ' ', s.s_last) AS full_name,
           e.c_sec_id
    FROM student s, enrollment e
    WHERE s.s_id = e.s_id
      AND s.s_first = student_first;
END //

DELIMITER ;

--Q2
DELIMITER //
DROP PROCEDURE IF EXISTS track_faculty//

CREATE PROCEDURE track_faculty (IN fac_first VARCHAR(50), IN fac_last VARCHAR(50))
BEGIN
    SELECT CONCAT(f.f_first, ' ', f.f_last) AS faculty_name,
           COUNT(DISTINCT e.s_id) AS total_students
    FROM   enrollment e,       
           course_section cs,     
           faculty f  
    WHERE  e.c_sec_id = cs.c_sec_id 
      AND  cs.f_id = f.f_id
      AND  f.f_first  = fac_first
      AND  f.f_last   = fac_last;
END //

DELIMITER ;

--Q3
DELIMITER //
DROP FUNCTION IF EXISTS count_enroll//

CREATE FUNCTION count_enroll(sid INT, termid INT)
RETURNS INT
BEGIN
    DECLARE enroll_num INT;
    
    SELECT COUNT(*) INTO enroll_num
    FROM enrollment e, 
	 course_section cs
    WHERE e.c_sec_id = cs.c_sec_id
      AND e.s_id     = sid
      AND cs.term_id = termid;
      
    RETURN enroll_num;
END //

DELIMITER ;

--Q4
DELIMITER //
DROP FUNCTION IF EXISTS course_most_sections//

CREATE FUNCTION course_most_sections()
RETURNS VARCHAR(100)
BEGIN
    DECLARE courseName VARCHAR(100);
    SELECT c.course_name INTO courseName
    FROM   course c,
           course_section cs
    WHERE  c.course_id = cs.course_id
    GROUP BY c.course_id, c.course_name
    HAVING COUNT(cs.c_sec_id) = 
           ( SELECT MAX(cnt)
             FROM ( SELECT COUNT(*) AS cnt
                    FROM   course_section
                    GROUP  BY course_id
                  ) cnts );
    
    RETURN courseName;
END //

DELIMITER ;

--Q5
c)
DELIMITER //

CREATE TRIGGER student_watch_dog
AFTER INSERT ON student
FOR EACH ROW
BEGIN
    UPDATE admitted_students
    SET st_num = (SELECT COUNT(s_id) FROM student);
END //

DELIMITER ;

d)
INSERT INTO student 
    (s_id, s_last, s_first, s_mi, s_add, s_city, s_state, s_zip, s_phone, s_class, s_dob, s_pin, f_id)
VALUES 
(106, 'Cruz', 'Ana', 'S', '100 Northern Blvd.', 'Eau Claire', 'WI', '54703', '7154449870', 'SR', '1982-08-13', 8891, 1),
(107, 'Katz', 'Daniel', 'B', '400 St. John''s Street', 'Eau Claire', 'WI', '54702', '7155552000', 'SR', '1982-04-10', 1230, 1);

e)
--st_num was 6. In step d, two students are added, so the number of st_num becomes 8.

Q6
--full_name	c_sec_id
--Sarah Miller	1000
--Sarah Miller	1003
--Sarah Miller	1005
--Sarah Miller	1008
--Sarah have chosen 4 courses totally

Q7
CALL track_faculty('Kim', 'Cox');
--faculty_name	total_students
--Kim Cox	5
--Kim Cox have taught 5 students before

Q8
--@count_e
--3
--In term 5, student 101 enrolled 3 classes

Q9
SELECT course_most_sections();
--course_most_sections()
--Intro. to Info. Systems
--This class has highest number of course sections.