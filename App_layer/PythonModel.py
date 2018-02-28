from gurobipy import *

def run_algorithm(courses,courseSkills,courseLevel,cost,ratings,lengths,timeAllocation,budget,neededSkills,skillLvl_needed):
    try:
        # Create a new model
        m = Model()

        numSkills = len(courseSkills[0])
        numCourses = len(courses)
        
        # Create Model Variables
        x = {} # binary variables for courses. X(i) = 1 if Course i is selected. 0 OW
        for i in range(numCourses):
            x[i] = m.addVar(vtype=GRB.BINARY, name="x%d" % i)

        m.update()
        # Set Objective Function
        m.setObjective(quicksum((x[i] * ratings[i])  for i in range(numCourses)), GRB.MINIMIZE)
        # Set Partitioning Constraints / Modified to only work with "neededSkills"
        for s in range(numSkills):
            m.addConstr(quicksum(x[i] * courseSkills[i][s] for i in range(numCourses)) >= neededSkills[s])
        # Course Level Constraint:
        for s in range(numSkills):
            m.addConstr(quicksum(x[i] * courseLevel[i][s] for i in range(numCourses)) >= skillLvl_needed[s])

        # Budget Constraint
        m.addConstr(quicksum(cost[i]*x[i] for i in range(numCourses)) <= budget)
        # Time Allocation Constraint:
        m.addConstr(quicksum(lengths[i]*x[i] for i in range(numCourses))<= timeAllocation)
        # Run Model
        m.optimize()

        courses_recomended = []

        #Output
        for v in m.getVars():
            if v.x > 0:
                courses_recomended.append(courses[int(v.varName.split("x",1)[1])]) #x386
        return courses_recomended

    except GurobiError as e:
        print('Error code ' + str(e.errno) + ": " + str(e))

    #model is infeasible
    except AttributeError:
        budget = budget + 5
        run_algorithm(courses,courseSkills,courseLevel,cost,ratings,lengths,timeAllocation,budget,neededSkills,skillLvl_needed)


if __name__ == "__main__":
    pass