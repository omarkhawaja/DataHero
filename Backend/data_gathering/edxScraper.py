from bs4 import BeautifulSoup
import pickle
from data_classes import Course,Instructor,Error
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from pyvirtualdisplay import Display
import time
import re
import os

display = Display(visible=0,size=(800,600))
display.start()

def readCourses(fileName):
	data = {}
	with open(fileName, 'rb') as f:
		data = pickle.load(f)

	return data

def get_courseLinks():
	courseLinks = []
	driver = webdriver.Chrome(os.path.dirname(os.path.abspath(__file__)) + '/chromedriver')
	driver.get('https://www.edx.org/course?language=English')
	num_classes = 1759
	page = 0

	#keep scrolling down
	while page < num_classes:
		driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
		try:
			WebDriverWait(driver, 10).until(EC.visibility_of_element_located((By.XPATH, '//div[@class="loading"]')))
			page += 1
		except Exception as e:
			print(e)
			print(page)
			break

	#get all links
	courses = driver.find_elements_by_xpath('//div[@class="discovery-card-inner-wrapper"]/a[@class="course-link"]')

	for course in courses:
		courseLinks.append(course.get_attribute('href'))

	with open('coursesEdx.txt', 'wb') as f:
		pickle.dump(courseLinks, f)
	
	return courseLinks

def redo_scraping(courseLinks):
	pass

def get_course_details(courseLinks):
	for course_link in courseLinks:
		course_dict = {}
		browser = webdriver.Chrome(os.path.dirname(os.path.abspath(__file__)) + '/chromedriver')
		browser.get(course_link)
		soup = BeautifulSoup(browser.page_source, "html.parser")
		browser.quit()

		try:
			subject = soup.find('li',attrs={'data-field': 'subject'}).select('span.block-list__desc')[0].text.strip()
			subjects = ['Computer Science', 'Data Analysis & Statistics', 'Engineering', 'Math', 'Science']
			if subject in subjects:
				course_name = soup.select('h1.course-intro-heading')[0].text.strip()

				course_price = soup.find('li',attrs={'data-field': 'price'}).select('span.block-list__desc')[0].text.strip().replace('\n','').replace(' ','')

				descriptions = soup.find('div',{'class':'course-description wysiwyg-content'}).find_all('p')
				descriptionList = []
				for y in descriptions:
					if y.name == 'p':
						descriptionList.append(y.text)
				descriptions = soup.find('div',{'class':'course-info-list wysiwyg-content'}).find_all('li')
				for y in descriptions:
					if y.name == 'li':
						descriptionList.append(y.text)

				course_description = ' '.join(descriptionList)

				length_string =  soup.find('li',attrs={'data-field': 'length'}).select('span.block-list__desc')[0].text.strip()
				week_length = int(re.findall('\d+',length_string)[0])
				effort = soup.find('li',attrs={'data-field': 'effort'}).select('span.block-list__desc')[0].text.strip()
				effort_1 = int(re.findall('\d+',effort)[0])
				effort_2 = int(re.findall('\d+',effort)[1])
				length = ((effort_1 + effort_2) / 2) * week_length

				level_string = soup.find('li',attrs={'data-field': 'level'}).select('span.block-list__desc')[0].text.strip()
				level = 0 if level_string == 'Introductory' else 1

				#Instructor related fields
				x = soup.find('li',attrs={'class': 'list-instructor__item'})
				instructor_name = x.find('a').text.strip()
			else:
				continue

		except Exception as e:
			error = Error(
			url = course_link,
			message = e,
			course_providor_id = 1
			)
			error.save()
			continue

		instructor = Instructor(
		name = instructor_name,
		rating = None,
		num_reviews = None,
		num_students = None,
		num_courses = None
		)
		inst_id = instructor.save()
		print(inst_id)

		course = Course(
		name = course_name,
		description = course_description,
		rating = 5,
		price = course_price,
		num_ratings = None,
		language = 'English',
		length = length,
		inst_id = inst_id,
		url = course_link,
		course_providor_id = 3,
		level = level
		)
		course.save()

if __name__ == '__main__':
	#links = get_courseLinks()
	links = readCourses("coursesEdx.txt")
	get_course_details(links)
	display.stop()