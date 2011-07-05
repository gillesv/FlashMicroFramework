<?php

function before_defaults() {
  set('base_path', BASE_PATH);

  // Set lang if first controller is a language
  $url_parts = url_parts();
  
  if(preg_match(Multilang::getInstance()->langs_as_regexp(), $url_parts[0]))
    Multilang::getInstance()->setLang($url_parts[0]);

  set('lang', Multilang::getInstance()->getLang());
}

function url_parts() {
  $parts = explode("/", request_uri());
  
  array_shift($parts); // remove first empty element

  return $parts;
}

function page($id = 0) {
  $parts = url_parts();

  if(count($parts) > 0 && preg_match(Multilang::getInstance()->langs_as_regexp(), $parts[0])) // if first part is a lang
    array_shift($parts);

  if(count($parts) > 0 && $id < count($parts))
    return $parts[$id];

  return BASE_PATH;
}

function get_active($page_name, $id = 0) {
  if(page($id) == $page_name)
    return 'active';
  
  return '';
}
