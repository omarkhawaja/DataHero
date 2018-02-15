DELIMITER $$
DROP FUNCTION IF EXISTS keyword_search$$
CREATE FUNCTION keyword_search(keyword VARCHAR(100), txt_to_search TEXT) RETURNS VARCHAR(1)
BEGIN
  DECLARE keyword_found VARCHAR(1);
  
	select CASE count(*) WHEN 0 THEN 'N' ELSE 'Y' END into keyword_found
	from fydp.Keywords k
	where k.skill = keyword
	and   instr(lower(txt_to_search),lower(k.skill)) > 0; 
    
  RETURN keyword_found;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS check_skill$$
CREATE FUNCTION check_skill(skill_name VARCHAR(100), skill_type VARCHAR(100)) RETURNS INTEGER
BEGIN
	DECLARE skill_found INTEGER;
	DECLARE skill_id INTEGER;

	SELECT EXISTS(SELECT * FROM Skills WHERE skill = lower(skill_name)) into skill_found;
    IF skill_found = 1 THEN
		SELECT id FROM Skills WHERE skill = skill_name into skill_id;
    ELSE
		INSERT INTO Skills (skill,`type`) VALUES (skill_name,skill_type);
		SELECT LAST_INSERT_ID() into skill_id;
    END IF;

	RETURN skill_id;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS keyword_extraction$$
CREATE PROCEDURE keyword_extraction()
BEGIN
	DECLARE id_num INTEGER;
    DECLARE descrip TEXT;
    DECLARE course_lvl INTEGER;
	DECLARE exit_loop INTEGER DEFAULT 0; 
    
	DECLARE courses_cursor CURSOR FOR
	SELECT id,description,`level` FROM fydp.Courses;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN courses_cursor;
    
	get_courses: LOOP
    
		FETCH  courses_cursor INTO id_num, descrip,course_lvl;
    
		IF exit_loop = 1 THEN
		LEAVE get_courses;
		END IF;
        
        call keyword_extraction_inner_loop(descrip,id_num,course_lvl);

	END LOOP get_courses;
    CLOSE courses_cursor;
   
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS keyword_extraction_inner_loop$$
CREATE PROCEDURE keyword_extraction_inner_loop(IN description TEXT, IN id_num INTEGER, IN course_lvl INTEGER)
BEGIN

    DECLARE key_found VARCHAR(1);
	DECLARE exit_loop INTEGER DEFAULT 0;
    DECLARE keyword_txt VARCHAR(100);
    DECLARE keyword_type VARCHAR(100);
    DECLARE skill_id_num INTEGER;
    
	DECLARE keyword_cursor CURSOR FOR
	SELECT skill,`type` FROM fydp.Keywords;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN keyword_cursor;
    
	get_keywords: LOOP
    
		FETCH  keyword_cursor INTO keyword_txt,keyword_type;
    
		IF exit_loop = 1 THEN
		LEAVE get_keywords;
		END IF;
        
		select keyword_search(keyword_txt,description) from dual into key_found;
		IF key_found = 'Y' THEN
        select check_skill(keyword_txt,keyword_type) from dual into skill_id_num;
		INSERT INTO Course_skills(course_id,skill_id,skill_lvl) VALUES (id_num,skill_id_num,course_lvl);
        COMMIT;
		END IF;

	END LOOP get_keywords;
    CLOSE keyword_cursor;
   
END$$
DELIMITER ;

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

call fydp.keyword_extraction();
call fydp.delete_dups();