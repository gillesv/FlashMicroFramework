<?php

function index() {
  return html('index.html.php', 'layout.html.php');
}

function pages() {
  return html(params('page') . '.html.php', 'layout.html.php');
}

function index_catchall() {
  return html('index.html.php', 'layout.html.php');
}

function preferences(){
	set('useFlash', false);
	return html('preferences.html.php', 'layout.html.php');
}

function savePreferences(){
	$choice = $_POST['choice'];
	
	if($choice == 'yes'){
		$_SESSION['useFlash'] = true;
	}else{
		$_SESSION['useFlash'] = false;
	}
	
	if(isset($_SESSION['route'])){
		redirect($_SESSION['route']);
	}else{		
		redirect('/');
	}
}