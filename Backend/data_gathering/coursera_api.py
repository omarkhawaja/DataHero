import json
import csv
import re
import requests
import pandas as pd
import math

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

if __name__ == "__main__":
	fetchData()
	courses_df = structureData()
	dataCourses = courses_df.query('sub_category == "algorithms" or sub_category == "data-analysis" or sub_category == "machine-learning" or sub_category == "math-and-logic"\
									or sub_category == "probability-and-statistics" or sub_category == "software-development" or sub_category == "bioinformatics"')
	print(len(dataCourses))

