from gurobipy import *

def run_algorithm(courses,courseSkills,courseLevel,cost,ratings,lengths,timeAllocation,budget,neededSkills,skillLvl_needed,course_scores):
    try:
        relaxed = 0
        normalized_denominator = sum([(float(x)*float(y)) for x,y in zip(cost,lengths)])
        normalized_cost_and_length_score = [((float(x)*float(y))/normalized_denominator) for x,y in zip(cost,lengths)]

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
        m.setObjective(quicksum((x[i]*((1-course_scores[i])))  for i in range(numCourses)), GRB.MINIMIZE)
        # Set Partitioning Constraints / Modified to only work with "neededSkills"
        for s in range(numSkills):
            m.addConstr(quicksum(x[i] * courseSkills[i][s] for i in range(numCourses)) >= neededSkills[s])
        # Course Level Constraint:
        for s in range(numSkills):
            m.addConstr(quicksum(x[i] * courseLevel[i][s] for i in range(numCourses)) >= skillLvl_needed[s])

        # Budget Constraint
        m.addConstr(quicksum(cost[i]*x[i] for i in range(numCourses)) <= budget, "Budget")
        # Time Allocation Constraint:
        m.addConstr(quicksum(lengths[i]*x[i] for i in range(numCourses))<= timeAllocation, "Time")
        # Run Model
        m.optimize()

        courses_recomended = []

        #Output
        for v in m.getVars():
            if v.x > 0:
                courses_recomended.append(courses[int(v.varName.split("x",1)[1])]) #x386

        return relaxed,courses_recomended

    #model is infeasible
    except Exception as e:
        relaxed = 1
        if m.status == GRB.Status.INFEASIBLE:
            print("Model is infeasible. Calculating IIS..")
            m.computeIIS()
            for c in m.getConstrs():
                if c.constrName == "Budget":
                    print('Increased Budget Constraint by 25. re-running alogirthm..')
                    budget = budget + 25
                    timeAllocation = timeAllocation + 25
                    x,y = run_algorithm(courses,courseSkills,courseLevel,cost,ratings,lengths,timeAllocation,budget,neededSkills,skillLvl_needed,course_scores)
                    break
                elif c.constrName == "Time":
                    print('Increased Time Allocation Constraint by 25. re-running alogirthm..')
                    timeAllocation = timeAllocation + 25
                    budget = budget + 25
                    x,y = run_algorithm(courses,courseSkills,courseLevel,cost,ratings,lengths,timeAllocation,budget,neededSkills,skillLvl_needed,course_scores)
                    break
        return relaxed,y
        
if __name__ == "__main__":
    pass