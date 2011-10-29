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

function splash(){
	return html('splash.html.php', 'layout.html.php');
}

function savePrefs(){
	$choice = $_POST['choice'];
	
	if($choice == 'yes'){
		$_SESSION['useFlash'] = true;
	}else{
		$_SESSION['useFlash'] = false;
	}
	
	redirect('/');
}