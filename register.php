<?php
	$db = mysqli_connect('localhost:8080','root','','Pokemon');
	if (!$db) {
		echo "Database connection faild";
	}

	$username = $_POST['Usuario'];
	$password = $_POST['Password'];

	$sql = "SELECT Usuario FROM Login WHERE Usuario = '".$username."'";

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode("Error");
	}else{
		$insert = "INSERT INTO Login(username,password)VALUES('".$username."','".$password."')";
		$query = mysqli_query($db,$insert);
		if ($query) {
			echo json_encode("Success");
		}
	}

?>
