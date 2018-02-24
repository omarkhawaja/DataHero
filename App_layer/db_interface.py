import MySQLdb

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
					needed_skills[skill] = [0,1]
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
		cur.execute('''select combination_id from Position_combinations where position_id = {};'''.format(2))
		query_result = cur.fetchall()
		combination_ids = [x[0] for x in query_result]

		for combination in combination_ids:
			cur.execute('''select skill_id from Combination_skills where combination_id = {};'''.format(combination))
			query_result = cur.fetchall()
			combinations_skills[combination] = [x[0] for x in query_result]

		return combinations_skills


class OR_outputs(object):

	def __init__(self, courses):
		super(OR_outputs, self).__init__()
		#input is coming in this format --> ['382','415'] need to add +1
		self.courses = [str(int(x) + 843) for x in courses]

	def fetch_course_details(self):
		cur.execute("""select x.id,x.name,x.price,x.rating,x.description,x.length,x.url,y.name as 'inst_name',y.rating as 'inst_rating'
					from Courses x inner join Course_instructors y on x.instructor_id = y.id
					where x.id in ({}) """.format(",".join(self.courses)))
		all_details = cur.fetchall()
		fields = cur.description
		return all_details,fields

if __name__ == '__main__':
	#Example usage for OR_inputs
	test = OR_inputs(1)
	courses,ratings,prices = test.fetch_courses()
	matrix = test.fetch_courseSkill_matrix()
	matrix2 = test.fetch_courseSkillLvls_matrix()

	#Example usage for OR_outputs
	courses_output = OR_outputs(['43','34','234'])
	test = courses_output.fetch_course_details()
	print(test[1][1])