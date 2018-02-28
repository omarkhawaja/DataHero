import MySQLdb
from utils import jsonify

config = {
'user': 'root',
'password': 'root',
'host': '35.229.91.75',
'database': 'fydp',
}

conn = MySQLdb.connect(**config)
cur = conn.cursor()

#solution to unicodeencodeerror https://dasprids.de/blog/2007/12/17/python-mysqldb-and-utf-8/
conn.set_character_set('utf8')
cur.execute('SET NAMES utf8;')
cur.execute('SET CHARACTER SET utf8;')
cur.execute('SET character_set_connection=utf8;')

class OR_inputs(object):
	def __init__(self, provider,rating=None):
		super(OR_inputs, self).__init__()
		self.provider = provider
		self.rating = rating

	def fetch_courses(self):
		try:
			if self.rating == None:
				cur.execute('''SELECT id,rating,price,length FROM Courses WHERE course_provider_id = {};'''.format(self.provider))
			else:
				cur.execute('''SELECT id,rating,price,length FROM Courses WHERE course_provider_id = {} AND rating >= {};'''.format(self.provider,self.rating))

			data = cur.fetchall()
			courses = [int(x[0]) for x in data]
			ratings = [float(x[1]) for x in data]
			prices = [x[2] for x in data]
			lengths = [float(x[3]) for x in data]

			cleaned_prices = [float(s.split("$",1)[1].replace('USD','').strip()) if '$' in s else 0 for s in prices]
			cleaned_ratings = [1000 if x == 0.0 else x for x in ratings]

			return courses,cleaned_ratings,cleaned_prices,lengths

		except Exception as e:
			print(e)

	def fetch_courseSkill_matrix(self,num_courses):

		cur.execute('''select x.id,
		case when y.skill_id is null then 0 else 1 end as skill_code 
		from
		(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s where x.course_provider_id = 3)x
		left outer join
		(select course_id,skill_id from Course_skills order by course_id,skill_id asc)y
		on x.id = y.course_id and x.skill = y.skill_id
		order by x.id,x.skill asc; 
		''')

		data_skills = cur.fetchall()
		all_skills = [x[1] for x in data_skills]

		cur.execute('''select count(distinct id) from Skills;''')
		num_skills_data = cur.fetchall()
		num_skills = num_skills_data[0][0]

		index = num_skills*num_courses

		matrix = [list(all_skills[x:x+num_skills]) for x in range(0,index,num_skills)]

		return matrix

	def fetch_courseSkillLvls_matrix(self,num_courses):
		cur.execute('''select x.id,
		case when (y.skill_lvl is null or y.skill_lvl = 0) then 0 else 1 end as skill_lvl
		from
		(select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s where x.course_provider_id = 3)x
		left outer join
		(select course_id,skill_id,skill_lvl from Course_skills order by course_id,skill_id asc)y
		on x.id = y.course_id and x.skill = y.skill_id
		order by x.id,x.skill asc;		
		''')

		data_skills = cur.fetchall()
		all_skills = [x[1] for x in data_skills]

		cur.execute('''select count(distinct id) from Skills;''')
		num_skills_data = cur.fetchall()
		num_skills = num_skills_data[0][0]

		index = num_skills*num_courses

		matrix = [list(all_skills[x:x+num_skills]) for x in range(0,index,num_skills)]

		return matrix

	def fetch_needed_skills(self,position,user_skills):
		required_skills = {}
		needed_skills = {}
		#0 doesn't have, 1 beginner/intermediate, 2 doesn't need
		cur.execute('''select skill_id,skill_lvl from Position_skills where position_id = {};'''.format(position))
		query_result = cur.fetchall()
		required_skills = {int(x[0]):int(x[1]) for x in query_result}

		for skill,lvl in required_skills.items():
			if lvl == 0:
				if user_skills[skill] + lvl == 1:
					needed_skills[skill] = 0 
				else:
					needed_skills[skill] = None
			elif lvl == 1:
				if user_skills[skill] + lvl == 2:
					#this should be [0,1] but it's okay ;)
					needed_skills[skill] = 1
				elif user_skills[skill] + lvl == 3:
					needed_skills[skill] = 1
				elif user_skills[skill] + lvl == 4:
					needed_skills[skill] = None
			else:
				print("ERROR CHECK CHECK CHECK")

		return self.needed_skills_input(needed_skills)

	def needed_skills_input(self,needed_skills):
		cur.execute('''select count(*) from Skills;''')
		query_result = cur.fetchall()
		num_skills = query_result[0][0]

		needed_skills_list = [0 for x in range(num_skills)]
		needed_levels_list = [0 for x in range(num_skills)]

		for skill,lvl in needed_skills.items():
			if lvl != None:
				needed_skills_list[skill - 1] = 1
			if lvl == 1:
				needed_levels_list[skill - 1] = 1

		return needed_skills_list,needed_levels_list

	def fetch_tech_combinations(self,position):
		combinations_skills = {}
		cur.execute('''select combination_id from Position_combinations where position_id = {};'''.format(int(position)))
		query_result = cur.fetchall()
		combination_ids = [x[0] for x in query_result]

		for combination in combination_ids:
			cur.execute('''select skill_id from Combination_skills where combination_id = {};'''.format(combination))
			query_result = cur.fetchall()
			combinations_skills[combination] = [x[0] for x in query_result]

		return combination_ids,combinations_skills

class OR_outputs(object):
	def __init__(self, courses):
		super(OR_outputs, self).__init__()
		self.courses = [str(x) for x in courses]

	def fetch_course_details(self):
		cur.execute("""select x.id,x.name,x.price,x.rating,x.description,x.length,x.url,y.name as 'inst_name',y.rating as 'inst_rating'
					from Courses x inner join Course_instructors y on x.instructor_id = y.id
					where x.id in ({}) """.format(",".join(self.courses)))
		all_details = cur.fetchall()
		fields = cur.description
		course_details = jsonify(all_details,fields,'plan')
		return course_details

class Positions(object):
	def __init__(self, position):
		super(Positions, self).__init__()
		if position != None:
			self.position = int(position)
		else:
			self.position = position

	def fetch_positions(self):
		cur.execute('''select * from Positions;''')
		query_result = cur.fetchall()
		fields = cur.description
		positions = jsonify(query_result,fields)
		return positions

	def fetch_position_skills(self):
		cur.execute('''select x.* from Skills x inner join Position_skills y on x.id = y.skill_id and y.position_id = {};'''.format(self.position))
		query_result = cur.fetchall()
		fields = cur.description
		position_skills = jsonify(query_result,fields)
		return position_skills

	def get_name(self):
		cur.execute('''select distinct(y.position) from Plans x inner join Positions y on x.position_id = y.id and y.id = {};'''.format(self.position))
		query_result = cur.fetchall()
		position_name = query_result[0][0]
		return position_name

class Plans(object):

	def __init__(self, user_id=None, plan_id=None):
		super(Plans, self).__init__()
		self.user = user_id
		self.plan = plan_id

	def save(self):
		try:
			cur.execute('''update Plans set user_id = {} where id = {};'''.format(self.user,self.plan))
			conn.commit()
			return 1

		except:
			conn.rollback()
			return 0

	#look into what to do for error handling
	def add(self,position,plan_json,combination,needed_skills):
		plan_price = plan_json[0]['total_price']
		plan_length = plan_json[0]['total_length']
		course_count = plan_json[0]['course_count']
		courses = plan_json[1:]

		try:
			cur.execute('''insert into Plans (position_id,cost,length,number_courses,technical_skills_id) values ({},{},{},{},{});'''.format(position,plan_price,plan_length,course_count,combination))
			plan = cur.lastrowid
			print(plan)

			for course in courses:
				cur.execute('''insert into Plan_courses (plan_id,course_id) values ({},{});'''.format(plan,course['id']))

			#needed_skills is a binary list indicating if a skill is needed. The indx's in the list refer to the skill_id - 1.
			for indx,skill in enumerate(needed_skills):
				if skill == 1:
					cur.execute('''insert into Plan_skills (plan_id,skill_id) values ({},{});'''.format(plan,indx + 1))

			conn.commit()
			return plan

		except Exception as e:
			print(e)
			conn.rollback()

	def delete(self):
		try:
			cur.execute('''update Plans set user_id = Null where id = {} and user_id = {};'''.format(self.plan,self.user))
			conn.commit()
			return 1

		except:
			conn.rollback()
			return 0

	def fetch(self):
		plans = []
		try:
			cur.execute('''select * from Plans where user_id = {};'''.format(self.user))
			query_result = cur.fetchall()
			plan_ids = [x[0] for x in query_result]
			time_stamps = [x[7] for x in query_result]
			position_ids = [x[2] for x in query_result]
		#needed?
		except:
			pass

		for plan,time_stamp,position_id in zip(plan_ids,time_stamps,position_ids):
			cur.execute('''select course_id from Plan_courses where plan_id = {};'''.format(plan))
			query_result = cur.fetchall()
			courses = [x[0] for x in query_result]
			if len(courses) != 0:
				output = OR_outputs(courses=courses)
				cur_plan = output.fetch_course_details()
				
				cur.execute('''select y.skill_id from Plans x inner join Combination_skills y on x.technical_skills_id = y.combination_id where x.id = {};'''.format(plan))
				query_result = cur.fetchall()
				tech_skill_combo = [x[0] for x in query_result]

				cur_plan[0]['plan_id'] = plan

				skills = Skills(tech_skill_combo)
				cur_plan[0]['tech_combo'] = skills.get_names()

				cur_plan[0]['time_stamp'] = str(time_stamp)

				position = Positions(position_id)
				cur_plan[0]['position'] = position.get_name()
				
				plans.append(cur_plan)

		return plans

class Skills(object):
	def __init__(self, skills):
		super(Skills, self).__init__()
		self.skills = ','.join([str(i) for i in skills])

	def get_names(self):
		cur.execute('''select skill from Skills where id in ({});'''.format(self.skills))
		query_result = cur.fetchall()
		skill_names = [x[0] for x in query_result]
		return skill_names
		
if __name__ == '__main__':	
	pass