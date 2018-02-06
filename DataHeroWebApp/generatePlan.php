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
    </style>
</head>

<body data-spy="scroll" data-target=".navbar-collapse">

    <div class="container contentContainer" id="topContainer">
        <div class="row">
            <div class="col-md-6 col-md-offset-1" id="topRow">
                <h2> Generate a new plan:</h2>
            </div>
        </div>


        <div class="row">
            <div class="col-md-6 col-md-offset-2" id="ThirdRow">

                <form>
                    <div class="form-group">
                        <label for="jobTitle">Select Job Title:</label>

                        <select class="form-control" id="jobTitle" onchange="UpdateSkills()">
                        <option selected>----</option>
                        <option>Data Analyst</option>
                        <option>Data Engineer</option>            
                        <option>Data Scientist</option>                          
                        <option>Business Intelligence Analyst</option>
                        <option>Biostatistician</option>
                        </select>
                    </div>

                    <div class="form-group" id="SkillsDiv">

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


                    <div class="form-group" id="skills">

                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option1">
                            <label class="form-check-label" for="inlineRadio1">DS Skill 1</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option2">
                            <label class="form-check-label" for="inlineRadio2">DS Skill 1</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio3" value="option3" disabled>
                            <label class="form-check-label" for="inlineRadio3">DS Skill 1</label>
                        </div>

                    </div>

                    <button type="submit" class="btn btn-primary btn-lg">Generate New Plan</button>
                </form>

            </div>
        </div>
    </div>

</body>

</html>