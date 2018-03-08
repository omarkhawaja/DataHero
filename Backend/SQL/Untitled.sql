select x.id,
case when (y.skill_lvl is null or y.skill_lvl = 0) then 0 else 1 end as skill_lvl
from
(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s where x.course_provider_id = 3)x
left outer join
(select course_id,skill_id,skill_lvl from Course_skills order by course_id,skill_id asc)y
on x.id = y.course_id and x.skill = y.skill_id
order by x.id,x.skill asc;	

select x.id,
case when y.skill_id is null then 0 else 1 end as skill_code 
from
(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s where x.course_provider_id = 3)x
left outer join
(select course_id,skill_id from Course_skills order by course_id,skill_id asc)y
on x.id = y.course_id and x.skill = y.skill_id
order by x.id,x.skill asc limit 100000;

#Testing data for multiple tech skills per user##################################################
Insert into Technical_combinations (name, description) values ('test combo 1','python and sql');
Insert into Technical_combinations (name, description) values ('test combo 2','hive and hdfs');
Insert into Technical_combinations (name, description) values ('test combo 3','scala and hadoop');
Insert into Technical_combinations (name, description) values ('test combo 4','python, sql, and R');

Insert into Combination_skills (combination_id, skill_id) values (1,7);
Insert into Combination_skills (combination_id, skill_id) values (1,2);
Insert into Combination_skills (combination_id, skill_id) values (2,15);
Insert into Combination_skills (combination_id, skill_id) values (2,19);
Insert into Combination_skills (combination_id, skill_id) values (3,7);
Insert into Combination_skills (combination_id, skill_id) values (3,13);
Insert into Combination_skills (combination_id, skill_id) values (4,1);
Insert into Combination_skills (combination_id, skill_id) values (4,2);
Insert into Combination_skills (combination_id, skill_id) values (4,7);

Insert into Position_combinations (position_id, combination_id) values (2,3);
Insert into Position_combinations (position_id, combination_id) values (2,4);
Insert into Position_combinations (position_id, combination_id) values (1,1);
Insert into Position_combinations (position_id, combination_id) values (1,2);
######################################################################################



select * from Plans;

select y.name from Plan_courses x inner join Courses y on x.course_id = y.id where plan_id = 4;

select x.id, x.number_courses, z.`name` from Plans x inner join Plan_courses y on x.id = y.plan_id and x.user_id = 3 inner join Courses z on y.course_id = z.id;

drop table Course_skills;
drop table Combination_skills;
drop table Position_skills;
drop table Plan_skills;
drop table Skills;
drop table Plan_courses;
drop table Plans;
drop table Position_combinations;
drop table Technical_combinations;

select * from Skills;
call test();

select price from Courses where course_provider_id = 3;
select ExtractNumber('FreeAddaVerifiedCertificatefor$99 USD') AS Number from dual;

call clean_prices();

DELIMITER $$
DROP FUNCTION IF EXISTS ExtractNumber$$
CREATE FUNCTION `ExtractNumber`(in_string VARCHAR(50)) 
RETURNS INT
NO SQL
BEGIN
    DECLARE ctrNumber VARCHAR(50);
    DECLARE finNumber VARCHAR(50) DEFAULT '';
    DECLARE sChar VARCHAR(1);
    DECLARE inti INTEGER DEFAULT 1;

    IF LENGTH(in_string) > 0 THEN
        WHILE(inti <= LENGTH(in_string)) DO
            SET sChar = SUBSTRING(in_string, inti, 1);
            SET ctrNumber = FIND_IN_SET(sChar, '0,1,2,3,4,5,6,7,8,9'); 
            IF ctrNumber > 0 THEN
                SET finNumber = CONCAT(finNumber, sChar);
            END IF;
            SET inti = inti + 1;
        END WHILE;
        IF LENGTH(finNumber) > 0 THEN
			RETURN CAST(finNumber AS UNSIGNED);
        ELSE
			RETURN 0;
        END IF;
    ELSE
        RETURN 0;
    END IF;    
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS clean_prices$$
CREATE PROCEDURE clean_prices()
BEGIN

    DECLARE price_num VARCHAR(20);
    DECLARE course_id INT;
	DECLARE exit_loop INTEGER DEFAULT 0;
    DECLARE price_txt VARCHAR(100);
    
	DECLARE price_cursor CURSOR FOR
	SELECT id,price FROM fydp.Courses where course_provider_id in (2,3,4);
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = 1;
	
	OPEN price_cursor;
    
	get_prices: LOOP
    
		FETCH  price_cursor INTO course_id,price_txt;
    
		IF exit_loop = 1 THEN
		LEAVE get_prices;
		END IF;
        
		select ExtractNumber(price_txt) from dual into price_num;
		Update Courses Set price = price_num  where id = course_id;
        COMMIT;

	END LOOP get_prices;
    CLOSE price_cursor;

END$$
DELIMITER ;

