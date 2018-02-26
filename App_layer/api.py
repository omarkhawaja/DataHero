from flask import Flask, request
from flask_restful import Resource, Api
import MySQLdb
from flask_cors import CORS 
import json
from decimal import Decimal as D

#from PythonModel import run_algorithm
from db_interface import OR_inputs, OR_outputs, Positions, Plans
from utils import add_tech_combo, parse_request, jsonify, parse_normal

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

class Plan_save(Resource):
    # curl -i -H "Content-Type: application/json" -H "Accept:application/json" -X POST -d "{\"plan_id\":\"1\",\"user_id\":\"1\"}" http://127.0.0.1:5000/save_plan
    def post(self):
        plan_id = request.json['plan_id']
        user_id = request.json['user_id']
        plan = Plans(plan_id,user_id)
        saved = plan.save()
        if saved == 1:
            return {'status':'success'}
        elif saved == 0:
            return {'status':'fail'}            

class Create_plan(Resource):
    def get(self,skills_needed_string):
        #to store the different plans   
        plans = []

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
            course_details = outputs.fetch_course_details()
            plans.append(plan_json)

        return plans
            
        
api.add_resource(Positions_list, '/positions')
api.add_resource(Position_skills, '/positions/skills/<position_id>')
api.add_resource(Create_plan, '/create_plan/<skills_needed_string>')
api.add_resource(Plan_save, '/save_plan')

if __name__ == '__main__':
     app.run()