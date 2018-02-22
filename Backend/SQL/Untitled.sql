select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s limit 1000000;
select course_id,skill_id from Course_skills order by course_id,skill_id asc limit 1000000;

select course_id,skill_id from Course_skills order by course_id,skill_id asc limit 1000000;
select distinct course_id,skill_id from Course_skills order by course_id,skill_id asc limit 1000000;

select course_id, count(course_id), skill_id, count(skill_id) from Course_skills
group by course_id, skill_id
having
(count(course_id) > 1) and (count(skill_id) > 1);

select * from Courses where course_provider_id = 3;


select x.id,
case when skill_lvl = 0 then 1 else (case when skill_lvl = 1 then 2 else (case when skill_lvl is null then 0 end) end)
end as 'skill_lvl'
from
(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s where x.course_provider_id = 3 order by x.id,s.id asc)x
left outer join
(select course_id,skill_id,skill_lvl from Course_skills x inner join Courses y on x.course_id = y.id and y.course_provider_id = 3 order by course_id,skill_id asc)y
on x.id = y.course_id and x.skill = y.skill_id
order by x.id,x.skill asc;
