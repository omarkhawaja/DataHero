<?php 
    include ("login.php");
    include ("navBar.php");

    if (is_null($_SESSION['id'] )) header("Location:index.php") ;
    if (is_null($_POST['view_plan_id'])) header("Location:output.php");
    
    $planNum    = $_POST['view_plan_id'] ;
    $plan       = $_SESSION['plans'][$planNum];

    $course_count = $plan[0]['course_count'] ;
    $tech_covered = ucwords(implode(", ", $plan[0]['tech_combo'])) ;
    $total_price  = $plan[0]['total_price'] ;
    $total_length = $plan[0]['total_length'] ;
    $plan_id = $plan[0]['plan_id'] ;

//SAVE PLAN PARAMETERS:

    if(isset($_POST['save_plan'])) {

        $save_endpoint = "save_plan" ;
        $save_data = array('plan_id' => $plan_id, 'user_id' => $_SESSION['id']); 
        $result = POST_API_Request($save_endpoint,$save_data);
        if($result =='success') {
            $message = '<div class = "center alert alert-success">Plan was Saved Successfully!</div>' ;
            $button  = '<div class = "col center wide"><button class="btn btn-secondary" type="button" onclick="';
            $button .= "window.open('', '_self', ''); window.close();";
            $button .= '">&laquo; Back to Suggested Plans</button></div>';

        }
        else {
            $message =  '<div class = "center alert alert-danger">Error While Saving Plan. Please Try Again Later!</div>' ;
            $button  = '<div class = "col center wide"><button class="btn btn-secondary" type="button" onclick="';
            $button .= "window.open('', '_self', ''); window.close();";
            $button .= '">&laquo; Back to Suggested Plans</button></div>';

        }
    }

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
        
        .center {
            text-align: center;
        }
        .bottomMargin {
            margin-bottom: 10px;
        }
        .nameDiv {
            height: 50px;
        }
        .wide{
    
        width:200px;
        }
    </style>
    
    
</head>

<body data-spy="scroll" data-target=".navbar-collapse">

    <div class="container contentContainer" id="topContainer">
        <div class="row">
            <div class="col-md-12 center" id="topRow">
                <h2><b> Plan Details:</b></h2>
                <div class = "col center">
                <?php 
                    echo $message;
                    echo $button;  
                ?> 
                </div>
            </div>
        </div>

            <div class="jumbotron">
                
        
                <h3><b>Technologies Covered:</b>&#9;&#9;&#9;<?PHP echo $tech_covered; ?></h3><hr/>
                <h3><b>Total Cost:</b>&#9;<?PHP echo '$'.$total_price ; ?></h3><hr/>
                <h3><b>Total Time Commitment:</b>&#9;<?PHP echo $total_length.' Hours' ; ?></h3><hr/>
                <h3><b>Number of Courses in Plan:</b>&#9;<?PHP echo $course_count.' Courses'; ?></h3><hr/>
            </div>


            <div class="row">
                <h2> <b> Plan Courses:</b></h2>
                
                <?php
                
                for($i =  1; $i <= $course_count  ;$i++)
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
                
            </div>
            <hr>

        <br/><br/>
        
        <div class="row">
            
            <div class = "col bottomMargin center">
            <form method = "POST" action="">
                
                <input  name ="save_plan" class=" wide btn btn-success" type="submit"  value = "Save this Plan &raquo;">   
                <input type = "hidden" name = "view_plan_id" value = "<?php echo $planNum ; ?>">
                
            </form>
            </div>
            
            <div class = "col bottomMargin center">
                <button class="wide btn btn-primary" type="button" onclick="window.open('', '_self', ''); window.close();">&laquo; Back to Suggested Plans</button>
            </div>
            
            
        </div>
        </div>
</body>

</html>