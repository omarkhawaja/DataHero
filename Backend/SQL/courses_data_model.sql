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
	FOREIGN KEY (instructor_id) REFERENCES 	Course_instructors(id),
	FOREIGN KEY (course_provider_id) REFERENCES Course_providors(id),
	PRIMARY KEY (id)
);