from flask import Flask, request
from flask_restful import Resource, Api
import MySQLdb
from PythonModel import main
from db_interface import OR_inputs, OR_outputs
from flask_cors import CORS 
import json
from decimal import Decimal as D

config = {
'user': 'root',
'password': 'root',
'host': '35.229.91.75',
'database': 'fydp',
}

app = Flask(__name__)
api = Api(app)
CORS(app)

class Courses(Resource):
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
        skills_needed = skills_needed_string.split(",")
        inputs = OR_inputs(1)
        courses,ratings,prices = inputs.fetch_courses()
        matrix = inputs.fetch_courseSkill_matrix(len(courses))
        ourses_recomended = main(courses,matrix,prices,ratings,skills_needed)
        outputs = OR_outputs(courses_recomended)
        #outputs = OR_outputs([33])
        course_details,fields = outputs.fetch_course_details()

        course = {}
        courses_json = []

        fields = [i[0] for i in fields if i[0] != 'time_scraped']
        for i in course_details:
            y = 0
            for field in fields:
                if isinstance(i[y],D):
                    course[field] = float(i[y])
                else:
                    course[field] = i[y]
                y = y + 1
            courses_json.append(course)
            course = {}

        return courses_json
        
api.add_resource(Courses, '/courses')
api.add_resource(Create_plan, '/create_plan/<skills_needed_string>')

if __name__ == '__main__':
     app.run()