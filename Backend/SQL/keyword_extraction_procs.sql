use fydp;
#This file includes all functions and procs used for the keyword extraction procedure
#At the end are the lines to call when running the keyword extraction process

#FUNCTIONS
/*
Keyword lookup for the potential skill
Input: keyword: word to be searched for
          text_to_search: text to search in
Output: Y if keyword is found in text, N if keyword is not found in text to search
The function looks for an exact match not just the keyword character composition
*/
DELIMITER $$
DROP FUNCTION IF EXISTS keyword_search_regex_skill$$
CREATE FUNCTION keyword_search_regex_skill(keyword_ VARCHAR(100), txt_to_search TEXT) RETURNS VARCHAR(1)
BEGIN
  DECLARE keyword_found VARCHAR(1);
  
	select CASE count(*) WHEN 0 THEN 'N' ELSE 'Y' END into keyword_found
	from fydp.Skill_extraction k
	where k.skill = keyword_
	and   lower(txt_to_search) regexp lower(concat('[[:<:]]',k.skill,'[[:>:]]'));
    
  RETURN keyword_found;
END$$
DELIMITER ;

/*
Keyword lookup for the skill keywords 
Input: keyword: word to be searched for
          text_to_search: text to search in
Output: Y if keyword is found in text, N if keyword is not found in text to search
The function looks for an exact match not just the keyword character composition
*/
DELIMITER $$
DROP FUNCTION IF EXISTS keyword_search_regex_keyword$$
CREATE FUNCTION keyword_search_regex_keyword(keyword_ VARCHAR(100), txt_to_search TEXT) RETURNS VARCHAR(1)
BEGIN
  DECLARE keyword_found VARCHAR(1);
  
	select CASE count(*) WHEN 0 THEN 'N' ELSE 'Y' END into keyword_found
	from fydp.Keywords k
	where k.keyword = keyword_
	and   lower(txt_to_search) regexp lower(concat('[[:<:]]',k.keyword,'[[:>:]]'));
    
  RETURN keyword_found;
END$$
DELIMITER ;

/*
Input: skill_name: skill to check if exists in Skills table
          skill_type: technical or fundamental
Output: skill_id
The function will check if a skill exists in the Skills table if it does it will retunr its id if not
it will insert it and then return its id
*/
DELIMITER $$
DROP FUNCTION IF EXISTS check_skill_keyword_extraction$$
CREATE FUNCTION check_skill_keyword_extraction(skill_name VARCHAR(100), skill_type VARCHAR(100),position_id INTEGER) RETURNS INTEGER
BEGIN
	DECLARE skill_found INTEGER;
	DECLARE skill_id INTEGER;

	SELECT EXISTS(SELECT * FROM Skills WHERE skill = lower(skill_name) and position = position_id) into skill_found;
    IF skill_found = 1 THEN
		SELECT id FROM Skills WHERE skill = skill_name and position = position_id into skill_id;
    ELSE
		INSERT INTO Skills (skill,`type`,`position`) VALUES (skill_name,skill_type,position_id);
		SELECT LAST_INSERT_ID() into skill_id;
    END IF;

	RETURN skill_id;
END$$
DELIMITER ;

#PROCEDURES
/*
This procedure loops through the course's in the Courses table and then passes each course
with its details to the skill extraction loop
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS keyword_extraction$$
CREATE PROCEDURE keyword_extraction()
BEGIN
	DECLARE id_num INTEGER;
    DECLARE descrip TEXT;
    DECLARE title TEXT;
    DECLARE description_ TEXT;
    DECLARE course_lvl INTEGER;
	DECLARE exit_loop INTEGER DEFAULT 0; 
    
	DECLARE courses_cursor CURSOR FOR
	SELECT id,`name`,description,`level` FROM fydp.Courses;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN courses_cursor;
    
	get_courses: LOOP
    
		FETCH  courses_cursor INTO id_num,title,descrip,course_lvl;
    
		IF exit_loop = 1 THEN
			LEAVE get_courses;
		END IF;
        
        #to search for skills and keywords in course name and description
        select concat(title, ' ', descrip) from dual into description_;
        call keyword_extraction_skill_loop(description_,id_num,course_lvl);

	END LOOP get_courses;
    CLOSE courses_cursor;
   
END$$
DELIMITER ;

/*
This procedure is the keyword extraction skill loop and loops over all the potential skills in the 
Skill_extraction able and searches for the terms in the course passed down from the outer loop proc
If a Skill is found in the course it will be added to the Course_skills table and then the course information
is passed to the keyword loop for the quality score to be calculated
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS keyword_extraction_skill_loop$$
CREATE PROCEDURE keyword_extraction_skill_loop(IN description TEXT, IN id_num INTEGER, IN course_lvl INTEGER)
BEGIN

    DECLARE key_found VARCHAR(1);
	DECLARE exit_loop INTEGER DEFAULT 0;
    DECLARE keyword_txt VARCHAR(100);
    DECLARE keyword_type VARCHAR(100);
    DECLARE skill_id_num INTEGER;
    DECLARE position_ INTEGER;
    DECLARE skill_extraction_id_num INTEGER;
    
	DECLARE keyword_cursor CURSOR FOR
	SELECT id,skill,`type`,`position` FROM fydp.Skill_extraction;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN keyword_cursor;
    
	get_keywords: LOOP
    
		FETCH  keyword_cursor INTO skill_extraction_id_num,keyword_txt,keyword_type,position_;
    
		IF exit_loop = 1 THEN
			LEAVE get_keywords;
		END IF;
        
		select keyword_search_regex_skill(keyword_txt,description) from dual into key_found;
		IF key_found = 'Y' THEN
			select check_skill_keyword_extraction(keyword_txt,keyword_type,position_) from dual into skill_id_num;
			INSERT INTO Course_skills(course_id,skill_id,skill_lvl) VALUES (id_num,skill_id_num,course_lvl);
			COMMIT;
			call keyword_extraction_keyword_loop(id_num,skill_extraction_id_num,description,skill_id_num,position_);
		END IF;

	END LOOP get_keywords;
    CLOSE keyword_cursor;

END$$
DELIMITER ;

/*
This procedure is the keyword extraction keyword loop, it calculates the quality score for a 
course teaching a particular skill by counting how many of the kewyords associated with that 
skill are found in the course description
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS keyword_extraction_keyword_loop$$
CREATE PROCEDURE keyword_extraction_keyword_loop(IN course_id_num INT, IN skill_id_num INT, IN description TEXT, IN skill_id_table INT)
BEGIN

    DECLARE key_found VARCHAR(1);
	DECLARE exit_loop INTEGER DEFAULT 0;
    DECLARE keyword_txt VARCHAR(100);
    DECLARE occurences INT DEFAULT 0;
    DECLARE score DECIMAL(12,4);
    DECLARE total_keywords INT;
 
	DECLARE keyword_cursor CURSOR FOR
	SELECT y.keyword from Skill_keywords x inner join Keywords y on x.keyword_id = y.id and x.skill_id = skill_id_num;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
    SET total_keywords = (SELECT count(*) from Skill_keywords x inner join Keywords y on x.keyword_id = y.id and x.skill_id = skill_id_num);
    
	OPEN keyword_cursor;
    
	get_keywords: LOOP
    
		FETCH  keyword_cursor INTO keyword_txt;
    
		IF exit_loop = 1 THEN
			LEAVE get_keywords;
		END IF;
        
		select keyword_search_regex_keyword(keyword_txt,description) from dual into key_found;
		IF key_found = 'Y' THEN
			SET occurences := occurences + 1;
		END IF;

	END LOOP get_keywords;
    CLOSE keyword_cursor;
	Set score := CAST(occurences AS DEC(12,4))/CAST(total_keywords AS DEC(12,4)); 
	UPDATE Course_skills set course_score = score where skill_id = skill_id_table and course_id = course_id_num;
	COMMIT;

END$$
DELIMITER ;

/*
This procedure deletes all duplicates that are created by the keyword extraction procedure
*/
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

#how to run the keyword extraction procedure
call fydp.keyword_extraction();
call fydp.delete_dups();