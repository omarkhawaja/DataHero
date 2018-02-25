<?php
    //include ("login.php");
	//include ("connection.php");
    //include ("BootstrapCDN.php");

    //if (is_null($_SESSION['id'] )) header("Location:index.php") ;

/*    if (is_null($_POST['view_plan_id'])) header("Location:output.php");

    //$planNum= $_POST['view_plan_id'] ;
    //$plan = $_SESSION['plans'][$planNum];

    $planCount = 1;
    foreach ($_SESSION['plans'] as $plan)
    {
      echo("This is Plan: ". $planCount);
//      print_r($plan);
      echo("##################");
      $planCount++;
*/




/*$position   = "position=";
$budget     = "budget=";
$length = "length=";
$skills = "skills=";
$levels = "levels=";
$position.= $_GET['position'];
$budget.=   $_GET['budget'];
$length.=   $_GET['length'];

for ($i= 0; $i <= 100; $i++) {
    if(isset($_GET[$i])) {
        $skills .= $i.",";
        $levels .= $_GET[$i].",";
    }
} 

$skills = rtrim($skills, ',');
$levels = rtrim($levels, ',');*/

//$apiURL = "http://127.0.0.1:5000/create_plan/";
//$inputs = $position.'&'.$budget.'&'.$length.'&'.$skills.'&'.$levels ;

//$apiURL .=$inputs;
$apiURL = "http://127.0.0.1:5000/create_plan/position=2&budget=10001&length=10001&skills=3,9,19,23,24,25&levels=1,1,1,1,1,1";

$response = file_get_contents($apiURL);
$response = json_decode($response,true);
$_SESSION['plans'] = $response;
$plan = $_SESSION['plans'][0] ;

//for($i = 3, $i < $plan[2]['course_count'] $plan)
$numCourses = count($plan);

for($i =  3;$i < $numCourses ;$i++)
{
    $description = "";
    if (strlen($plan[$i]['description']) > 500)
        $description = substr($plan[$i]['description'], 0, 497) . '...';
    echo $description ;
    echo "<br/>";
}
print_r($plan);
?>

<?php

/*echo (' ##################### ');
echo(count($response));
echo (' ##################### ');
echo(count($response[0]));
echo (' ##################### ');
echo($response[0]['name']);
echo (' ##################### ');
echo($response[0]['description']);

print_r($response[0][0]['name']);



//$test = isset($_GET['something']) ? $_GET['something'] : '';

////////////OR: /*$response = file_get_contents('http://127.0.0.1:5000/create_plan/15'); 

$response = json_decode($response);
echo(count($response));
echo(count($response[0])); 
echo($response[0]->name); 
echo($response[0]->description);

*/
?>