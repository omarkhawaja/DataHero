from flask import Flask, request
from flask_restful import Resource, Api
import MySQLdb
from flask_cors import CORS 
import json
from decimal import Decimal as D

from PythonModel import run_algorithm
from db_interface import OR_inputs, OR_outputs, Positions
from utils import add_tech_combo, parse_request, jsonify, parse_normal

config = {
'user': 'root',
'password': 'root',
'host': '35.229.91.75',
'database': 'fydp',
}

app = Flask(__name__)
api = Api(app)
CORS(app)

class Positions_list(Resource):
    def get(self,):
        data = Positions(None)
        positions = data.fetch_positions()
        return positions

class Position_skills(Resource):
    def get(self,position_id):
        position = parse_normal(position_id)
        data = Positions(position)
        position_skills = data.fetch_position_skills()
        return position_skills

class Plans(Resource):
    def get(self):
        pass

class Create_plan(Resource):
    def get(self,skills_needed_string):
        position,budget,timeAllocation,user_skills = parse_request(skills_needed_string)

        inputs = OR_inputs(3)
        courses,ratings,prices,lengths = inputs.fetch_courses()
        courseSkill_matrix = inputs.fetch_courseSkill_matrix(len(courses))
        courseSkillLvl_matrix = inputs.fetch_courseSkillLvls_matrix(len(courses))
        combinations = inputs.fetch_tech_combinations(position)
        needed_skills,needed_skills_lvls = inputs.fetch_needed_skills(position,user_skills)

        for tech_skill_combo in combinations.values():

            skills_needed = add_tech_combo(needed_skills,tech_skill_combo)
            courses_recomended = run_algorithm(courses,courseSkill_matrix,courseSkillLvl_matrix,prices,ratings,lengths,timeAllocation,budget,skills_needed,needed_skills_lvls)
            outputs = OR_outputs(courses_recomended)
            course_details,fields = outputs.fetch_course_details()

            course_json = jsonify(course_details,fields,'Plan')
            courses_json.append(course_json)

        return courses_json
            
        
api.add_resource(Positions_list, '/positions')
api.add_resource(Position_skills, '/positions/skills/<position_id>')
api.add_resource(Create_plan, '/create_plan/<skills_needed_string>')

if __name__ == '__main__':
     app.run()