<?php

//Definir el servidor
 $HostName = "localhost:8080";
 
 //Nombre de la base de datos
 $DatabaseName = "Pokemon";
 
 //Usuario de la base de datos
 $HostUser = "root";
 
 //contraseña de la base de datos
 $HostPass = ""; 
 
 // creando la conexion
 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
 
 //  transformaremos la respuesta a json
 $json = file_get_contents('php://input');
 
 // decodificamos la respuesta
 $obj = json_decode($json,true);
 
 // agarramos de la tabla, el atrubuto usuario
 $usuario = $obj['Usuario'];
 
 // obtenemos de la tabla, el atributo password
 $password = $obj['Password'];
 
 //Aplicamos la logica para el login
 $loginQuery = "select * from Login where email = '$usuario' and password = '$password' ";
 
 // ejecutamos el query
 $check = mysqli_fetch_array(mysqli_query($con,$loginQuery));
 
	if(isset($check)){
		
		 // El usuario se ha logeado
		 $onLoginSuccess = 'Login Matched';
		 
		 // Convertimos el formato a json
		 $SuccessMSG = json_encode($onLoginSuccess);
		 
		 // imprimimos las respuesta
		 echo $SuccessMSG ; 
	 
	 }
	 
	 else{
	 
		 // No se dio el login
		$InvalidMSG = 'Invalid Username or Password Please Try Again' ;
		 
		// Conviertiendo el mensaje a json
		$InvalidMSGJSon = json_encode($InvalidMSG);
		 
		// print
		 echo $InvalidMSGJSon ;
	 
	 }
 
 mysqli_close($con);
?>
