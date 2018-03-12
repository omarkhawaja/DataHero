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
call keyword_extraction();

select price from Courses where course_provider_id = 3;
select ExtractNumber('FreeAddaVerifiedCertificatefor$99 USD') AS Number from dual;

call clean_prices();

select id,length from Courses where course_provider_id = 2;

select x.id,
		case when y.skill_id is null then 0 else 1 end as skill_code 
		from
		(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s where x.course_provider_id in (2,3,4))x
		left outer join
		(select course_id,skill_id from Course_skills order by course_id,skill_id asc)y
		on x.id = y.course_id and x.skill = y.skill_id
		order by x.id,x.skill asc
        limit 10000000;
select length from Courses where course_provider_id = 2;


select z.id,x.skill from Course_skills y inner join Skills x on y.skill_id = x.id inner join Courses z on y.course_id = z.id and z.name in 
('Big Data Analytics in Healthcare');

select skill_id from Course_skills where course_id in (1510);

drop table Skill_keywords;
drop table Keywords;
drop table Skill_extraction;
drop table Skill_keyword_loading;