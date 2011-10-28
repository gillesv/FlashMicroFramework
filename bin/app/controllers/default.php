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

function renderContent(){
	$content = spyc_load_file(dirname(dirname(__FILE__)) . '/../assets/locales/nl.yml');
	
	set('content', $content[params(0)]);
	
	return html('render.html.php', 'layout.html.php');
}