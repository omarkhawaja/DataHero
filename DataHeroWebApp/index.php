<?php 
include ("login.php"); 
include ("BootstrapCDN.php");
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Data Hero - Log In or Sign Up</title>

    <style>
        .navbar-brand {
            font-size: 1.8em;
        }

        #topContainer {
            background-image: url("Assets/bg3.jpeg");
            width: 100%;
            height: 100%;
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
        }

        #topRow {
            margin-top: 80px;
            text-align: center;
        }

        #topRow h1 {
            font-size: 300%;
        }

        .bold {
            font-weight: bold;
        }

        .marginTop {
            margin-top: 30px;
        }
        
        .marginBottom {
            margin-bottom: 0px;
        }

        .whiteColor {
            color: white;
        }

        .center {
            text-align: center;
        }
    </style>
</head>

<body data-spy="scroll" data-target=".navbar-collapse">

<div class="navbar navbar-default marginBottom">
    <div class="container-fluid">
        <div class="navbar-header">

            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
						<span class="sr-only">Toggle Navigation </span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
				</button>

            <a href="index.php" class="navbar-brand">Data Hero</a>
        </div>
        
        <div class="collapse navbar-collapse">
            <form method="POST" class="navbar-form navbar-right">
                
                <div class="form-group">
                    <input type="email" placeholder="Email" class="form-control" name="loginemail" id="loginemail" value="<?php echo addslashes($_POST['loginemail']); ?>">
                </div>

                <div class="form-group">
                    <input type="password" placeholder="Password" class="form-control" name="loginpassword" value="<?php echo addslashes($_POST['loginpassword']); ?>">
                </div>

                <div class="form-group">
                    <input type="submit" class="btn btn-success" name="submit2" value="Log In" />
                </div>

            </form>
        </div>
    </div>
</div>
    
    <div class="container" id="topContainer">

        <div class="row">
            <div class="col-md-6 col-md-offset-3" id="topRow">
                <h1 class="bold whiteColor">Data Hero</h1>
                <p class="lead whiteColor"> Becoming a Data Hero is a just few clicks away!</p>

                <?php
						if($error)
						{
							echo '<div class = "alert alert-danger">'.addslashes($error).'</div>' ;
						}
						if($success)
						{
							echo '<div class = "alert alert-success">'.addslashes($success).'</div>' ;
						}
					
						if($message)
						{
							echo '<div class = "alert alert-success">'.addslashes($message).'</div>' ;
						}
                
					?>

                    <p class="bold marginTop whiteColor"> Interested? Sign Up Below:</p>
                
                    <form method="POST" class="marginTop">

                        <div class="form-group">
                            <label for="email" class="whiteColor">Email Address</label>
                            <input type="email" class="form-control" placeholder="Your Email Address" name="email" id="email" value="<?php echo addslashes($_POST['email']); ?>" />

                        </div>

                        <div class="form-group">
                            <label for="password" class="whiteColor">Password</label>
                            <input type="password" class="form-control" placeholder="New Password" name="password" value="<?php echo addslashes($_POST['password']); ?>" />
                        </div>

                        <div>
                            <input type="submit" name="submit" value="Sign Up" class="btn btn-success btn-lg marginTop" />
                        </div>
                        
                    </form>
            </div>
        </div>
    </div>
</body>
</html>