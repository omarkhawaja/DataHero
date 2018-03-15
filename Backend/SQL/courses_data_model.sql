use fydp;
CREATE TABLE Course_providors (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(500) NOT NULL, 
	`url` VARCHAR(500) NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE Course_instructors (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL, 
	`rating` DECIMAL, 
	`num_reviews` INT, 
	`num_students` INT, 
	`num_courses` INT,
    `time_scraped` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (id) 
);

CREATE TABLE Courses (
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

CREATE TABLE Skills (
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100) NOT NULL,
    `type` VARCHAR(100),
    `position` INTEGER,
    `comments` VARCHAR(200),
    FOREIGN KEY (position) REFERENCES Positions(id),
    PRIMARY KEY (id)
);
CREATE TABLE Course_skills (
    `course_id` INT NOT NULL,
    `skill_id` INT,
    `skill_lvl` INT,
    `course_score` DECIMAL,
    FOREIGN KEY (course_id) REFERENCES 	Courses(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
);

CREATE TABLE Users (
	`id` INT NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(200) NOT NULL,
    `password` varchar(100) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE User_info (
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

CREATE TABLE Plans (
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

CREATE TABLE Plan_skills (
    `plan_id` INT NOT NULL,
    `skill_id` INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES 	Plans(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
);

CREATE TABLE Plan_courses (
    `plan_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES 	Plans(id)
    ON DELETE CASCADE,
	FOREIGN KEY (course_id) REFERENCES Courses(id)
    ON DELETE CASCADE
);

CREATE TABLE Positions (
	`id` INT NOT NULL AUTO_INCREMENT,
	`position` VARCHAR(100) NOT NULL, 
	`description` TEXT, 
	PRIMARY KEY (id)
);

CREATE TABLE Position_skills (
	`position_id` INT NOT NULL,
	`skill_id` INT NOT NULL, 
	`skill_lvl` INT,
	FOREIGN KEY (position_id) REFERENCES Positions(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
   );
   
CREATE TABLE Technical_combinations (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL, 
	`description` TEXT, 
	PRIMARY KEY (id)
);

CREATE TABLE Combination_skills (
	`combination_id` INT NOT NULL,
	`skill_id` INT NOT NULL, 
	`skill_lvl` INT,
	FOREIGN KEY (combination_id) REFERENCES Technical_combinations(id)
    ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
    ON DELETE CASCADE
   );
   
CREATE TABLE Position_combinations (
	`position_id` INT NOT NULL,
	`combination_id` INT NOT NULL, 
	FOREIGN KEY (position_id) REFERENCES Positions(id)
    ON DELETE CASCADE,
	FOREIGN KEY (combination_id) REFERENCES Technical_combinations(id)
    ON DELETE CASCADE
   );

CREATE TABLE Scraper_logs (
    `id` INT NOT NULL AUTO_INCREMENT,
    `course_provider_id` INT NOT NULL,
    `error_message` VARCHAR(400),
    `url` VARCHAR(200),
    `time_stamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_provider_id) REFERENCES Course_providors(id),
    PRIMARY KEY (id)
);

CREATE TABLE Skill_extraction(
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100),
    `type` VARCHAR(100),
    `position` INT,
    `edit_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (position) REFERENCES Positions(id),
    CONSTRAINT Skill UNIQUE (skill),
    PRIMARY KEY (id)
);

CREATE TABLE Keywords(
    `id` INT NOT NULL AUTO_INCREMENT,
    `keyword` VARCHAR(100),
    `edit_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT keyword_unique UNIQUE (keyword),
    PRIMARY KEY (id)
);

CREATE TABLE Skill_keywords(
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
    FOREIGN KEY (position) REFERENCES Positions(id),
    PRIMARY KEY (id)
);

CREATE TABLE Position_skill_loading(
    `id` INT NOT NULL AUTO_INCREMENT,
    `position` VARCHAR(100),
    `skill` VARCHAR(100),
    PRIMARY KEY (id)
);