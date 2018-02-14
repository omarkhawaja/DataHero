select x.id,x.skill,
case when y.skill_id is null then 0 else 1 end as skill_code 
from
(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s)x
left outer join
(select course_id,skill_id from Course_skills order by course_id,skill_id asc)y
on x.id = y.course_id and x.skill = y.skill_id
order by x.id,x.skill asc
limit 100000;

select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s limit 1000000;
select course_id,skill_id from Course_skills order by course_id,skill_id asc limit 1000000;

select course_id,skill_id from Course_skills order by course_id,skill_id asc limit 1000000;
select distinct course_id,skill_id from Course_skills order by course_id,skill_id asc limit 1000000;

select course_id, count(course_id), skill_id, count(skill_id) from Course_skills
group by course_id, skill_id
having
(count(course_id) > 1) and (count(skill_id) > 1);

call delete_dups();

DELIMITER $$
DROP PROCEDURE IF EXISTS delete_dups$$
CREATE PROCEDURE delete_dups()
BEGIN
	DECLARE course INTEGER;
    DECLARE skill INTEGER;
	DECLARE exit_loop INTEGER DEFAULT 0; 
    
	DECLARE dups_cursor CURSOR FOR
	select course_id, skill_id  
    from Course_skills
	group by course_id, skill_id
	having
	(count(course_id) > 1) and (count(skill_id) > 1);
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN dups_cursor;
    
	get_dups: LOOP
    
		FETCH  dups_cursor INTO course, skill;
    
		IF exit_loop = 1 THEN
		LEAVE get_dups;
		END IF;
        
        delete from Course_skills where course_id = course and skill_id = skill limit 1;

	END LOOP get_dups;
    CLOSE dups_cursor;
   
END$$
DELIMITER ;