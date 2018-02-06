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
    `description` VARCHAR(400),
    `level` INT,
    `comments` VARCHAR(200),
    PRIMARY KEY (id)
);

CREATE TABLE Course_skills (
    `course_id` INT NOT NULL,
    `skill_id` INT,
    FOREIGN KEY (course_id) REFERENCES 	Courses(id),
	FOREIGN KEY (skill_id) REFERENCES Skills(id)
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
    FOREIGN KEY (id) REFERENCES Users(id),
	PRIMARY KEY (id)
);

CREATE TABLE Plans (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT,
    `position` VARCHAR(200),
    `budget`    float ,
    `weeks` INT,
    `hours` float,
    `MOOC1` INT,
    `MOOC2` INT, 
    `MOOC3` INT,
    `MOOC4` INT,
    `time_stamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    PRIMARY KEY (id)
);

CREATE TABLE Plan_courses (
    `plan_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES 	Plans(id),
	FOREIGN KEY (course_id) REFERENCES Courses(id)
);

CREATE TABLE Scraper_logs(
    `id` INT NOT NULL AUTO_INCREMENT,
    `course_provider_id` INT NOT NULL,
    `error_message` VARCHAR(400),
    `url` VARCHAR(200),
    `time_stamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_provider_id) REFERENCES Course_providors(id),
    PRIMARY KEY (id)
);

CREATE TABLE Keywords(
    `id` INT NOT NULL AUTO_INCREMENT,
    `skill` VARCHAR(100),
    `edit_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);