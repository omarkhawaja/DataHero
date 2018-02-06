#from gurobipy import *
from DataHero.Backend.OR_algorithm.db_interface import OR_inputs

def missingSkills(skillsMapping,skills,neededSkills):
	indxs = []
	for skill in neededSkills:
		for key,value in skillsMapping.items():
			if value == skill:
				indxs.append(key)

	return [1 if i in indxs else 0 for i, v in enumerate(skills)]

def main(courses,skills,courseSkills,cost,ratings,neededSkills):
    try:
        m = Model()

        budget = 2000
        numSkills = len(skills)
        numCourses = len(courses)

        # Create Model Variables
        x = {} # binary variables for courses. X(i) = 1 if Course i is selected. 0 OW
        for i in range(numCourses):
            x[i] = m.addVar(vtype=GRB.BINARY, name="x%d" % i)
            test["x%d" % i] = i

        m.update()

        # Set Objective Function
        m.setObjective(quicksum((x[i] * ratings[i]) for i in range(numCourses)), GRB.MINIMIZE)

        # Set Partitioning Constraints / Modified to only work with "neededSkills"
        for s in range(numSkills):
            m.addConstr(quicksum(x[i] * courseSkills[i][s] for i in range(numCourses)) >= neededSkills[s])

        # Budget Constraint
        m.addConstr(quicksum(cost[i]*x[i] for i in range(numCourses)) <= budget)

        # Run Model
        m.optimize()

        # OUTPUT
        for v in m.getVars():
            if v.x > 0:
                name = courseMappings[test[v.varName]]
                courseDescription = df.loc[df['course_name'] == str(name)]['description'].values[0]
                courseInstructor = df.loc[df['course_name'] == str(name)]['instructor_name'].values[0]
                coursePrice = df.loc[df['course_name'] == str(name)]['price'].values[0]
                courseRating = df.loc[df['course_name'] == str(name)]['rating'].values[0]
                print "Course name: {}".format(name)
                print "Course description: {}".format(courseDescription)
                print "Course instructor: {}".format(courseInstructor)
                print "Course price: {}".format(coursePrice)
                print "Course rating: {}".format(courseRating)
                print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                #print('%s %g' % (v.varName, v.x))
        print 'Obj: %g' % m.objVal

    except GurobiError as e:
        print 'Error code ' + str(e.errno) + ": " + str(e)

    except AttributeError:
        print 'Encountered an attribute error'


if __name__ == "__main__":
    skillsNeeded = ['data science','deep learning','machine learning','asdfsd']
    skillsInUdemy = []
    
    #for skill in skillsNeeded:
        #for key,value in skillsMappings.items():
            #if value == skill:
                #skillsInUdemy.append(skill)
    
    #skillsArray = missingSkills(skillsMappings,skills,skillsInUdemy)   
    #main(courses,skills,courseSkills,cost,ratings,skillsArray)