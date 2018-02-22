from urllib.parse import parse_qsl

def missing_skills(position):
	pass

def parse_request(request_string):
	parsed = parse_qsl(request_string)
	for i in parsed:
		if i[0] == 'budget':
			budget = i[1]
		if i[0] == 'length':
			timeAllocation = i[1]
		if i[0] == 'position':
			position = i[1]
		if i[0] == 'skills':
			skills = i[1].split(',')
		if i[0] == 'levels':
			skill_lvls = i[1].split(',')

	return position,budget,timeAllocation,skills,skill_lvls 

if __name__ == '__main__':
	parse_request("budget=5&length=4&position=1&skills=4,15,55&level=0,1,0")