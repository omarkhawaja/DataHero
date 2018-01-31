<?php


// Create connection
$servername = "35.229.91.75";
$database = "fydp";
$username = "root";
$password = "root";

$link = new mysqli($servername, $username, $password, $database);
// Check connection
if ($link->connect_error) {
   die("Connection Failed: " . $link->connect_error);
}
  echo "Connected successfully to DB";


/*

$query = "INSERT INTO Users (userEmail, userPassword) VALUES ('2345@test.com', 'alksdjf');" ;
mysqli_query($link,$query) ;
echo "good" ;
*/

?>

