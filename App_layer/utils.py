from urllib.parse import parse_qsl
from decimal import Decimal as D

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

def parse_normal(request_string):
	parsed = parse_qsl(request_string)
	if parsed[0][1] is not None:
		return parsed[0][1]
	else:
		return None

def get_total_price(prices):
	total_price = sum(prices)

def get_total_length(lengths):
	total_time = sum(lengths)

def get_number_of_courses(courses):
	total_courses = len(courses)

def add_plan_details(data_json,data):
	data_json['total_price'] = get_total_price()
	data_json['total_length'] = get_total_length()
	data_json['course_count'] = get_number_of_courses()
	retrn(data_json)

def jsonify(data,fields,plan = None):
	datum_json = {}
	data_json = []

	if plan == None:
		#replace with i[0] not in (config list of unwanted fields)
		fields = [i[0] for i in fields if i[0] != 'time_scraped']
		for i in data:
			for indx,field in enumerate(fields):
				if isinstance(i[indx],D):
					datum_json[field] = float(i[indx])
				else:
					datum_json[field] = i[indx]
			data_json.append(datum_json)
			datum_json = {}
	else:
		#replace these with a util function
		total_price = {}
		total_length = {}
		total_courses = {}
		total_price['total_price'] = 340
		total_length['total_length'] = 340
		total_courses['course_count'] = 5

		data_json.append(total_price)
		data_json.append(total_length)
		data_json.append(total_courses)

		#replace with i[0] not in (config list of unwanted fields)
		fields = [i[0] for i in fields if i[0] != 'time_scraped']
		for i in data:
			for indx,field in enumerate(fields):
				if isinstance(i[indx],D):
					datum_json[field] = float(i[indx])
				else:
					datum_json[field] = i[indx]
			data_json.append(datum_json)
			datum_json = {}

	return data_json

def add_tech_combo(needed_skills,tech_skill_combo):
	needed_skills_with_tech_combo = needed_skills[:]
	for skill in tech_skill_combo:
		needed_skills_with_tech_combo[skill - 1] = 1
	return needed_skills_with_tech_combo

if __name__ == '__main__':
	x,y,z,v = parse_request("budget=5&length=4&position=1&skills=4,15,55&levels=0,1,0")
	a = parse_normal("position_id=2")
	print(a)