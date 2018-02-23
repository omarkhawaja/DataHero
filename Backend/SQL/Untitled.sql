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