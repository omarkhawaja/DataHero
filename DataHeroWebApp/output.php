<?php 
    include ("login.php");
	include ("connection.php");
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
            <div class="col-md-6 col-md-offset-2" id="SecondRow">
                <h2> Suggested Plans: </h2>
                <br/>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8 col-md-offset-2" id="ThirdRow">
                <table class="table">
                    <thead class="thead-dark">
                        <tr>
                            <th scope="col">Plan</th>
                            <th scope="col">Course Count</th>
                            <th scope="col">Technologies Covered</th>
                            <th scope="col">Cost</th>
                            <th scope="col">Time Required</th>
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
                    
        ?>
                            <tr>
                                <th scope="row">
                                    <?php echo("Plan".$planID); ?> </th>
                                <td class="center">
                                    <?php print_r($plan[2]['course_count']); ?> </td>
                                <td class="center">
                                    <?php print_r($plan[0]['total_price']); ?> </td>
                                <td class="center">
                                    <?php print_r($plan[1]['total_length']); ?> </td>
                                <td class="center">
                                    <?php print_r($plan[1]['total_length']); ?> </td>

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
        </div>
    </div>
</body>

</html>