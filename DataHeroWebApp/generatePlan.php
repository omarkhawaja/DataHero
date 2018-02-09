<?php 

    include ("login.php");
	include ("connection.php") ;
    include ("navBar.php");
    
    if (is_null($_SESSION['id'])) header("Location:index.php") ;
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Data Hero - Generate New Plan</title>

    <style>
        .navbar-brand {
            font-size: 1.8em;
            margin-right: 30px;
        }

        #topRow {
            margin-top: 60px;
            margin-bottom: 60px;
            text-align: left;
        }

        .h1 {
            font-size: 200%;
        }

        table.borderless td,
        table.borderless th {
            border: none !important;
        }
    </style>
</head>

<body data-spy="scroll" data-target=".navbar-collapse">

    <div class="container contentContainer" id="topContainer">
        <div class="row">
            <div class="col-md-6 col-md-offset-1" id="topRow">
                <h2>Generate a new plan:</h2>
            </div>
        </div>


        <div class="row">
            <div class="col-md-6 col-md-offset-2" id="secondRow">

                <form>
                    <div class="form-group">
                        <label for="jobTitle"><h3>Select Job Title:</h3></label>

                        <select class="form-control" id="jobTitle" onchange="UpdateSkills()">
                            <option selected>----</option>
                            
                            <?php    
                            $query = "SELECT `position` FROM Positions" ;
                            $result = mysqli_query($link,$query) ;	
                            if (mysqli_num_rows($result) > 0) 
                            {
                                while($positions = mysqli_fetch_assoc($result))
                                {
                                    echo("<option>".$positions['position']."</option>");
                                }
                            }
                            ?>
                        </select>
                    </div>

                    <script>
                        //Write JS script to output relevant skills based on "jobTitle" selection:
                        function UpdateSkills() {

                            var SelectedJobTitle = document.getElementById("jobTitle").value;
                            if (SelectedJobTitle == "Data Analyst") {
                                document.getElementById.innerHTML = ""

                            } else if (SelectedJobTitle == "") {
                                document.getElementById.innerHTML = ""
                            } else if (SelectedJobTitle == "") {
                                document.getElementById.innerHTML = ""

                            } else if (SelectedJobTitle == "") {
                                document.getElementById.innerHTML = ""
                            }
                        }
                    </script>

                    <br/>

                    <!-- table body to be printed via php script: loop with table rows-->
                    <?php    
                    $query = "SELECT * FROM Positions" ;
                    $result = mysqli_query($link,$query) ;	
                    if (mysqli_num_rows($result) > 0) 
                    {   
                        while($positions = mysqli_fetch_assoc($result))
                        {
                    ?>
                    <div class="form-group">
                        <table class="table" id="<?php echo($positions['position']);?>Skills">
                            <thead>
                                <tr>
                                    <th scope="col">Skill</th>
                                    <th scope="col">Current Level</th>
                                </tr>
                            </thead>
                            <tbody>
                    <?php
                    $query2 = "SELECT * FROM `Skills` WHERE `id` IS NOT NULL AND `id` IN 
                    (SELECT `skill_id` FROM `Position_skills` WHERE `position_id` = ".$positions['id'].");";
                    $result2 = mysqli_query($link,$query2) ;
                    if (mysqli_num_rows($result2) > 0) 
                    {
                        while($skills = mysqli_fetch_assoc($result2))
                        {
                            ?>
                                    <tr>
                                        <div class="form-group" name="<?php echo($skills['skill']);?>">
                                            <td>
                                                <label class="radio-inline"><?php echo(ucwords($skills['skill']));?></label>
                                            </td>
                                            <td>
                                                <label class="radio-inline">
                        <input type="radio" name="<?php echo($skills['id']);?>" value = "1">no
                        </label>

                                                <label class="radio-inline">
                        <input  type="radio" name="<?php echo($skills['id']);?>" value = "2">Beginner
                        </label>

                                                <label class="radio-inline">
                        <input disabled type="radio" name="<?php echo($skills['id']);?>" value = "3">Advanced
                        </label>
                                            </td>
                                        </div>
                                    </tr>

                    <?php
                        }
                    }
                    ?>
                            </tbody>
                        </table>
                        <hr>
                    </div>
                    <?php
                        }
                    }
                    ?>
                        <!-- table body to be printed via php script: loop with table rows-->

                        <div class="form-group">
                            <label class="large" for="budget"><h3>Plan Budget</h3></label>
                            <input type="number" class="form-control" id="budget">
                            <p>Plan budget description goes here! </p>
                            <hr>
                        </div>

                        <div class="form-group">
                            <h3>Time Allocation</h3>
                            <label class="large" for="budget"><h4>Desired number of weeks to finish plan:</h4></label>
                            <input type="number" class="form-control" id="budget">
                            <p>Time Allocation description1 goes here </p>
                            <label class="large" for="budget"><h4>Hours available per week to work on plan:</h4></label>
                            <input type="number" class="form-control" id="budget">
                            <p>Time Allocation description2 goes here </p>
                            <hr>
                        </div>
                        <div class="from-group">

                        </div>


                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-lg">Generate New Plan</button>
                        </div>
                </form>

            </div>
        </div>
    </div>

</body>

</html>