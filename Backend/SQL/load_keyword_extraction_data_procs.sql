use fydp;
/*
Input: skill_name and skill_type
Output: skill_id
Checks if the skill exists in the Skill_extraction table if it does it returns the id
if not it will add it and then return the id
*/
DELIMITER $$
DROP FUNCTION IF EXISTS check_skill_exists$$
CREATE FUNCTION check_skill_exists(skill_name VARCHAR(100), skill_type VARCHAR(100), position_id INT) RETURNS INTEGER
BEGIN
	DECLARE skill_found INTEGER;
	DECLARE skill_id INTEGER;

	SELECT EXISTS(SELECT * FROM Skill_extraction WHERE skill = lower(skill_name) and position = position_id) into skill_found;
    IF skill_found = 1 THEN
		SELECT id FROM Skill_extraction WHERE skill = skill_name and position = position_id into skill_id;
    ELSE
		INSERT INTO Skill_extraction (skill,`type`,`position`) VALUES (skill_name,skill_type,position_id);
		SELECT LAST_INSERT_ID() into skill_id;
    END IF;

	RETURN skill_id;
END$$
DELIMITER ;

/*
Input: keyword
Output: keywor_id
Checks if the keyword exists in the Keywords table if it does it returns the id
if not it will add it and then return the id
*/
DELIMITER $$
DROP FUNCTION IF EXISTS check_keyword_exists$$
CREATE FUNCTION check_keyword_exists(keyword_ VARCHAR(100)) RETURNS INTEGER
BEGIN
	DECLARE keyword_found INTEGER;
	DECLARE keyword_id INTEGER;

	SELECT EXISTS(SELECT * FROM Keywords WHERE keyword = lower(keyword_)) into keyword_found;
    IF keyword_found = 1 THEN
		SELECT id FROM Keywords WHERE keyword = keyword_ into keyword_id;
    ELSE
		INSERT INTO Keywords (keyword) VALUES (keyword_);
		SELECT LAST_INSERT_ID() into keyword_id;
    END IF;

	RETURN keyword_id;
END$$
DELIMITER ;

/*
This procedure loops through the Skill_keyword_loading table and adds all the
skills and their coresponding keywords to the Skill_extraction,Keywords, and
Skill_keywords table. The data in these three tables is used by the Keyword extraction
procedure
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS keyword_extraction_data_loading$$
CREATE PROCEDURE keyword_extraction_data_loading()
BEGIN
	DECLARE skill_id_num INTEGER;
    DECLARE keyword_id_num INTEGER;
    DECLARE position_ INTEGER;
    DECLARE skill_ VARCHAR(100);
    DECLARE keyword_ VARCHAR(100);
    DECLARE type_ VARCHAR(100);
	DECLARE exit_loop INTEGER DEFAULT 0; 
    DECLARE rec_found INTEGER;
    
	DECLARE skill_keyword_cursor CURSOR FOR
	SELECT skill,keyword,type,position FROM fydp.Skill_keyword_loading;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN skill_keyword_cursor;
    
	get_skill_keywords: LOOP
    
		FETCH  skill_keyword_cursor INTO skill_,keyword_,type_,position_;
    
		IF exit_loop = 1 THEN
			LEAVE get_skill_keywords;
		END IF;
        
        select check_skill_exists(skill_,type_,position_) from dual into skill_id_num;
        select check_keyword_exists(keyword_) from dual into keyword_id_num;
        
		SELECT EXISTS(SELECT * FROM Skill_keywords WHERE keyword_id = keyword_id_num and skill_id = skill_id_num) into rec_found;
		IF rec_found = 0 THEN
			insert into Skill_keywords (skill_id,keyword_id) values (skill_id_num,keyword_id_num);
		END IF;

	END LOOP get_skill_keywords;
    CLOSE skill_keyword_cursor;
   
END$$
DELIMITER ;

#how to run the skill and keyword data loading procedure
call keyword_extraction_data_loading();