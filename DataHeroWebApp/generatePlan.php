<?php 

    include ("login.php");
    include ("BootstrapCDN.php");
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

        #hide {
            display: none;
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

                <form method="POST" id="inputForm" action="output.php">
                    <div class="form-group">
                        <label><h3>Select Career Path:</h3></label>

                        <select required class=" form-control" id="jobTitle" name="position" onchange="UpdateSkills()">
                            <option disabled selected>Select position</option>  
                            <?php    
                            $query = "SELECT * FROM Positions" ;
                            $result = mysqli_query($link,$query) ;	
                            if (mysqli_num_rows($result) > 0) 
                            {
                                while($positions = mysqli_fetch_assoc($result))
                                {
                                    echo('<option value ="'.$positions['id'].'" >'.$positions["position"].'</option>');
                                }
                            }
                            ?>
                        </select>
                    </div>

                    <script type="text/javascript">
                        //Write JS script to output relevant skills based on "jobTitle" selection: onchange="UpdateSkills()

                        var changeOccured = false;

                        function UpdateSkills() {
                            var SelectedJobTitle = document.getElementById("jobTitle").value;
                            if (changeOccured == true) {
                                location.reload();
                                return;
                            }
                            //Need to reload page to remove any selected skills in hidden divs
                            changeOccured = true;

                            if (SelectedJobTitle == 1) {

                                document.getElementById("Data Scientist Skills").style.display = "block";

                            } else if (SelectedJobTitle == 2) {
                                document.getElementById("Data Engineer Skills").style.display = "block";

                            } else if (SelectedJobTitle == 3) {
                                document.getElementById("Data Analyst Skills").style.display = "block";

                            } else if (SelectedJobTitle == 4) {
                                document.getElementById("Business Intelligence Analyst Skills").style.display = "block";
                                
                            } else if (SelectedJobTitle == 5) {
                                document.getElementById("Biostatistician Skills").style.display = "block";
                            } else {
                                return;
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
                    <div style="display:none;" class="form-group" id="<?php echo($positions['position']);?> Skills">
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
                        <input required type="radio" name="<?php echo($skills['id']);?>" value = "1">Needed
                        </label>

                                                <label class="radio-inline">
                        <input type="radio" name="<?php echo($skills['id']);?>" value = "2">Beginner
                        </label>

                                                <label class="radio-inline">
                        <input type="radio" name="<?php echo($skills['id']);?>" value = "3">Advanced
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
                            <input id="budget" name="budget" type="number" class="form-control" required>
                            <p>Plan budget description goes here! </p>
                            <hr>

                        </div>

                        <div class="form-group">

                            <h3>Time Allocation</h3>
                            <label class="large" for="length"><h4>Total time available to work on plan in hours:</h4></label>
                            <input type="number" class="form-control" id="length" name="length" required>
                            <p>Time Allocation description1 goes here </p>

<!--                            <label class="large" for="budget"><h4>Hours available per week to work on plan:</h4></label>
                            <input type="number" class="form-control" id="hours" name="hours">
                            <p>Time Allocation description2 goes here </p>-->

                            <hr>
                        </div>

                        <div class="from-group">

                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-lg" >Generate New Plan</button>
                        </div>
                </form>

            </div>
        </div>
    </div>

</body>


<!--<script type="text/javascript">
/*
    function inputsArray() {

        var inputObjs = document.getElementsByTagName('input');
        var skills = inputObjs.map(function(el){
            return el.value;
}).join(',');
        alert(skills) ;
        
        var skills =  [].slice.call(inputObjs);
        alert(skills) ;
        console.log(inputObjs);
        for (var i = 0; i < inputObjs.length; ++i) {
            skills.append(inputObjs[i].value);
            alert(skills);

        }
        alert(skills);
    }
*/



      
        var xmlhttp = new XMLHttpRequest();
        var url = 'http://127.0.0.1:5000/create_plan/15';

        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var myArr = JSON.parse(this.responseText);
                console.log(myArr);
                myFunction(myArr);
            }
        };

        
        xmlhttp.open("GET", url, true);
        xmlhttp.send();

        function myFunction(arr) {
            var out = "";
            var i;
            for (i = 0; i < arr.length; i++) {
                out += '<p>' + arr[i].name + '</p>';
                out += '<p>' + arr[i].length + '</p>';
            }
            document.getElementById("id01").innerHTML = out;
        }
</script>-->

</html>