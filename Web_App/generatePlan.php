<?php 

    include ("Connection/login.php");
    include ("Connection/BootstrapCDN.php");
    include ("Connection/navBar.php");

    if (is_null($_SESSION['id'] )) header("Location:../index.php") ;
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

        .center {
            text-align: center;
        }
    </style>
</head>

<body data-spy="scroll" data-target=".navbar-collapse">
    <div class="container contentContainer" id="topContainer">
        <div class="row">
            <div class="col-md-4 col-md-offset-2" id="topRow">
                <h2>Generate a new plan:</h2>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 col-md-offset-3">
                <form method="POST" id="inputForm" action="output.php">
                    <div class="form-group">
                        <label><h3>Select Career Path:</h3></label>

                        <select required class=" form-control" id="jobTitle" name="position" onchange="UpdateSkills(this.value)">
                            <option disabled selected>Select Position</option>  
                            <?php  
                            $endpoints = "positions" ;
                            $positions = GET_API_Request($endpoints);
	
                            if (count($positions) > 0) 
                            {
                                for ($i=0 ; $i < count($positions) ; $i++)
                                {
                                    echo('<option value ="'.$positions[$i]['id'].'" >'.$positions[$i]['position'].'</option>');
                                }
                            }
                            ?>
                        </select>
                    </div>
                    <br/>

                    <!-- table body to be printed via php script: loop with table rows-->
                    <?php    
                    
                    if (count($positions) > 0) 
                    {   
                        for ($i=0 ; $i < count($positions) ; $i++)
                        {
                    ?>
                    <div style="display:none;" class="form-group" id="<?php echo($positions[$i]['position']);?> Skills">

                        <p><b>Naive/Basic Level:</b> You have very basic knowledge or understanding of the techniques and concepts involved with the skill. You are expected to need help when performing this skill.</p>
                        <p><b>Intermediate Level:</b> You have very basic knowledge or understanding of the techniques and concepts involved with the skill. You are expected to need help when performing this skill.</p>
                        <p><b>Advanced Level:</b> You have very basic knowledge or understanding of the techniques and concepts involved with the skill. You are expected to need help when performing this skill.</p>
                        <label><h3>Skills Levels:</h3></label>
                        <table class="table" id="<?php echo($positions[$i]['position']);?>Skills">
                            <thead>
                                <tr>
                                    <th scope="col">Skill:</th>
                                    <th scope="col">Your Current Level:</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                    $endpoint = "positions/skills/position_id=".$positions[$i]['id'] ;
                    $position_skills = GET_API_Request($endpoint);

                    if (count($position_skills) > 0) 
                    {
                        for ($j=0 ; $j < count($position_skills) ; $j++)
                        {
                            ?>
                                    <tr>
                                        <div class="form-group" name="<?php echo($position_skills[$j]['skill']);?>">
                                            <td>
                                                <label class="radio-inline"><?php echo(ucwords($position_skills[$j]['skill']));?></label>
                                            </td>
                                            <td>
                                                <label class="radio-inline">
                                                        <input  class ="<?php echo $positions[$i]['id'].'radio'?>" type="radio" name="<?php echo($position_skills[$j]['id']);?>" value = "1">Naive/Basic
                                                        </label>
                                                <label class="radio-inline">
                                                        <input class ="<?php echo $positions[$i]['id'].'radio'?>" type="radio" name="<?php echo($position_skills[$j]['id']);?>" value = "2">Intermediate
                                                        </label>
                                                <label class="radio-inline">
                                                        <input class ="<?php echo $positions[$i]['id'].'radio'?>"type="radio" name="<?php echo($position_skills[$j]['id']);?>" value = "3">Advanced
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
                            <label class="large" for="budget"><h3>Plan Budget:</h3></label>
                            <input id="budget" name="budget" type="number" class="form-control" required min="220" placeholder="">
                            <br/>
                            <p>Plan budget represents the <b>total amount</b> you are allocating for acquiring the skills you need for the career path you are generating a plan for. Please note that most of the courses we recommend have a free option if you don't require a course certificate. In those cases, the price of course certificate is being considered as the price for taking that course.</p>
                            <hr>
                        </div>
                        <div class="form-group">
                            <label class="large" for="length"><h3>Plan Time Allocation:</h3></label>
                            <input type="number" class="form-control" id="length" name="length" required min="220">
                            <br/>
                            <p>Plan time allocation represents the <b>total number of hours</b> you are willing to spend on the courses of the plan being generated.</p>
                            <!--                            <label class="large" for="budget"><h4>Hours available per week to work on plan:</h4></label>
                            <input type="number" class="form-control" id="hours" name="hours">
                            <p>Time Allocation description2 goes here </p>-->
                            <hr>
                        </div>

                        <div class="from-group">

                        </div>

                        <div class="center form-group">
                            <button type="submit" class="btn btn-primary btn-lg"> Generate Plans </button>
                        </div>
                </form>

            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
    var positions;
    var positions_count;
    Get_API("positions");

    function Get_API(endpoint) {
        var api_URL = "http://127.0.0.1:5000/";
        api_URL = api_URL + endpoint;
        var params = 0; //|| data ;
        var request;
        if (params == 0) {
            request = api_URL;
        } else {
            request = api_URL + params;
        }

        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", request, true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var myArr = JSON.parse(this.responseText);
                save_results(myArr);
            }
        };

        function save_results(result) {
            positions = result;
            console.log(positions);
            positions_count = result.length;
        }
    }

    function UpdateSkills(selected_position) {
        var show_position = positions[selected_position - 1].position;
        show_position = show_position + " Skills";

        unrequire_all();
        hide_all();
        show_div(show_position);
        require(selected_position);
        uncheck_all();
    }

    function show_div(divID) {
        document.getElementById(divID).style.display = "block";
    }

    function hide_all() {
        for (i = 0; i < positions_count; i++) {
            document.getElementById(positions[i].position + " Skills").style.display = "none";
        }
    }

    function require(position) {
        var className = position + "radio";
        var x = document.getElementsByClassName(className);
        for (i = 0; i < x.length; i++) {
            x[i].required = true;
        }
    }

    function unrequire_all() {
        for (i = 1; i <= positions_count; i++) {
            var className = i + "radio";
            var x = document.getElementsByClassName(className);
            for (j = 0; j < x.length; j++) {
                x[j].required = false;
            }
        }
    }

    function uncheck_all() {
        for (i = 1; i <= positions_count; i++) {
            var className = i + "radio";
            var x = document.getElementsByClassName(className);
            for (j = 0; j < x.length; j++) {
                x[j].checked = false;
            }
        }
    }
</script>

</html>