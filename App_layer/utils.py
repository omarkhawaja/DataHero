from urllib.parse import parse_qsl

def parse_request(request_string):
	parsed = parse_qsl(request_string)
	for i in parsed:
		if i[0] == 'budget':
			budget = float(i[1])
		if i[0] == 'length':
			timeAllocation = float(i[1])
		if i[0] == 'position':
			position = int(i[1])
		if i[0] == 'skills':
			skills = i[1].split(',')
		if i[0] == 'levels':
			skill_lvls = i[1].split(',')

	user_skills = {int(x[0]):int(x[1]) for x in zip(skills,skill_lvls)}

	return position,budget,timeAllocation,user_skills

def get_total_price():
	pass

def get_total_length():
	pass

def get_number_of_courses():
	pass

def add_plan_details():
	pass

def jsonify_plan():
	pass

def add_tech_combo(needed_skills,tech_skill_combo):
	needed_skills_with_tech_combo = needed_skills[:]
	for skill in tech_skill_combo:
		needed_skills_with_tech_combo[skill - 1] = 1
	return needed_skills_with_tech_combo

if __name__ == '__main__':
	x,y,z,v = parse_request("budget=5&length=4&position=1&skills=4,15,55&levels=0,1,0")
	print(v[55])