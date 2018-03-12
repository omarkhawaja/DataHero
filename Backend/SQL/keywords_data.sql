use fydp;

insert into Skill_extraction (skill,type) values ('supervised learning','type');
SET @skill_id_ = LAST_INSERT_ID();
insert into Keywords (keyword) values ('decision trees');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Naive Bayes classification');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Basian');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Ordinary Least Squares regression');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Logistic regression');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Neural networks');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Support vector machines');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('Ensemble methods');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);
insert into Keywords (keyword) values ('cross validation');
SET @keyword_id_ = LAST_INSERT_ID();
insert into Skill_keywords (skill_id,keyword_id) values (@skill_id_,@keyword_id_);


drop table Skill_keywords;
drop table Keywords;
drop table Skill_extraction;

select x.id,
		sum(case when (y.course_score is null or y.skill_lvl = 0) then (-1000000) else y.course_score end) as course_score
		from
		(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills where id in(27,28,30,20,21) order by id asc)s where x.course_provider_id in (2,3,4))x
		left outer join
		(select course_id,skill_id,skill_lvl,course_score from Course_skills order by course_id,skill_id asc)y
		on x.id = y.course_id and x.skill = y.skill_id
		group by x.id
		order by x.id asc
        limit 10000;