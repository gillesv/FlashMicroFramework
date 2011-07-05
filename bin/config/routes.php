<?php

dispatch('/', 'index');

// Define your routes here
// dispatch_post('/login/do', 'do_login');


dispatch('/**', 'index_catchall');

/**
 * Function is called before every route.
 */
function before($route) {
  before_defaults();  
}
