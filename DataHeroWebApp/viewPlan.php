<?php 
    include ("login.php");
	include ("connection.php");
    include ("navBar.php");

    if (is_null($_SESSION['id'] )) header("Location:index.php") ;
    if (is_null($_POST['view_plan_id'])) header("Location:output.php");
    
    $planNum    = $_POST['view_plan_id'] ;
    $plan       = $_SESSION['plans'][$planNum];

    $numCourses = count($plan);//Temporary Solution until JSON is fixed!!!

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Data Hero - Plan Details</title>

    <style>
        #topRow {
            margin-top: 60px;
            margin-bottom: 60px;
            text-align: left;
        }

        .h1 {
            font-size: 150%;
        }
        .td {
            padding-left: 5em;
        }
        .center {
            text-align: center;
        }
        .nameDiv {
            height: 50px;
        }
    </style>
</head>

<body data-spy="scroll" data-target=".navbar-collapse">

    <div class="container contentContainer" id="topContainer">
        <div class="row">
            <div class="col-md-6" id="topRow">
                <h1> Plan Details:</h1>
            </div>
        </div>

        <div>


            <div class="jumbotron">
        
                <h3>Technologies Covered:&#9;&#9;&#9;<?PHP print_r($plan[0]['total_price']); ?></h3><hr/><br/>
                <h3>Total Cost:&#9;<?PHP print_r($plan[0]['total_price']); ?></h3><hr/><br/>
                <h3>Total Time Required:&#9;<?PHP print_r($plan[1]['total_length']); ?></h3><hr/><br/>
                <h3>Number of Courses in Plan:&#9;<?PHP print_r($plan[2]['course_count']); ?></h3><hr/>
            </div>


            <div class="row">
                <h2> Plan Courses:</h2>
                
                <?php
                

                for($i =  3;$i < $numCourses ;$i++)
                {
                    $name = $plan[$i]['name'];
                    $description = $plan[$i]['description'];
                    $price = $plan[$i]['price'];
                    $url = $plan[$i]['url'];
                    $rating = $plan[$i]['rating'];
                    $inst = $plan[$i]['inst_name'];
                ?>
                <div class="col col-md-6">
                    <div class = "nameDiv">
                    <h3><?php echo $name ; ?></h3>
                    </div>
                    <h4>Instructor: <?php echo $inst ; ?></h4>
                    <h4>Price: <?php echo $price ; ?></h4>
                    <h4>Rating: <?php echo $rating ; ?></h4>
                    <p><?php if (strlen($description) > 500)
                        $description = substr($plan[$i]['description'], 0, 497) . '...';
                    echo $description ; ?></p>
                    
                    <p><a class="btn btn-primary" href="<?php echo $url; ?>" role="button" target="_blank">View Course Page &raquo;</a></p>
                    <br/>
                </div>

                <?php 
                }
                ?>
                
<!--                
                <div class="col col-md-6">
                    <h2>Heading</h2>
                    <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                    <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
                </div>
-->
            </div>
        </div>

        <div class="row">
            <div class="col-md-8 col-md-offset-5" id="ThirdRow">
                <button class="btn btn-alert" type="button" onclick="window.open('', '_self', ''); window.close();">Back to Suggested Plans &raquo; </button>

             <form action="viewPlan.php?plan_id=<?php echo($row['id']);?>" method="post">
                <input type="hidden" name="ViewID" value="<?php echo $row['id']; ?>">
                <input type="submit" class="btn btn-success" value="View Plan">
            </form>

            </div>
        </div>
    </div>
</body>

</html>