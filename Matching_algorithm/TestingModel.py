from gurobipy import *
import pickle
import pandas as pd
from db_interface import OR_inputs

def missingSkills(skillsMapping,skills,neededSkills):
	indxs = []
	for skill in neededSkills:
		for key,value in skillsMapping.items():
			if value == skill:
				indxs.append(key)

	return [1 if i in indxs else 0 for i, v in enumerate(skills)]

def main(courses,courseSkills,cost,ratings):
    try:
        neededSkills = [0 for x in range(10)]
        neededSkills[0] = 1
        neededSkills[8] = 1
        print(neededSkills)
        #neededSkills[109] = 1
        #neededSkills[200] = 1
        #neededSkills[66] = 1
        #neededSkills[4] = 1
    
    

        
        # Create a new model
        m = Model()

        budget = 2000

        numSkills = len(courseSkills[0])
        numCourses = len(courses)

        # Create Model Variables
        x = {} # binary variables for courses. X(i) = 1 if Course i is selected. 0 OW
        for i in range(numCourses):
            x[i] = m.addVar(vtype=GRB.BINARY, name="x%d" % i)
            #test["x%d" % i] = i

        m.update()

        # Set Objective Function
        m.setObjective(quicksum((x[i] * ratings[i]) for i in range(numCourses)), GRB.MINIMIZE)

        # Set Partitioning Constraints / Modified to only work with "neededSkills"
        for s in range(numSkills):
            #print s
            m.addConstr(quicksum(x[i] * courseSkills[i][s] for i in range(numCourses)) >= neededSkills[s])

        # Budget Constraint
        m.addConstr(quicksum(cost[i]*x[i] for i in range(numCourses)) <= budget)

        # Run Model
        m.optimize()

        # OUTPUT
        

        for v in m.getVars():
            if v.x > 0:
                name = v.varName
                #courseDescription = df.loc[df['course_name'] == str(name)]['description'].values[0]
                #courseInstructor = df.loc[df['course_name'] == str(name)]['instructor_name'].values[0]
                #coursePrice = df.loc[df['course_name'] == str(name)]['price'].values[0]
                #courseRating = df.loc[df['course_name'] == str(name)]['rating'].values[0]
                print("Course name: {}".format(name))
                #print("Course description: {}".format(courseDescription))
                #print("Course instructor: {}".format(courseInstructor))
                #print("Course price: {}".format(coursePrice))
                #print("Course rating: {}".format(courseRating))
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                #print('%s %g' % (v.varName, v.x))
        print('Obj: %g' % m.objVal)

    except GurobiError as e:
        print('Error code ' + str(e.errno) + ": " + str(e))

    except AttributeError:
        print('Encountered an attribute error')


if __name__ == "__main__":

    #test = OR_inputs(1)
    #courses,ratings,prices = test.fetch_courses()
    #matrix = test.fetch_courseSkill_matrix(len(courses))
    #cleaned_prices = [float(s.split("$",1)[1]) if '$' in s else 14.99 for s in prices]
    
    courses = [0,1,2,3,4]
    prices  = [10,10,10,10,10]
    ratings = [1,2,3,4,5]
    skills = [1,2,3,4,5,6,7,8,9,10]
    courseSkills = [[1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                    [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                    [1, 0, 0, 0, 0, 0, 0, 0, 1, 1]]
    
    main(courses,courseSkills,prices,ratings)

    