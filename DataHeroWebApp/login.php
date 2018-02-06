<?php
    
	session_start() ;
	if ($_GET['logout']==1 AND $_SESSION['id'])
	{
		session_destroy () ;
		$message = "You have been logged out successfully. See you soon!" ;
	}

	include("connection.php") ;

    if($_POST['submit']=="Sign Up")
    {
        
        if (!$_POST['email']) 
        {
            $error.="<br/>Please enter your email" ;
			
        }
        else if (! filter_var( ($_POST['email']), FILTER_VALIDATE_EMAIL ) )
        {
            $error.="<br/>Please enter a valid email address" ;
        }
        
        if (!$_POST['password'])
        {
            $error.="<br/>Please enter a password" ;
        }
        
        else
        {
            if (strlen($_POST['password'])<8)
            {
                $error.="<br/>Password shoud have at least 8 characters" ;
            }
            if (!preg_match('`[A-Z]`', $_POST['password']))
            {
                $error.="<br/>Password shoud include at least 1 capital letter" ;
            }
        }
        
        if ($error)
        {
            $error = "There were error(s) in your signup details:".$error."<br/>";
        }
        
        else
        {			
			$query = "SELECT * FROM Users WHERE email = '".mysqli_real_escape_string ($link,$_POST['email']). "' " ;
			
			$result = mysqli_query ($link, $query) ;
			echo $numRes = mysqli_num_rows ($result) ;
			
			if ($numRes != 0)
			{
				$error = "This email address is already registered. Do you need to login instead?" ;
			}
			else
			{
				$query = "INSERT INTO Users (email, password) VALUES ('".mysqli_real_escape_string ($link,$_POST['email'])."', '". md5(md5($_POST['email']).$_POST['password']). "')" ;
				
				mysqli_query($link,$query) ;
				
				$success = "You have been signed up!" ;
				$_SESSION['id'] = mysqli_insert_id($link) ;
				
				header ("Location:main.php") ;	
			}				
        }  
    }
	if($_POST['submit2']=="Log In")
	{
			$query = "SELECT * FROM Users WHERE email = '".$_POST['loginemail']."' AND password ='".md5(md5($_POST['loginemail']).$_POST['loginpassword'])."' LIMIT 1";
        
			$result = mysqli_query($link,$query) ;
			$row = mysqli_fetch_array ($result) ;
        
			if ($row) 
			{
                $_SESSION['id'] = $row['id'] ;
                
                $query2 = "SELECT * FROM User_info WHERE id = '". $_SESSION['id']."'";
                $result2 = mysqli_query($link,$query2) ;
                $row2 = mysqli_fetch_array ($result2) ;
                if($row2)
                {
                    //get info from User_info Table here:
                    $_SESSION['fname'] = $row2['first_name'] ;
                    $_SESSION['lname'] = $row2['last_name'] ;
                }
				header ("Location:main.php") ;
			}
			else
			{
				$error =  "We could not find a user with that email and password. Please try again!<br/>New user? Please sign up below:" ;
			}
	}
?>