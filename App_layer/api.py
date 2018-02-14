from flask import Flask, request
from flask_restful import Resource, Api
import MySQLdb
from PythonModel import main
from db_interface import OR_inputs, OR_outputs
from flask_cors import CORS 

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

        cur.execute("select * from Courses;") # This line performs query and returns json result
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
    def get(self,skills_needed):
        inputs = OR_inputs(1)
        courses,ratings,prices = inputs.fetch_courses()
        matrix = inputs.fetch_courseSkill_matrix(len(courses))
        courses_recomended = main(courses,matrix,prices,ratings,skills_needed)
        outputs = OR_outputs(courses_recomended)
        return outputs
        

api.add_resource(Courses, '/courses')
api.add_resource(Create_plan, '/create_plan/<skills_needed>')

if __name__ == '__main__':
     app.run()