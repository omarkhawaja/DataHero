<?php

// Create connectionto DB:

$servername = "35.229.91.75";
$database = "fydp";
$username = "root";
$password = "root";
$apiURL = "http://127.0.0.1:5000/";


$link = new mysqli($servername, $username, $password, $database);
if ($link->connect_error) {
   die("Connection Failed: " . $link->connect_error);
}

//GET API RESPONSE 
function GET_API_Request($Endpoint) {
    global $apiURL ;
    $requestURL = $apiURL.$Endpoint ;
    $response = file_get_contents($requestURL) ;
    $response = json_decode($response,true) ;
    return $response ;
}

//POST API Request:
function POST_API_Request($Endpoint, $data)
{
    global $apiURL ;
    $requestURL = $apiURL.$Endpoint ;
    
    $content = json_encode($data);
    $curl = curl_init($requestURL);
    curl_setopt($curl, CURLOPT_HEADER, false);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_HTTPHEADER,array("Content-type: application/json"));
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $content);
    
    $json_response = curl_exec($curl);
    $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);

    if ( $status != 200 ) {
    die("Error: call to URL $url failed with status $status, response $json_response, curl_error " . curl_error($curl) . ", curl_errno " . curl_errno($curl));
    }

    curl_close($curl);

    $response = json_decode($json_response, true);
    return $response['status'] ;
}


/*

POST FUNCTION

$url = "http://127.0.0.1:5000/save_plan";
$data = array('plan_id' => 4. 'user_id' => 12);
   
$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,array("Content-type: application/json"));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);

$status = curl_getinfo($curl, CURLINFO_HTTP_CODE);

if ( $status != 201 ) {
    die("Error: call to URL $url failed with status $status, response $json_response, curl_error " . curl_error($curl) . ", curl_errno " . curl_errno($curl));
}


curl_close($curl);

$response = json_decode($json_response, true);


*/


?>


