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
