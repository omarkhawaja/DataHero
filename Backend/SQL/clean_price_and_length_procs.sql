#based on https://stackoverflow.com/questions/37268248/how-to-get-only-digits-from-string-in-mysql
#works only for ints and not floats, if price is like this; 12.34 it will return 1234, becareful!!!
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
	SELECT id,price FROM fydp.Courses;
    
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