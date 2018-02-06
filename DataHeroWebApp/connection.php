<?php

// Create connectionto DB:
$servername = "35.229.91.75";
$database = "fydp";
$username = "root";
$password = "root";

$link = new mysqli($servername, $username, $password, $database);

// Check connection status:

if ($link->connect_error) {
   die("Connection Failed: " . $link->connect_error);
}

?>

