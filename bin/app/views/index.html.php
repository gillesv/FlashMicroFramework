<h1>Welcome to Proximinade!</h1>
<h2>Loosely based on the great <a href="http://www.limonade-php.net/">Limonade PHP</a></h2>

<p>Enough with the babbling, let's get some coding done!</p>

<section>
  <h2>Environment</h2>

  <h3>Base path</h3>
  
  <code>$base_path</code>

  <p class="result"><?php echo($base_path); ?></p>

  <h3>How to get your current environment?</h3>
  
  <code>option('env');</code>

  <p class="result"><?php echo(option('env')); ?></p>

  <h3>How to change environment</h3>

  <p>In your root directory, create a file with the name 'DEVELOPMENT', 'STAGING' or 'PRODUCTION'</p>
  <p>The files are used to determine the environment, with a sorting priority:</p>

  <code>1. PRODUCTION</code>
  <code>2. STAGING</code>
  <code>3. DEVELOPMENT</code>

  <p>If no file is found, 'DEVELOPMENT' will be the default environment</p>
</section>

<section>
  <h2>Page</h2>

  <h3>How to get your current page?</h3>
  
  <code>_page();</code>

  <p class="result"><?php echo(_page()); ?></p>

  <h3>What about the part behind my base controller?</h3>

  <code>_page(1);</code>

  <p class="result"><?php echo(_page(1)); ?></p>
  
  <h3>Active page (for menu)?</h3>
  
  <p>Check if first controller (ignoring language url part) equals home</p>

  <code>_get_active('home', 0);</code>

  <p class="result"><?php echo(_get_active('home', 0)); ?></p>
</section>

<section>
  <h2>MultiLang</h2>

  <h3>The current language can be fetched through<br>
  Multilang::getInstance()->getLang(), or through the short var $lang</h3>
  <p><em>Note: the short var is set on the before() call, so all changes during 
  the build of a page (as above), will not be reflected. To get the most up to 
  date result, use the longer Multilang::getInstance()->getLang() version.</em></p>
  <code>echo($lang);</code>
  <p class="result"><?php echo($lang); ?></p>
  <code>echo Multilang::getInstance()->getLang();</code>
  <p class="result"><?php echo(Multilang::getInstance()->getLang()); ?></p>
  
  <h3>First trying out Multilang with the default language</h3>
  <code>_t('title');</code>
  <p class="result"><?php _t('title'); ?></p>

  <h3>Then change the lang and output again</h3>
  <code>Multilang::getInstance()->lang('fr-BE');</code>
  <p>or</p>
  <code>Multilang::getInstance()->lang('fr');</code>
  <p>and</p>
  <code>_t('title');</code>
  <p class="result"> <?php Multilang::getInstance()->setLang('fr'); _t('title'); ?> </p>

  <h3>Now we use the same _t() function, but with an extra language parameter</h3>
  <code>_t('title', 'nl-BE');</code>
  <p>or</p>
  <code>_t('title', 'nl');</code>
  <p>or</p>
  <code>_t('title', 'nl', true);</code>
  <p class="result"> <?php _t('title', 'nl-BE', true); ?> </p>

  <h3>Switch back to default language</h3>
  <code>Multilang::getInstance()->defaultLang();</code>
  <?php Multilang::getInstance()->defaultLang(); ?>

  <h3>Chain it!</h3>
  <p>You can dig into your YAML file to look up objects and arrays.</p>
  <code>_t('contact', false)->t('title');</code>
  <p class="result"><?php echo _t('contact', false)->t('title'); ?></p>
  <p>You have to give 'false' as 2nd argument so the _t function won't echo the result</p>
  <p>The language parameter will still work:</p>
  <code>_t('contact', 'fr-BE', false)->t('title');</code>
  <p class="result"><?php echo _t('contact', 'fr-BE', false)->t('title'); ?></p>
  <p></p>
  <p>An array behind an object:</p>
  <code>_t('contact', false)->t('sex')->t(0);</code>
  <p class="result"><?php echo _t('contact', false)->t('sex')->t(0); ?></p>
  <p>or</p>
  <code>$arr = _t('contact', false)->t('sex');<br />echo $arr[1];</code>
  <p class="result"><?php $arr = _t('contact', false)->t('sex'); echo $arr[1]; ?></p>

  <h3>There is also an _d() function, that can replace a dynamic value using a regular expression</h3>
  <code>_d('dynamic', '/%/', 'dynamic coolness');</code>
  <p class="result"><?php _d('dynamic', '/%/', 'dynamic coolness'); ?></p>
</section>

<section>
  <h2>Configuration</h2>

  <h3>Configuration from ./config/config.yml</h3>

  <p>The config.yml file is a configuration file. You have 2 ways to fetch values from the file.</p>

  <code>ProximityApp::$settings['db']['adapter'];</code>
  <p>and</p>
  <code>_c('db', 'adapter');</code>

  <p>Both give you: </p>

  <p class="result"><?php echo(_c('db', 'adapter')); ?></p>
</section>

<section>
  <h2>Logging/debugging</h2>

  <p>You can use the _log() function to output stuff to your browser's console, converted to a json object. This can be useful if you want do inspect objects, arrays, strings in your app's code.</p>
  <p><em>Note: the config.yml file should have 'verbose: true' to show the debugging.</em></p>
  <code>_log($_POST)</code>
  <p>or</p>
  <code>_log($whatever_variable)</code>
</section>
