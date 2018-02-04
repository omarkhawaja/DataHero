<?php 
    include ("login.php");
	include ("connection.php");
    include ("navBar.php");

    if (is_null($_SESSION['id'] )) header("Location:index.php") ;
?>
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Data Hero</title>
        
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
                <div class="col-md-6 col-md-offset-2" id="SecondRow">
                    <h2> My Plans: </h2>
                    <br/>
                </div>
			</div>
            
             <div class = "row">
                <div class="col-md-6 col-md-offset-2" id="ThirdRow">
                    <table class="table">
                    <thead>
                        <tr>
                          <th scope="col">Job Title</th>
                          <th scope="col">Date Generated</th>
                          <th scope="col"></th>
                          <th scope="col"></th>
                        </tr>
                    </thead>
<!-- table body to be printed via php script: loop with table rows-->
                    <tbody>
        <?php
            $query = "SELECT * FROM Plans WHERE `user_id` = '".$_SESSION['id']."'" ;
            $result = mysqli_query($link,$query) ;	
            if (mysqli_num_rows($result) > 0) 
            {
                while($row = mysqli_fetch_assoc($result))
                {
                    ?>
                        <tr>
                            <th scope="row"><?php echo($row['position']);?></th>
                            <td>12/12/2018</td>
                            <td> 
                              <form action = "viewPlan.php?<?php echo($row['id']);?>" method="post">
                                <input type="hidden" name="ViewID" value="<?php echo $row['id']; ?>">
                                <input type ="submit" class = "btn btn-success" value = "View Plan">
                              </form>
                            </td>
                            <td> 
                              <form action = "deletePlan.php?<?php echo($row['id']);?>" method="post">
                                <input type="hidden" name="DeleteID" value="<?php echo $row['id']; ?>">
                                <input type ="submit" class = "btn btn-danger" value = "Delete">
                              </form>
                            </td> 
                        </tr>
                    <?php
                }
            }
            else
            {
                ?>
                    <tr>
                        <th scope="row">You don't have any plans!</th>
                    </tr>  
                <?php
            }
        ?> 
                      </tbody>
                    </table>
                </div> 
			</div>

            <div class = "row">
                <div class="col-md-6 col-md-offset-2 " id="FourthRow">
                <a class="btn btn-primary btn-lg" href="GeneratePlan.php" role="button">Create a New Plan</a>
                </div>
            </div>
            
        </div>
	</body>
	</html>