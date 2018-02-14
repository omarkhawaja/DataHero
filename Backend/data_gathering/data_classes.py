#Add category, region, and code fields to table

import MySQLdb

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

class Course(object):
    def __init__(self, name, description, price, rating, num_ratings, language, length, inst_id, url, course_providor_id):
        super(Course, self).__init__()
        self.name = name
        self.description = description
        self.price = price
        self.rating = rating
        self.num_ratings = num_ratings
        self.language = language
        self.length = length
        self.inst_id = inst_id
        self.url = url
        self.course_providor_id = course_providor_id

    def save(self):
        if self.exists() == False:
            try:
              cur.execute('''INSERT INTO Courses (name, description, price, rating, num_ratings, language, length, instructor_id, url, course_provider_id) 
                  VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)''', (
                self.name,
                self.description,
                self.price,
                self.rating,
                self.num_ratings,
                self.language,
                self.length,
                self.inst_id,
                self.url,
                self.course_providor_id
              ))
              conn.commit()
            except e:
              print(e)
        else:
            print("Record already exists")

    def exists(self):
        try:
            cur.execute('''SELECT EXISTS(SELECT * FROM Courses WHERE name = '{}');'''.format(self.name))
            return True if cur.fetchone()[0] == 1 else False
        except:
            return False

class Instructor(object):
    def __init__(self, name, rating, num_reviews, num_students, num_courses):
        super(Instructor, self).__init__()
        self.name = name
        self.rating = rating
        self.num_reviews = num_reviews
        self.num_students = num_students
        self.num_courses = num_courses

    def save(self):
        inst_id = self.exists()
        if inst_id == None:
            try:
              cur.execute('''INSERT INTO Course_instructors (name, rating, num_reviews, num_students, num_courses) 
                  VALUES (%s, %s, %s, %s, %s)''', (
                self.name,
                self.rating,
                self.num_reviews,
                self.num_students,
                self.num_courses
              ))
              conn.commit()
              return cur.lastrowid
            except e:
              print(e)
        else:
            print("Record already exists")
            return inst_id

    def exists(self):
        try:
            cur.execute('''SELECT id FROM Course_instructors WHERE name = '{}';'''.format(self.name))
            return cur.fetchone()[0]
        except:
            return None

class Error(object):
    def __init__(self, url=None, message=None, course_providor_id=None):
        super(Error, self).__init__()
        self.url = url
        self.message = message
        self.course_providor_id = course_providor_id

    def save(self):
        cur.execute('''INSERT INTO Scraper_logs (url, error_message, course_provider_id) 
          VALUES (%s, %s, %s)''', (
        self.url,
        self.message,
        self.course_providor_id
        ))
        conn.commit()

    def rescape(self,date=None):
        cur.execute('''SELECT url FROM Scraper_logs WHERE id > 430;''')
        return cur.fetchall()

if __name__ == '__main__':
  pass