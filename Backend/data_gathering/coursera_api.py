import json
import csv
import re
import requests
import pandas as pd
import math
from rake_nltk import Rake
import argparse
from rakeImp import getTable
from langdetect import detect

pd.set_option('display.max_colwidth', -1)

#array to contain all fetched courses
courses = []

def getAll(request):
	return requests.get("{}".format(request)).json()

#extracts fields from coursera JSON response and appends to courses list
def extractFields(entries):
	course = {}
	for entry in entries:
		course["name"] = entry["name"]
		course["description"] = entry["description"]
		course["time"] = entry["workload"]
		course["category"] = entry["domainTypes"]
		course["language"] = entry["primaryLanguages"]
		courses.append(course)
		course = {}

#uses Rake lib to extract keywords from a course description 
def extractKeyWords(description):
	r = Rake() # Uses stopwords for english from NLTK, and all puntuation characters.
	r.extract_keywords_from_text(str(description))
	print(r.get_ranked_phrases_with_scores())

#loading the data from the coursera API into a structured df
def structureData():
	courses_df = pd.DataFrame()
	courses_df['course_name'] = list(map(lambda course_data: course_data['name'], courses))
	courses_df['description'] = list(map(lambda course_data: course_data['description'], courses))
	courses_df['time'] = list(map(lambda course_data: course_data['time'], courses))
	courses_df['category'] = list(map(lambda course_data: str(course_data['category'][0]['domainId']) if course_data.get('category') else "", courses))
	courses_df['sub_category'] = list(map(lambda course_data: str(course_data['category'][0]['subdomainId']) if course_data.get('category') else "", courses))
	courses_df['language'] = list(map(lambda course_data: course_data['language'], courses))
	return courses_df

#fetching all courses from coursera via their API 
def fetchData():
	request = "https://api.coursera.org/api/courses.v1?fields=description,workload,domainTypes,primaryLanguages"

	response = getAll(request)
	nextPage = response["paging"]["next"]
	lastPage = int(math.floor(response["paging"]["total"]/100)*100)
	extractFields(response["elements"])

	while int(nextPage) <= lastPage:
		request = "https://api.coursera.org/api/courses.v1?start={}&fields=description,workload,domainTypes,primaryLanguages".format(nextPage)
		response = getAll(request)
		extractFields(response["elements"])
		if "next" in response["paging"]:
			nextPage = response["paging"]["next"]
		else:
			nextPage = lastPage + 1

#loading stackoverflow tags from file
def loadKeywords():
	tags = []
	with open('stackoverflow_tags.csv','r') as infile:
		reader = csv.reader(infile)
		for tag in reader:
			tags.append(str(tag).replace("'","").replace("[","").replace("]",""))
	
	return tags

def stackoverflowScore():
	courses_df = pd.read_csv('coursera_courses.csv',encoding = "utf8")
	tags = loadKeywords()
	desc = str(courses_df.loc[courses_df['course_name'] == 'Machine Learning']['description']).split(".")
	for sentence in desc:
		for word in sentence.split():
			for tag in tags:
				if tag == word:
					print(tag)	

def main():

	parser = argparse.ArgumentParser(description="Coursera course analysis")
	parser.add_argument("-option",help="1 to fetch and save the courses to a csv file,2 to fetch keywords with rake, 3 data courses analysis, 4 output of courses, 5 course scores")
	parser.add_argument("-course",help="name of course to fetch keywords for",nargs='+')
	args = parser.parse_args()
 
	if args.option == "1": 
		fetchData()
		courses_df = structureData()
		courses_df.to_csv('coursera_courses.csv',encoding="utf8")

	elif args.option == "2":
		courses_df = pd.read_csv('coursera_courses.csv',encoding = "utf8")
		desc = courses_df.loc[courses_df['course_name'] == '{}'.format(' '.join(args.course).strip("'"))]['description']
		print(desc)
		extractKeyWords(desc)

	elif args.option == "3":
		courses_df = pd.read_csv('coursera_courses.csv',encoding = "utf8")
		dataCourses = courses_df.query('sub_category == "algorithms" or sub_category == "data-analysis" or sub_category == "machine-learning" or sub_category == "math-and-logic"\
			or sub_category == "probability-and-statistics" or sub_category == "software-development" and language == "en"')

		print("Total data related courses: {}".format(dataCourses['course_name'].count()))
		print("Total data related courses with no time field: {}".format(dataCourses[dataCourses['time'].isnull()]['course_name'].count()))		

	elif args.option == "4":
		courses_df = pd.read_csv('coursera_courses.csv',encoding = "utf8")
		dataCourses = courses_df.query('sub_category == "algorithms" or sub_category == "data-analysis" or sub_category == "machine-learning" or sub_category == "math-and-logic"\
			or sub_category == "probability-and-statistics" or sub_category == "software-development" or sub_category == "bioinformatics"')

		with open('test.txt','w') as outfile:
			for index, row in dataCourses.iterrows():
				if detect(row['course_name']) == 'en' and detect(row['description']) == 'en':
					name = row['course_name']
					category = row['sub_category']
					keywords = getTable(row['description'])
					time = row['time']
					try:
						outfile.write("{}|{}|{}|{}".format(name,category,time,list(map(lambda x: x[0],keywords))) + "\n")
					except:
						pass

	elif args.option == "5":
		skills = []
		scores = []
		course_scores = {}

		courses_df = pd.read_csv('coursera_courses.csv',encoding = "utf8")
		dataCourses = courses_df.query('sub_category == "algorithms" or sub_category == "data-analysis" or sub_category == "machine-learning" or sub_category == "math-and-logic"\
			or sub_category == "probability-and-statistics" or sub_category == "software-development" or sub_category == "bioinformatics"')

		#getting unique skills
		for index, row in dataCourses.iterrows():
			if detect(row['course_name']) == 'en' and detect(row['description']) == 'en':
				keywords = getTable(row['description'])
				name = row['course_name']
				for skill in keywords:
					if skill not in skills:
						skills.append(skill)
 
		for index, row in dataCourses.iterrows():
			if detect(row['course_name']) == 'en' and detect(row['description']) == 'en':
				name = row['course_name']
				courseSkills = getTable(row['description'])
				for skill in skills:
					if skill in courseSkills:
						scores.append("X")
					else:
						scores.append("")
				course_scores[name] = scores
				scores = []

		with open('dict.csv','w', encoding= 'utf-8') as outfile1:
			for key,value in course_scores.items():
				thing = '{}^{}'.format(key,value)
				print(f"{thing}", file=outfile1)

		with open('skills.csv','w', encoding= 'utf-8') as outfile:
			for skill in skills:
				thing = '{}'.format(skill)
				print(f"{thing}", file=outfile)
	else:
		pass
		#count for main categories
		#print(courses_df.groupby('category').agg('count'))
		#count for sub categories
		#print(courses_df.groupby('sub_category').agg('count'))
		 
		#exploring description of a data science course
		#print(courses_df.loc[courses_df['category'] == 'data-science'].iloc[2]['description'])
		#desc = courses_df.loc[courses_df['course_name'] == 'Neural Networks for Machine Learning']['description']
		#print(desc)
		#extractKeyWords(desc)

if __name__ == "__main__":
	main()