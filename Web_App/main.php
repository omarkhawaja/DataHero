<?php 
    include ("Connection/login.php");
    include ("Connection/navBar.php");

    if (is_null($_SESSION['id'] )) header("Location:index.php") ;

    $_SESSION['user_plans'] = "";
    $user_plans_ep = "plans/user/id=".$_SESSION['id'] ;
    $response = GET_API_Request($user_plans_ep) ;
    $_SESSION['user_plans'] = $response;


?>
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Data Hero - Dashboard</title>
        
		<style>
			.navbar-brand {
				font-size: 1.8em;
				margin-right: 30px;
			}
			#topContainer {
				background-image: url("background.jpg");
				width: 100%;
				background-size: cover;
				background-position: center;
				height : 100%;
			}
			
			#topRow {
				margin-top:     60px;
                margin-bottom:  60px;
				text-align: left;
			}
            #FourthRow {
                margin-top:     60px;
            }
			
			.h1 {
				font-size: 150%;
			}
			
			.bold {
				font-weight: bold;
			}
			
			.marginTop {
				margin-top: 30px;
			}
			
			.center {
				text-align: center;
			}
			
			.title {
				margin-top: 100px;
				font-size: 400%;
			}
            
			.marginBottom {
				margin-bottom: 30px;
			}
		</style>
	</head>
        
	<body data-spy="scroll" data-target=".navbar-collapse">

        <div class="container contentContainer" id="topContainer">
            <div class="row">
				<div class="col-md-6 col-md-offset-1" id="topRow">
                        <h1> Welcome to your dashboard<?php if($_SESSION['fname']) echo(', '.$_SESSION['fname'].'!'); else echo("!");?></h1>
				</div>
            </div>
            
            <div  class = "row">
                <div class="col-md-8 col-md-offset-2" id="SecondRow">
                    <h2> My Plans: </h2>
                    <br/>
                </div>
			</div>
            
             <div class = "row">
                 <div class="col-md-8 col-md-offset-2" id="ThirdRow">
                <table class="table">
                    <thead class="thead-dark">
                        <tr>
                            <th  scope="col">Plan</th>
                            <th class = "center" scope="col">Position</th>
                            <th class = "center" scope="col">Technologies Covered</th>
                            <th  class = "center" scope="col">Creation Date</th>
                            <th class = "right" scope="col"></th>
                        </tr>
                    </thead>
<!-- table body to be printed via php script: loop with table rows-->
                    <tbody>
        <?php
            if (count($_SESSION['user_plans']) > 0) 
            {
                $planID = 0;
                foreach ($_SESSION['user_plans'] as $plan)
                {
                    $position  = $plan[0]['position'];
                    $tech_covered = ucwords(implode(", ", $plan[0]['tech_combo']));
                    $plan_date = $plan[0]['time_stamp'];
                    $total_price  = $plan[0]['total_price'];
                    $total_length = $plan[0]['total_length'] ;          
                    ?>
                        <tr>
                            <th scope="row"><?php echo("Plan ".($planID + 1)); ?></th>
                            <td class="center"><?php echo($position); ?></td>
                            <td class="center"><?php echo($tech_covered); ?></td>
                            <td class="center"><?php echo($plan_date); ?></td>
                            <td>
                                <form   action="viewplan2.php" method="POST">
                                    <input type="hidden" name="view_plan_id" value="<?php echo($planID);?>">
                                    <input type="submit" class="btn btn-success" value="View Plan">
                                </form>
                                
                            </td>
                        </tr>
                    <?php
                    $planID++;
                }
            }
            else
            {
                ?>
                    <tr>
                        <th scope="row">You don't have any saved plans!</th>
                    </tr>  
                <?php
            }
        ?> 
                      </tbody>
                    </table>
                </div> 
			</div>
            <div class = "row">
                <div class="col-md-6 col-md-offset-5" id="FourthRow">
                <a class=" btn btn-primary btn-lg" href="GeneratePlan.php" role="button">Create a New Plan</a>
                </div>
            </div>
            <br/>
            <br/>
            
        </div>
	</body>
	</html>