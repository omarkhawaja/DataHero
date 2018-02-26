from flask import Flask, request
from flask_restful import Resource, Api
import MySQLdb
from flask_cors import CORS 
import json
from decimal import Decimal as D

from PythonModel import run_algorithm
from db_interface import OR_inputs, OR_outputs, Positions, Plans, Skills
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

class Create_plan(Resource):
    def get(self,skills_needed_string):
        #to store the different plans   
        plans = []
        plan = Plans()

        position,budget,timeAllocation,user_skills = parse_request(skills_needed_string)

        inputs = OR_inputs(3)
        courses,ratings,prices,lengths = inputs.fetch_courses()
        courseSkill_matrix = inputs.fetch_courseSkill_matrix(len(courses))
        courseSkillLvl_matrix = inputs.fetch_courseSkillLvls_matrix(len(courses))
        combination_ids,combinations = inputs.fetch_tech_combinations(position)
        needed_skills,needed_skills_lvls = inputs.fetch_needed_skills(position,user_skills)

        #to fetch the tech combination id for the plans
        i = 0
        for tech_skill_combo in combinations.values():

            skills_needed = add_tech_combo(needed_skills,tech_skill_combo)
            courses_recomended = run_algorithm(courses,courseSkill_matrix,courseSkillLvl_matrix,prices,ratings,lengths,timeAllocation,budget,skills_needed,needed_skills_lvls)
            outputs = OR_outputs(courses_recomended)
            plan_json = outputs.fetch_course_details()
            plan_id = plan.add(position,plan_json,combination_ids[i],needed_skills)
            
            plan_json[0]['plan_id'] = plan_id

            skills = Skills(tech_skill_combo)
            plan_json[0]['tech_combo'] = skills.get_names()
            
            plans.append(plan_json)
            i = i + 1

        return plans

class Plan_save(Resource):
    # curl -i -H "Content-Type: application/json" -H "Accept:application/json" -X POST -d "{\"plan_id\":\"5\",\"user_id\":\"2\"}" http://127.0.0.1:5000/save_plan
    def post(self):
        plan_id = request.json['plan_id']
        user_id = request.json['user_id']
        plan = Plans(plan_id=plan_id,user_id=user_id)
        saved = plan.save()
        if saved == 1:
            return {'status':'success'}
        elif saved == 0:
            return {'status':'fail'}  

class Plan_delete(Resource):
    # curl -i -H "Content-Type: application/json" -H "Accept:application/json" -X POST -d "{\"plan_id\":\"1\",\"user_id\":\"1\"}" http://127.0.0.1:5000/delete_plan
    def post(self):
        plan_id = request.json['plan_id']
        user_id = request.json['user_id']
        plan = Plans(plan_id=plan_id,user_id=user_id)
        deleted = plan.delete()
        if deleted == 1:
            return {'status':'success'}
        elif deleted == 0:
            return {'status':'fail'}

class User_plans(Resource):
    def get(self,user_id):
        user = parse_normal(user_id)
        plans = Plans(user_id=user)
        user_plans = plans.fetch()
        return user_plans

#Endpoints
api.add_resource(Positions_list, '/positions')
api.add_resource(Position_skills, '/positions/skills/<position_id>')
api.add_resource(Create_plan, '/create_plan/<skills_needed_string>')
api.add_resource(Plan_save, '/save_plan')
api.add_resource(Plan_delete, '/delete_plan')
api.add_resource(User_plans, '/plans/user/<user_id>')

if __name__ == '__main__':
     app.run()