DELIMITER $$
DROP PROCEDURE IF EXISTS position_skill_data_loading_old$$
CREATE PROCEDURE position_skill_data_loading_old()

BEGIN
    DECLARE skill_id_num INTEGER;
    DECLARE position_ INTEGER;
    DECLARE skill_ VARCHAR(100);
	DECLARE exit_loop INTEGER DEFAULT 0; 
    
	DECLARE position_skill_cursor CURSOR FOR
	SELECT skill,position_id FROM fydp.Position_skill_loading;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN position_skill_cursor;
    
	get_position_skills: LOOP
    
		FETCH  position_skill_cursor INTO skill_,position_;
        
		IF exit_loop = 1 THEN
			LEAVE get_position_skills;
		END IF;
        
        #select id from Positions where position = position_ into position_id_num;
        select id from Skills where lower(skill) = lower(skill_) and `position` = position_ into skill_id_num;
        insert into Position_skills (position_id,skill_id,skill_lvl) values (position_,skill_id_num,1);
        
	END LOOP get_position_skills;
    CLOSE position_skill_cursor;
   
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS position_skill_data_loading$$
CREATE PROCEDURE position_skill_data_loading()

BEGIN
    DECLARE skill_id_num INTEGER;
    DECLARE position_ INTEGER;
    DECLARE skill_ VARCHAR(100);
	DECLARE exit_loop INTEGER DEFAULT 0; 
    
	DECLARE position_skill_cursor CURSOR FOR
	SELECT id,position FROM fydp.Skills where type = 'fundamental';
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN position_skill_cursor;
    
	get_position_skills: LOOP
    
		FETCH  position_skill_cursor INTO skill_,position_;
        
		IF exit_loop = 1 THEN
			LEAVE get_position_skills;
		END IF;
        
        insert into Position_skills (position_id,skill_id,skill_lvl) values (position_,skill_,1);
        
	END LOOP get_position_skills;
    CLOSE position_skill_cursor;
   
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS combination_skill_data_loading$$
CREATE PROCEDURE combination_skill_data_loading()

BEGIN
    DECLARE skill_id_num INTEGER;
    DECLARE stack_ INTEGER;
    DECLARE position_ INTEGER;
    DECLARE skill_ VARCHAR(100);
	DECLARE exit_loop INTEGER DEFAULT 0; 
    
	DECLARE position_skill_cursor CURSOR FOR
	SELECT stack,skill,position FROM fydp.Position_stack_skill_loading;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN position_skill_cursor;
    
	get_position_skills: LOOP
    
		FETCH  position_skill_cursor INTO stack_,skill_,position_;
        
		IF exit_loop = 1 THEN
			LEAVE get_position_skills;
		END IF;
        
        select id from Skills where lower(skill) = lower(skill_) and position = position_ into skill_id_num;
        IF skill_ = 'tableau' or skill_ = 'bash' THEN
			# ;)
			insert into Combination_skills (combination_id,skill_id,skill_lvl) values (stack_,skill_id_num,0);
		ELSE
			insert into Combination_skills (combination_id,skill_id,skill_lvl) values (stack_,skill_id_num,1);
        END IF;
        
	END LOOP get_position_skills;
    CLOSE position_skill_cursor;
   
END$$
DELIMITER ;