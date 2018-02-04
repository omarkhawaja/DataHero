<?php
include ("BootstrapCDN.php");
?>
		<div class="navbar navbar-default navbar-fixed-top ">
			<div class="container">
                <div class="navbar-header">

					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
						<span class="sr-only">Toggle Navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>

				</div>

				<div class="navbar-header pull-left">
					<a href="" class="navbar-brand">Data Hero</a>
				</div>
                
                <div class="collapse navbar-collapse">
                    
                <div class = "pull-left">
                    <ul class="navbar-nav nav">
                        <li><a href="main.php" >Dashboard</a></li>
					</ul>
                </div>

				<div class=" pull-right">
					<ul class="navbar-nav nav ">
                        <li> <a href="manageProfile.php">My Profile</a></li>
						<li> <a href="index.php?logout=1">Log Out</a></li>
					</ul>
				</div>
                </div>
			</div>
        </div> 

<?php
?>