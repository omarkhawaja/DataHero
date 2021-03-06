'''
When running this script make sure that the chrmodriver that is being used is for your specific OS

The pyvirtualdsiplay allows the scraper to run on the GCP VM using a headless chrome browser

Todo: add error catching and logging
	  add proper display start and stop
'''
from bs4 import BeautifulSoup
from selenium import webdriver
import requests
import time
import pickle
import os
from data_classes import Course,Instructor,Error
from pyvirtualdisplay import Display
import argparse

#display = Display(visible=0,size=(800,600))
#display.start()

def loadJSPage(url):
	browser = webdriver.Chrome(os.path.dirname(os.path.abspath(__file__)) + '/chromedriver')#,chrome_options=options)
	browser.get(url)
	#replace with wait until specific element ID is loaded
	time.sleep(5)
	soup = BeautifulSoup(browser.page_source, "html.parser")
	browser.close()
	return soup

def getCourses(fileName):
	courseLinks = []

	baseURL = "https://www.udemy.com"

	#Currently there are 44 pages of courses, add a function later on to fetch this number so it doesnt
	#have to be maintained
	for i in range(1,44):
		base = "https://www.udemy.com/courses/business/data-and-analytics/all-courses/?p={}".format(i)
		soup = loadJSPage(base)

		links = soup.find_all('a')
		for link in links:
			if link.get('data-purpose') == "search-course-card-title":
				courseLinks.append("{}{}".format(baseURL,link.get('href')))

	with open(fileName, 'wb') as f:
		pickle.dump(courseLinks, f)

	return courseLinks

def readCourses(fileName):
	data = {}
	with open(fileName, 'rb') as f:
		data = pickle.load(f)

	return data

def scrapeCourses(mode='init'):

	if mode == 'init':
		courseLinks = getCourses("coursesUdemy.txt")
	elif mode == 'read':
		courseLinks = readCourses("coursesUdemy.txt")
	elif mode == 'redo':
		errs = Error()
		courseLinks = errs.rescape()

	#now we are at the course page	
	for link in courseLinks:
		print(link[0])
		if mode == 'redo':
			soup = loadJSPage(link[0])
		else:
			soup = loadJSPage(link)
		descriptionList = []

		#Codes for the html table containing instructor info, and the row codes
		#these might be changed by the site
		instructor_html_table_class_code = '1eL5l'
		instructor_html_table_row_code = '2Kwe1'

		try:
			course_name = soup.select('h1.clp-lead__title')[0].text.strip()

			course_price = soup.select("span.price-text__current")[0].text.strip()

			x = soup.find('div',{'class':'rate-count'})
			ratingCountString = x.find('span',{'class': 'tooltip-container tooltip--rate-count-container'}).contents[2].strip()

			course_num_rating = ratingCountString
			course_rating = x.get_text().strip()[:3]

			descriptions = soup.find('div',{'class':'js-simple-collapse js-simple-collapse--description'}).find('div',{'class':'js-simple-collapse-inner'})
			descriptions.find_all('p')
			for y in descriptions:
				if y.name == 'p':
					descriptionList.append(y.text)

			course_description = ' '.join(descriptionList)

			length = soup.select("span.curriculum-header-length")[0].text.strip()

			#Instructor related fields
			x = soup.find('div', {'class': 'instructor'})
			instructor_name = x.find('a').text.strip()

			x = soup.find('div', {'class': 'instructor--instructor__stats--{}'.format(instructor_html_table_class_code)})
			trs = x.find_all('tr')

			instructor_rating = float(trs[0].find_all('span', {'class': 'instructor--instructor__stat-value--{}'.format(instructor_html_table_row_code)})[0].text.strip().replace(" ",""))
			instructor_num_reviews = int(trs[1].find_all('span', {'class': 'instructor--instructor__stat-value--{}'.format(instructor_html_table_row_code)})[0].text.strip().replace(",","").replace(" ",""))
			instructor_num_students = int(trs[2].find_all('span', {'class': 'instructor--instructor__stat-value--{}'.format(instructor_html_table_row_code)})[0].text.strip().replace(",","").replace(" ",""))
			instructor_num_courses = int(trs[3].find_all('span', {'class': 'instructor--instructor__stat-value--{}'.format(instructor_html_table_row_code)})[0].text.strip().replace(" ",""))
		
		except Exception as e:
			error = Error(
			url = link,
			message = e,
			course_providor_id = 1
			)
			error.save()
			continue

		instructor = Instructor(
		name = instructor_name,
		rating = instructor_rating,
		num_reviews = instructor_num_reviews,
		num_students = instructor_num_students,
		num_courses = instructor_num_courses
		)
		inst_id = instructor.save()
		print(inst_id)

		course = Course(
		name = course_name,
		description = course_description,
		rating = course_rating,
		price = course_price,
		num_ratings = course_num_rating,
		language = None,
		length = length,
		inst_id = inst_id,
		url = link,
		course_providor_id = 1,
		level = None
		)
		course.save()

	#display.stop()

if __name__ == "__main__":

	#parsing command line input
	parser = argparse.ArgumentParser(description="Udemy data related course scraper.")
	parser.add_argument("-mode",help="init,read, or redo")
	args = parser.parse_args()

	scrapeCourses(args.mode)