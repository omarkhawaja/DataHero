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
        #temporary manual selection of skills needed
        neededSkills = [0 for x in range(len(courseSkills[0]))]
        #neededSkills[0] = 1
        neededSkills[23] = 1
        neededSkills[109] = 1
        neededSkills[35] = 1
        neededSkills[26] = 1
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
        
        #Output
        for v in m.getVars():
            if v.x > 0:
                courses.append(v.varName.split("x",1)[1]) #x386

        print('Obj: %g' % m.objVal)

    except GurobiError as e:
        print('Error code ' + str(e.errno) + ": " + str(e))

    except AttributeError:
        print('Encountered an attribute error')


if __name__ == "__main__":

    test = OR_inputs(1)
    courses,ratings,prices = test.fetch_courses()
    matrix = test.fetch_courseSkill_matrix(len(courses))
    main(courses,matrix,prices,ratings)

    