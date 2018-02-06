import MySQLdb
import pickle

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
  courses = []
  ratings = []
  prices = []
  skills = []
  courseSkill_matrix = []

  def __init__(self, provider,rating=None):
      super(OR_inputs, self).__init__()
      self.provider = provider
      self.rating = rating

  def fetch_courses(self):
      try:
        if self.rating == None:
          cur.execute('''SELECT id,rating,price FROM Courses WHERE course_provider_id = {};'''.format(self.provider))
        else:
          cur.execute('''SELECT id,rating,price FROM Courses WHERE course_provider_id = {} AND rating >= {};'''.format(self.provider,self.rating))
        
        data = cur.fetchall()
        courses = [x[0] for x in data]
        ratings = [x[1] for x in data]
        prices = [x[2] for x in data]
    
        return courses,ratings,prices
      
      except Exception as e:
        print(e)

  def fetch_courseSkill_matrix(self):
    
    cur.execute('''select x.id,
                   case when y.skill_id is null then 0 else 1 end as skill_code 
                   from
                   (select x.id,s.id as 'skill' from Courses x cross join (select id from Skills order by id asc)s)x
                   left outer join
                   (select course_id,skill_id from Course_skills order by course_id,skill_id asc)y
                   on x.id = y.course_id and x.skill = y.skill_id;''')
    
    data_skills = cur.fetchall()
    all_skills = [x[1] for x in data_skills]

    cur.execute('''select count(distinct id) from Skills;''')
    num_skills_data = cur.fetchall()
    num_skills = num_skills_data[0][0]

    index = num_skills*int(len(courses))
    matrix = [list(all_skills[x:x+num_skills]) for x in range(0,index,num_skills)]

    return matrix

  def fetch_skills(self):
    try:
      cur.execute('''SELECT skill_id FROM Course_skills WHERE course_id in ({});'''.format(",".join(map(str, courses))))
      
      data = cur.fetchall()
      skills = [x[0] for x in data]

      return skills

    except Exception as e:
      print(e)

  def fetch_needed_skills(self,cur_skills):
    pass

if __name__ == '__main__':
  test = OR_inputs(1)
  courses,ratings,prices = test.fetch_courses()
  matrix = test.fetch_courseSkill_matrix()
  print(matrix)
