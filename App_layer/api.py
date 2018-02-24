from flask import Flask, request
from flask_restful import Resource, Api
import MySQLdb
from flask_cors import CORS 
import json
from decimal import Decimal as D

from PythonModel import run_algorithm
from db_interface import OR_inputs, OR_outputs
from utils import add_tech_combo, parse_request

config = {
'user': 'root',
'password': 'root',
'host': '35.229.91.75',
'database': 'fydp',
}

app = Flask(__name__)
api = Api(app)
CORS(app)

class Position_skills(Resource):
    def get(self):
        course = {}
        courses = []

        conn = MySQLdb.connect(**config)
        cur = conn.cursor()
        conn.set_character_set('utf8')

        cur.execute("select * from Courses;")
        result = cur.fetchall()
        fields = [i[0] for i in cur.description if i[0] != 'time_scraped']
        for i in result:
            y = 0
            for field in fields:
                course[field] = i[y]
                y = y + 1
            courses.append(course)
            course = {}

        return courses
    
    def post(self):
        conn = db_connect.connect()
        print(request.json)
        LastName = request.json['LastName']
        FirstName = request.json['FirstName']
        Title = request.json['Title']
        ReportsTo = request.json['ReportsTo']
        BirthDate = request.json['BirthDate']
        HireDate = request.json['HireDate']
        Address = request.json['Address']
        City = request.json['City']
        State = request.json['State']
        Country = request.json['Country']
        PostalCode = request.json['PostalCode']
        Phone = request.json['Phone']
        Fax = request.json['Fax']
        Email = request.json['Email']
        query = conn.execute("insert into employees values(null,'{0}','{1}','{2}','{3}', \
                             '{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}', \
                             '{13}')".format(LastName,FirstName,Title,
                             ReportsTo, BirthDate, HireDate, Address,
                             City, State, Country, PostalCode, Phone, Fax,
                             Email))
        return {'status':'success'}

class Create_plan(Resource):
    def get(self,skills_needed_string):
        #to store all the plans
        courses_json = []
        #to store the json for one plan 
        course_json = []
        #to store the json details for a course
        course = {}

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

            #replace with a jsonify function
            fields = [i[0] for i in fields if i[0] != 'time_scraped']
            for i in course_details:
                y = 0
                for field in fields:
                    if isinstance(i[y],D):
                        course[field] = float(i[y])
                    else:
                        course[field] = i[y]
                    y = y + 1
                course_json.append(course)
                course = {}

            #replace these with a util function
            total_price = {}
            total_length = {}
            total_courses = {}
            total_price['total_price'] = 340
            total_length['total_length'] = 340
            total_courses['course_count'] = 5

            course_json.append(total_price)
            course_json.append(total_length)
            course_json.append(total_courses)
            courses_json.append(course_json)
            course_json = []

        return courses_json
            
        
api.add_resource(Position_skills, '/position_skills/')
api.add_resource(Create_plan, '/create_plan/<skills_needed_string>')

if __name__ == '__main__':
     app.run()