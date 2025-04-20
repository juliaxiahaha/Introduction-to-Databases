--Author: Jingwen Xia
--Assignment# 3 / Part 1
--Date due: 04/06/2025
--I pledge that I have completed this assignment without collaborating
--with anyone else, in conformance with the NYU School of Engineering
--Policies and Procedures on Academic Misconduct.

--Q1
SELECT DISTINCT l.bldg_code , l.room
FROM   location l,            
       faculty f            
WHERE  f.loc_id = l.loc_id

UNION    

SELECT DISTINCT l.bldg_code, l.room
FROM   location l,
       course_section cs,
       term t
WHERE  cs.loc_id  = l.loc_id
  AND  cs.term_id = t.term_id
  AND  t.term_desc = 'Summer 2004';

--Q2
SELECT s.s_id, s.s_first, s.s_last
FROM   student s
WHERE NOT EXISTS (
           SELECT 1
           FROM   enrollment e,
                  course_section cs,
                  faculty f
           WHERE  e.s_id = s.s_id        
             AND  e.c_sec_id = cs.c_sec_id   
             AND  cs.f_id = f.f_id    
             AND  f.f_first = 'Kim'         
             AND  f.f_last = 'Cox'
       )
ORDER BY s.s_last, s.s_first;

--Q3
SELECT COUNT(DISTINCT e.s_id)   AS total_students
FROM   enrollment e,       
       course_section cs,     
       faculty f         
WHERE  e.c_sec_id = cs.c_sec_id    
  AND  cs.f_id = f.f_id          
  AND  f.f_first = 'John'         
  AND  f.f_last = 'Blanchard';

--Q4
SELECT COUNT(DISTINCT e.s_id)   AS total_students
FROM   enrollment e,      
       course_section cs,   
       faculty f,     
       term t        
WHERE  e.c_sec_id = cs.c_sec_id     
  AND  cs.f_id = f.f_id          
  AND  cs.term_id = t.term_id          
  AND  f.f_first = 'John'           
  AND  f.f_last = 'Blanchard'
  AND  t.term_desc = 'Summer 2004';  

--Q5
SELECT s.s_first, s.s_last, e.c_sec_id, e.grade
FROM   student s,
       enrollment e
WHERE  s.s_id = e.s_id               
  AND  e.c_sec_id = 1000                 
ORDER BY e.grade;                         

--Q6
SELECT f.f_first, f.f_last
FROM   faculty f ,               
       course_section cs,
       (SELECT c_sec_id
         FROM   enrollment
         GROUP  BY c_sec_id
         HAVING COUNT(*) > 5
       ) AS sec                                    
WHERE  cs.c_sec_id = sec.c_sec_id    
  AND  cs.f_id  = f.f_id; 

--Q7
SELECT c.course_name
FROM   course c, 
       course_section cs
WHERE  c.course_id = cs.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(cs.c_sec_id) =             
       ( SELECT MAX(cnt)                 
         FROM ( SELECT COUNT(*) AS cnt   
                FROM   course_section
                GROUP  BY course_id ) cnts );

--Q8
SELECT DISTINCT cs.c_sec_id
FROM   course_section cs,
       faculty f
WHERE  cs.f_id = f.f_id
  AND  f.f_last LIKE 'B%'

UNION

SELECT DISTINCT e.c_sec_id
FROM   enrollment e,
       student s
WHERE  e.s_id = s.s_id
  AND  s.s_last LIKE '%an%';

