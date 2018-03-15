/*
This script resets all tables in data model except for:
Courses
Course_providors
Course_instructors
Positions
Users
User_info
Scraper_logs
It also loads all keyword extraction related data and populates the position_skills table
*/
CREATE DATABASE IF NOT EXISTS fydp;
USE fydp;

DROP TABLE IF EXISTS Course_skills;
DROP TABLE IF EXISTS Plan_skills;
DROP TABLE IF EXISTS Position_skills;
DROP TABLE IF EXISTS Combination_skills;
DROP TABLE IF EXISTS Skills;
DROP TABLE IF EXISTS Plan_courses;
DROP TABLE IF EXISTS Position_combinations;
DROP TABLE IF EXISTS Plans;
DROP TABLE IF EXISTS Technical_combinations;
DROP TABLE IF EXISTS Skill_keywords;
DROP TABLE IF EXISTS Skill_extraction;
DROP TABLE IF EXISTS Keywords;
DROP TABLE IF EXISTS Skill_keyword_loading;
DROP TABLE IF EXISTS Position_skill_loading;
DROP TABLE IF EXISTS Position_stack_skill_loading;

CREATE TABLE IF NOT EXISTS Course_providors (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(500) NOT NULL, 
	`url` VARCHAR(500) NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Course_instructors (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL, 
	`rating` DECIMAL, 
	`num_reviews` INT, 
	`num_students` INT, 
	`num_courses` INT,
    `time_scraped` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (id) 
);

CREATE TABLE IF NOT EXISTS Courses (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(500) NOT NULL, 
	`description` TEXT NOT NULL, 
	`price` VARCHAR(100) NULL, 
	`rating` FLOAT(2,1), 
	`num_ratings` VARCHAR(100),
	`language` VARCHAR(100),
	`length` VARCHAR(100),
	`instructor_id` INT NOT NULL,
	`course_provider_id` INT NOT NULL,
	`url` VARCHAR(200),
    `time_scraped` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (instructor_id) REFERENCES 	Course_instructors(id),
	FOREIGN KEY (course_provider_id) REFERENCES Course_providors(id),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Skills (
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100) NOT NULL,
    `type` VARCHAR(100),
    `position` INTEGER,
    `comments` VARCHAR(200),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Course_skills (
    `course_id` INT NOT NULL,
    `skill_id` INT,
    `skill_lvl` INT,
    `course_score` DECIMAL(12,4),
    FOREIGN KEY (course_id) REFERENCES 	Courses(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Users (
	`id` INT NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(200) NOT NULL,
    `password` varchar(100) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS User_info (
	`id` INT NOT NULL,
	`first_name` VARCHAR(100), 
	`last_name` VARCHAR(100),
	`current_occupation` VARCHAR (200),
    `current_job_position` VARCHAR (200),
    `education` VARCHAR (200),
    `industry`	VARCHAR (200),
    FOREIGN KEY (id) REFERENCES Users(id)
    ON DELETE CASCADE,
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Positions (
	`id` INT NOT NULL AUTO_INCREMENT,
	`position` VARCHAR(100) NOT NULL, 
	`description` TEXT, 
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Position_skills (
	`position_id` INT NOT NULL,
	`skill_id` INT NOT NULL, 
	`skill_lvl` INT,
	FOREIGN KEY (position_id) REFERENCES Positions(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
   );
   
CREATE TABLE IF NOT EXISTS Technical_combinations (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL, 
	`description` TEXT, 
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Combination_skills (
	`combination_id` INT NOT NULL,
	`skill_id` INT NOT NULL, 
	`skill_lvl` INT,
	FOREIGN KEY (combination_id) REFERENCES Technical_combinations(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
   );
   
CREATE TABLE IF NOT EXISTS Position_combinations (
	`position_id` INT NOT NULL,
	`combination_id` INT NOT NULL, 
	FOREIGN KEY (position_id) REFERENCES Positions(id)
    ON DELETE CASCADE,
	FOREIGN KEY (combination_id) REFERENCES Technical_combinations(id)
    ON DELETE CASCADE
   );
   
CREATE TABLE IF NOT EXISTS Plans (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT,
    `position_id` INT,
    `cost` float ,
    `length`  float,
    `number_courses` INT,
    `technical_skills_id` INT,
    `time_stamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
    ON DELETE CASCADE,
    FOREIGN KEY (position_id) REFERENCES Positions(id)
    ON DELETE CASCADE,
    FOREIGN KEY (technical_skills_id) REFERENCES Technical_combinations(id)
    ON DELETE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Plan_skills (
    `plan_id` INT NOT NULL,
    `skill_id` INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES 	Plans(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Plan_courses (
    `plan_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES 	Plans(id)
    ON DELETE CASCADE,
	FOREIGN KEY (course_id) REFERENCES Courses(id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Scraper_logs (
    `id` INT NOT NULL AUTO_INCREMENT,
    `course_provider_id` INT NOT NULL,
    `error_message` VARCHAR(400),
    `url` VARCHAR(200),
    `time_stamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_provider_id) REFERENCES Course_providors(id),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Skill_extraction(
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100),
    `type` VARCHAR(100),
    `position` INT,
    `edit_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (position) REFERENCES Positions(id),
    CONSTRAINT Skill UNIQUE (skill,position),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Keywords(
    `id` INT NOT NULL AUTO_INCREMENT,
    `keyword` VARCHAR(100),
    `edit_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT keyword_unique UNIQUE (keyword),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Skill_keywords(
	`skill_id` INT NOT NULL,
	`keyword_id` INT NOT NULL, 
	FOREIGN KEY (skill_id) REFERENCES Skill_extraction(id)
    ON DELETE CASCADE,
	FOREIGN KEY (keyword_id) REFERENCES Keywords(id)
    ON DELETE CASCADE,
    CONSTRAINT keyword_skill_unique UNIQUE (skill_id,keyword_id)
);

CREATE TABLE Skill_keyword_loading(
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100),
    `keyword` VARCHAR(100),
    `type` VARCHAR(100),
    `position` INT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Position_skill_loading(
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100),
    `position_id` INTEGER,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Position_stack_skill_loading(
    `id` INT NOT NULL AUTO_INCREMENT,
    `stack` INTEGER,
    `skill` VARCHAR(100),
    `position` INTEGER,
    PRIMARY KEY (id)
);

#Keyword extraction data goes here..
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','cloud','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','data','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','data science','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','hadoop','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','hdfs','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','mapreduce','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','spark','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','valence','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','value','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','variety','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','velocity','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','veracity','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','volume','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','cloud','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','engineers','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','hadoop','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','hdfs','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','mapreduce','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('big data','spark','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','apache','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','big data','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','cloud','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','cloud platform','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','distributed','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','hdfs','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','hive','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','mapreduce','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','networking','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','platform','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','cloud','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','clouds','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','distributed','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','hadoop','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','key-value','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','mapreduce','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('cloud computing','nosql','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','analysis','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','analytical','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','analytics','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','business','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','business analytics','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','data','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','data analysis','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','decision','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','decisions','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','making','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','model','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','models','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','optimization','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','predictive','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','prescriptive','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','probability','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','process','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','regression','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','simulation','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','statistical','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data analytics','statistics','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','etl','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','extract','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','load','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','transform','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','blending','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','cleaning','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','data','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','data blending','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','data cleaning','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','data formatting','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','data transforming','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','formatting','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','merge','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','merging','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','munging','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','transformation','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','transforming','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data manipulation','wrangling','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','association rule','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','association rules','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','classification','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','clustering','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','descriptive','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','predictive','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','regression','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','association rule','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','association rules','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','classification','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','cluster','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','clustering','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','clusters','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','descriptive','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','mining','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','predictive','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data mining','regression','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data cleaning','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','administrator','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data blending','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data formatting','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data munging','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data preperation','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data transformation','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data transforming','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data wrangling','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','database','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','databases','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','dba','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','etl','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','extract','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','load','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','manipulating','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','relational','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','sourcing','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','transform','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','business','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','business intelligence','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','cleaning','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','collection','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','data warehousing','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','database','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','databases','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','er','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','erd','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','intelligence','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','management','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','munging','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','mysql','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','oracle','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','processing','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','relational','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','sql','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','warehouse','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','warehousing','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data modeling','wrangling','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','ggally','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','ggpairs','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','ggplot','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','ggplot2','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','matplotlib','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','python','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','r','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','seaborne','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','analytics','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','bi','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','business','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','chart','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','charts','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','dashboard','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','dashboards','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','data','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','graph','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','graphs','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','histogram','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','histograms','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','insight','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','insights','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','intelligence','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','plot','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','plots','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','tableau','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','visualization','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','visualizations','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data visualization','visuals','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','architectures','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','big data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','database','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','design','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','designing','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','etl','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','extract','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','frequency','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','integration','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','load','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','model','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','modelling','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','parallel','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','processing','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','refresh','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','relational','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','sql','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','transfrom','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','warehouse','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('data warehousing','warehouses','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','ai','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','convolutional neural networks','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','data','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','data science','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','generative adversarial networks','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','learning','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','machine','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','network','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','networks','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','neural','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','neural networks','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','recurrent neural networks','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('deep learning','tensorflow','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','binomial','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','chi-square','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','data distributions','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','exponential distribution','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','mean','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','median','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','mode','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','normal distribution','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','poisson','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','probability','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','probability distribution','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','standard deviation','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','standard distribution','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('descriptive statistics','variance','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','anova','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','chi-squared','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','confidence intervals','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','hypothesis','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','linear regression','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','logistic regression','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','mann-whitney u','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','p-value','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','p-values','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','regression','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','significance','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','test','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','test for significance','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','testing','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','tests for significance','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','t-test','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','t-tests','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','z-test','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('inferential statistics','z-tests','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','learning','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','bayes','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','cluster','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','clustering','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','computer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','decision tree','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','decision trees','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','deep','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','k-means','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','machine','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','natural language processing','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','neural','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','nlp','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','recommender','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','supervised','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','support vector','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','text','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','unsupervised','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','un-supervised','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('machine learning','vision','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','cassandra','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','data','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','database','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','documentdb','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','graph','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','key-value','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','mongodb','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','non-relational','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','semi-structured','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','unstructured','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','cassandra','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','database','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','documentdb','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','graph','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','key','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','key-value','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','mongodb','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','non-relational','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','semi-structured','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','unstructured','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('nosql','value','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','data science','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','database','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','databases','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','relational','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','table','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','tables','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','acid','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','data','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','database','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','engineer','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','mysql','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','oltp','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','oracle','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','postgresql','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','rdbms','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','relational','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','server','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','sql','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','structured','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','transaction','fundamental',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','relational','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','business','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','data','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','database','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','databases','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','diagrams','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','er','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','erd','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','intelligence','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','mysql','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','relationship','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','sql','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','table','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sql','tables','fundamental',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','ai','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','bayesian','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','decision tree','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','decision trees','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','ensemble methods','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','learning','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','logistic regression','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','machine','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','naive bayes classification','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','neural','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','neural network','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','ordinary least squares regression','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','support vector machine','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('supervised learning','svm','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','ai','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','cluster','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','clustering','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','clusters','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','feature selection','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','independent component analysis','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','information theory','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','k-means','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','learning','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','machine','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','pattern','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','principal component analysis','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','recognition','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','reinforcement learning','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','singular value decomposition','fundamental',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('unsupervised learning','statistical','fundamental',1);

#Technical skills
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('sas','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('keras','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tensorflow','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scikit learn','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pandas','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','supervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','unsupervised learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','ai','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','decision trees','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','decision tree','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','bayesian','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','naive bayes classification','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','ordinary least squares regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','logistic regression','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','neural network','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','neural','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','support vector machine','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','svm','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','ensemble methods','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','machine learning','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','predictive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','descriptive','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','descision models','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','sandkey plot','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','story telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','story-telling','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','deep neural networks','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','ann','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','statistics','technical',1);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('java','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('scala','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('spark','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hive','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pig','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hbase','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('pentaho','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','etl','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('postgresql','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','Data Cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','Data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','Data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','ETL','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('hadoop','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','Data Cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','Data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','Data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','ETL','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','Data Cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','Data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','Data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','ETL','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','Data Cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','Data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','Data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','ETL','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mapreduce','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','Data Cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','Data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','Data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','ETL','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('bash','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','relational','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','manipulating','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data preperation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','Data Cleaning','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data wrangling','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','Data munging','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','Data transformation','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data blending','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data transforming','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data formatting','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','ETL','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','extract','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','transform','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','load','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','distributed','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','distributed computing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','big data','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','cloud data processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data pipelines','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data warehouse','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data warehouses','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','data warehousing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','batch processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','realtime processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','real-time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('powershell','real time processing','technical',2);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','business','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','intelligence','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','sql','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','erd','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','er','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','relational','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','database','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','databases','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','bi','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','visualization','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','visualizations','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','graphs','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','graph','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','histogram','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','histograms','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','dashboard','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','dashboards','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data warehousing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data warehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','datawarehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','data analysis','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','decision making','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','munging','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','collection','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','wrangling','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','cleaning','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('python','processing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','business','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','intelligence','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','sql','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','erd','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','er','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','relational','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','database','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','databases','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','bi','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','visualization','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','visualizations','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','graphs','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','graph','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','histogram','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','histograms','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','dashboard','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','dashboards','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','data warehousing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','data warehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','datawarehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','data analysis','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','decision making','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','munging','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','collection','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','wrangling','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','cleaning','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('r','processing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','business','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','intelligence','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','sql','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','erd','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','er','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','relational','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','database','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','databases','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','bi','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','visualization','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','visualizations','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','graphs','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','graph','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','histogram','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','histograms','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','dashboard','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','dashboards','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','data warehousing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','data warehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','datawarehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','data analysis','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','decision making','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','munging','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','collection','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','wrangling','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','cleaning','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('ggplot2','processing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','business','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','intelligence','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','sql','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','erd','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','er','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','relational','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','database','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','databases','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','bi','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','visualization','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','visualizations','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','graphs','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','graph','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','histogram','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','histograms','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','dashboard','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','dashboards','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data warehousing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data warehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','datawarehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','data analysis','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','decision making','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','munging','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','collection','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','wrangling','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','cleaning','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mongodb','processing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','business','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','intelligence','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','sql','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','erd','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','er','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','relational','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','database','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','databases','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','bi','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','visualization','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','visualizations','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','graphs','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','graph','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','histogram','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','histograms','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','dashboard','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','dashboards','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data warehousing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data warehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','datawarehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','data analysis','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','decision making','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','munging','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','collection','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','wrangling','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','cleaning','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('mysql','processing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','business','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','intelligence','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','sql','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','erd','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','er','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','relational','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','database','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','databases','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','bi','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','visualization','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','visualizations','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','graphs','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','graph','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','histogram','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','histograms','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','dashboard','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','dashboards','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','plots','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','data warehousing','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','data warehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','datawarehouse','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','data analysis','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','decision making','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','munging','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','collection','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','wrangling','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','cleaning','technical',4);
insert into Skill_keyword_loading (skill,keyword,type,position) values ('tableau','processing','technical',4);

call fydp.keyword_extraction_data_loading;
call fydp.keyword_extraction;
call fydp.delete_dups;
call fydp.position_skill_data_loading;

#Data engineering tech stacks
insert into Technical_combinations (name) values ('Data Engineer Basics');
insert into Position_combinations (position_id,combination_id) values (2,1);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'java',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'scala',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'hadoop',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'mongodb',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'mysql',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'mapreduce',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'bash',2);
insert into Position_stack_skill_loading (stack,skill,position) values (1,'powershell',2);

insert into Technical_combinations (name) values ('Data Engineer Intermediate');
insert into Position_combinations (position_id,combination_id) values (2,2);
insert into Position_stack_skill_loading (stack,skill,position) values (2,'java',2);
insert into Position_stack_skill_loading (stack,skill,position) values (2,'scala',2);
insert into Position_stack_skill_loading (stack,skill,position) values (2,'spark',2);
insert into Position_stack_skill_loading (stack,skill,position) values (2,'hive',2);
insert into Position_stack_skill_loading (stack,skill,position) values (2,'pig',2);
insert into Position_stack_skill_loading (stack,skill,position) values (2,'hbase',2);

insert into Technical_combinations (name) values ('Data Engineer ETL,workflow,automation,streaming');
insert into Position_combinations (position_id,combination_id) values (2,3);
insert into Position_stack_skill_loading (stack,skill,position) values (3,'java',2);
insert into Position_stack_skill_loading (stack,skill,position) values (3,'scala',2);
insert into Position_stack_skill_loading (stack,skill,position) values (3,'spark',2);
insert into Position_stack_skill_loading (stack,skill,position) values (3,'pentaho',2);

insert into Technical_combinations (name) values ('Data Engineer mix');
insert into Position_combinations (position_id,combination_id) values (2,4);
insert into Position_stack_skill_loading (stack,skill,position) values (4,'python',2);
insert into Position_stack_skill_loading (stack,skill,position) values (4,'scala',2);
insert into Position_stack_skill_loading (stack,skill,position) values (4,'spark',2);
insert into Position_stack_skill_loading (stack,skill,position) values (4,'hive',2);
insert into Position_stack_skill_loading (stack,skill,position) values (4,'postgresql',2);

#Data scientist tech stack
insert into Technical_combinations (name) values ('Data Scientist Basics');
insert into Position_combinations (position_id,combination_id) values (1,5);
insert into Position_stack_skill_loading (stack,skill,position) values (5,'python',1);
insert into Position_stack_skill_loading (stack,skill,position) values (5,'mongodb',1);
insert into Position_stack_skill_loading (stack,skill,position) values (5,'mysql',1);
#insert into Position_stack_skill_loading (stack,skill,position) values (1,'Scikit learn',1);
insert into Position_stack_skill_loading (stack,skill,position) values (5,'pandas',1);
insert into Position_stack_skill_loading (stack,skill,position) values (5,'bash',1);
insert into Position_stack_skill_loading (stack,skill,position) values (5,'tableau',1);

insert into Technical_combinations (name) values ('Data Scientist Basics R');
insert into Position_combinations (position_id,combination_id) values (1,6);
insert into Position_stack_skill_loading (stack,skill,position) values (6,'r',1);
insert into Position_stack_skill_loading (stack,skill,position) values (6,'mongodb',1);
insert into Position_stack_skill_loading (stack,skill,position) values (6,'mysql',1);
insert into Position_stack_skill_loading (stack,skill,position) values (6,'ggplot2',1);
insert into Position_stack_skill_loading (stack,skill,position) values (6,'bash',1);
insert into Position_stack_skill_loading (stack,skill,position) values (6,'tableau',1);

insert into Technical_combinations (name) values ('Data Scientist intermediate/distributed');
insert into Position_combinations (position_id,combination_id) values (1,7);
insert into Position_stack_skill_loading (stack,skill,position) values (7,'spark',1);
insert into Position_stack_skill_loading (stack,skill,position) values (7,'scala',1);
insert into Position_stack_skill_loading (stack,skill,position) values (7,'hadoop',1);
insert into Position_stack_skill_loading (stack,skill,position) values (7,'mapreduce',1);
insert into Position_stack_skill_loading (stack,skill,position) values (7,'hbase',1);
insert into Position_stack_skill_loading (stack,skill,position) values (7,'tensorflow',1);
#insert into Position_stack_skill_loading (stack,skill,position) values (3,'keras',1);

insert into Technical_combinations (name) values ('Data Scientist industry stack');
insert into Position_combinations (position_id,combination_id) values (1,8);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'sas',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'r',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'python',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'tableau',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'spark',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'hadoop',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'keras',1);
insert into Position_stack_skill_loading (stack,skill,position) values (8,'tensorflow',1);

insert into Technical_combinations (name) values ('Business intelligence one');
insert into Position_combinations (position_id,combination_id) values (4,9);
insert into Position_stack_skill_loading (stack,skill,position) values (9,'python',4);
insert into Position_stack_skill_loading (stack,skill,position) values (9,'mongodb',4);
insert into Position_stack_skill_loading (stack,skill,position) values (9,'mysql',4);
insert into Position_stack_skill_loading (stack,skill,position) values (9,'tableau',4);

insert into Technical_combinations (name) values ('Business intelligence two');
insert into Position_combinations (position_id,combination_id) values (4,10);
insert into Position_stack_skill_loading (stack,skill,position) values (10,'r',4);
insert into Position_stack_skill_loading (stack,skill,position) values (10,'mongodb',4);
insert into Position_stack_skill_loading (stack,skill,position) values (10,'mysql',4);
insert into Position_stack_skill_loading (stack,skill,position) values (10,'tableau',4);
insert into Position_stack_skill_loading (stack,skill,position) values (10,'ggplot2',4);

call combination_skill_data_loading;

#;)
delete from Position_skills where position_id = 1 and skill_id = 41;