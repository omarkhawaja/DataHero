<?php 
    include ("login.php");
    include ("navBar.php");

    if (is_null($_SESSION['id'] )) header("Location:index.php") ;

$position   = "position=";
$budget     = "budget=";
$length     = "length=";
$skills     = "skills=";
$levels     = "levels=";
$position   .= $_POST['position'];
$budget     .=   $_POST['budget'];
$length     .=   $_POST['length'];

for ($i= 0; $i <= 100; $i++) {
    if(isset($_POST[$i])) {
        $skills .= $i.",";
        $levels .= $_POST[$i].",";
    }
} 

$skills = rtrim($skills, ',');
$levels = rtrim($levels, ',');

$inputs = "create_plan/".$position.'&'.$budget.'&'.$length.'&'.$skills.'&'.$levels ;
$apiURL .=$inputs;

$response = file_get_contents($apiURL);
$response = json_decode($response,true);
$_SESSION['plans'] = $response;
$relaxed = $response[0][0]['relaxed'] ;

if ($relaxed == 1)
{
    $message = '<div style ="width:600px;" class = "center alert alert-danger"><p>Constraint relaxation detected! - We could not satisfy your requirments as inputted. Therefore, the plan budget or time allocation requirements were relaxed until all required skills were satisfied</p></div>' ;
}

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Data Hero - Output</title>

    <style>
        #topRow {
            margin-top: 60px;
            margin-bottom: 60px;
            text-align: left;
        }

        .h1 {
            font-size: 150%;
        }

        .center {
            text-align: center;
        }
    </style>
</head>

<body data-spy="scroll" data-target=".navbar-collapse">

    <div class="container contentContainer" id="topContainer">
        <div class="row">
            <div class="col-md-10 col-md-offset-1" id="topRow">
                <h1>Hurray! </h1>
                <h1>We have generated the following plans for you:</h1>
            </div>
        </div>
        <div class="row">
            <div class = "col  col-md-offset-3">
                <?php 
                    echo $message;
                ?> 
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 col-md-offset-1" id="SecondRow">
                <h2> Suggested Plans: </h2>
                <br/>
            </div>
        </div>

        <div class="row">
            <div class="col-md-10 col-md-offset-1" id="ThirdRow">
                <table class="table">
                    <thead class="thead-dark">
                        <tr>
                            <th scope="col">Plan</th>
                            <th scope="col">Course Count</th>
                            <th scope="col">Technologies Covered</th>
                            <th scope="col">Total Cost</th>
                            <th scope="col">Time Commitment (Hrs)</th>
                            <th scope="col"></th>
                        </tr>
                    </thead>
                    <!-- table body to be printed via php script: loop with table rows-->
                    <tbody>
                        <?php
            
            if (count($_SESSION['plans']) > 0) 
            {
                $planID = 0;
                foreach ($_SESSION['plans'] as $plan)
                {
                    $course_count = $plan[0]['course_count'] ;
                    $tech_covered = ucwords(implode(", ", $plan[0]['tech_combo']));
                    $total_price  = $plan[0]['total_price'];
                    $total_length = $plan[0]['total_length'] ;
                    
                        ?>
                            <tr>
                                <th scope="row">
                                    <?php echo("Plan ".($planID + 1)); ?> </th>
                                <td class="center">
                                    <?php echo($course_count); ?></td>
                                <td class="center">
                                    <?php echo($tech_covered); ?></td>
                                <td class="center">
                                    <?php echo($total_price); ?> </td>
                                <td class="center">
                                    <?php echo($total_length); ?> </td>

                                <td>
                                    <form  target="_blank" action="viewplan.php" method="POST">
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
                                    <th scope="row">INVALID INPUTS</th>
                                </tr>
                                <?php
            }
        ?>
                    </tbody>
                </table>
            </div>
            <br/><br/>
        </div>
    </div>
</body>

</html>