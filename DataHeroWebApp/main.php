<?php 

	session_start() ;
    
    include ("login.php");
	include ("connection.php") ;
    
    if (is_null($_SESSION['id'] ))
    {
        header ("Location:index.php") ;
    }
	
/*	$query = "SELECT `x` FROM `users` WHERE `id` = '".$_SESSION['id']."' LIMIT 1" ;
	
	$result = mysqli_query($link,$query) ;

	$row = mysqli_fetch_array ($result) ;
	
	$diary = $row['diary'] ;*/

?>



	<!DOCTYPE html>
	<html lang="en">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		<title>Data Hero</title>

		<!-- Bootstrap -->
		<link href="css/bootstrap.min.css" rel="stylesheet">

		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    
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
		<div class="navbar navbar-default navbar-fixed-top ">
			<div class="container">

				<div class="navbar-header pull-left">
					<a href="" class="navbar-brand">Data Hero</a>
				</div>
                <div class = "pull-left">
                    <ul class="navbar-nav nav ">
                        <li><a href="main.php" >Dashboard</a></li>
					</ul>
                </div>

				<div class=" pull-right">
					<ul class="navbar-nav nav ">
                        <li> <a href="manageProfile.php">My Profile</a></li>
						<li> <a href="index.php?logout=1">Log Out</a></li>
					</ul>
				</div>
			</div>
        </div>        
        <div class="container contentContainer" id="topContainer">

            <div class="row">
				<div class="col-md-6 col-md-offset-1" id="topRow">
                        <h1> Welcome to your dashboard<?php  {echo(", ABC".$fname);}?>!</h1>
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
                      <tbody> 
<!-- table body to be printed via php script: for loop with Table rows-->
                        <tr>
                          <th scope="row">Data Scientist</th>
                          <td>12/12/2018</td>
                           <td><a type="button" class="btn btn-success" href = "">View Plan</a></td>
                          <td><a type="button" class="btn btn-danger"  href = "">Delete</a></td>
                        </tr>
            
                        <tr>
                          <th scope="row">Data Engineer</th>
                          <td>01/01/1992</td>
                          <td><a type="button" class="btn btn-success" href = "">View Plan</a></td>
                          <td><a type="button" class="btn btn-danger"  href = "">Delete</a></td>
                        </tr>
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

			<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
			<!-- Include all compiled plugins (below), or include individual files as needed -->
			<script src="js/bootstrap.min.js"></script>


	</body>

	</html>