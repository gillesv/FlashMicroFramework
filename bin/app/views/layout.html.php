<!DOCTYPE HTML>
<!--[if IEMobile 7 ]><html class="no-js iem7"><![endif]-->
<!--[if lt IE 7 ]><html class="no-js ie6" lang="en"><![endif]-->
<!--[if IE 7 ]><html class="no-js ie7" lang="en"><![endif]-->
<!--[if IE 8 ]><html class="no-js ie8" lang="en"><![endif]-->
<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class="no-ie no-js" lang="en"><!--<![endif]-->
<head>
	<meta charset="UTF-8">

	<title>Microframework</title>
	
	<meta name="author" content="yourname" />
	<meta name="description" content="" />
	<meta name="HandHeldFriendly" content="True" />
	<meta name="MobileOptimized" content="320" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	
	
	<?php /* Microsoft: delete if not needed */ ?>
	<meta http-equiv="cleartype" content="on">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	
	
	<?php /* Any linked webfonts should go here */ ?>
	
	<?php /* Using conditional comments, we hide our mediaquery enhanced CSS from all IE versions below 9... */ ?>
	<!--[if ! lte IE 8]><!-->
	<link rel="stylesheet" href="<?php echo($base_path); ?>assets/css/style.css" />
	<![endif]-->
	
	<?php /* ... and serve a separate CSS instead, which is compiled from the same source but sans mediaqueries */ ?>
	<!--[if lte IE 8]>
	<link rel="stylesheet" href="<?php echo($base_path); ?>assets/css/ie.css">
	<![endif]-->
	
	<?php /* Favicon */ ?>
	<link rel="shortcut icon" href="<?php echo($base_path); ?>favicon.png">
	
	<?php /* All Javascript at the bottom, except modernizr */ ?>
	<script src="<?php echo($base_path); ?>assets/js/lib/flashdetect.min.js"></script>
	<script src="<?php echo($base_path); ?>assets/js/lib/modernizr.custom.00953.js"></script>
	
	<?php /* additional modernizr tests & init - inlined */ ?>
	<script>
		// <![CDATA[
			
			<?php 			
				// set in routes
				//$useFlash = isset($_SESSION['useFlash']) && $_SESSION['useFlash'];
			?>
			
			var baseURL = "<?php echo($base_path); ?>";
			var useFlash = <?php if($useFlash): ?>true<?php else: ?>false <?php endif; ?>;
			var FLASH_ID = "Experience";
			var version = "10.1"; // why bother with anything less than the latest, greatest version? It's not as if we don't have a proper fallback
			
			// Flash detection
			Modernizr.addTest('flash', function(){
				return FlashDetect.installed && FlashDetect.major >= parseInt(version.split('.')[0]) && useFlash;
			});
			
			Modernizr.load([
				// add swfobject from CDN, onComplete: attach appropriate swf
				{
					test: Modernizr.flash && useFlash,
					yep: ['//ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js'],
					complete: function(){
						if(Modernizr.flash && useFlash && swfobject){
							var flashvars = { 
									globalURL: "<?php echo($base_path); ?>"
								},
								params = { allowFullScreen: true, allowScriptAccess: "always" },
								attributes = { id: FLASH_ID };
							
							swfobject.embedSWF(baseURL + 'assets/swf/Main.swf', 'main', "100%", "100%", version, baseURL + 'assets/swf/expressInstall.swf', flashvars, params, attributes);
						}
					}
				},
				
				'//ajax.googleapis.com/ajax/libs/jquery/1/jquery.js',
				
				{
					test: Modernizr.history,
					yep: [baseURL + 'assets/js/lib/history.js', baseURL + 'assets/js/lib/history.adapter.jquery.js', baseURL + 'assets/js/lib/history.bridge.flash.js',]
				},
								
				// finally, your custom scripting
				baseURL + 'assets/js/Main.js'
			]);
		// ]]>
	</script>
</head>
<body>

<?php flush(); ?>

	<div id="main">
		<?php echo($content); ?>
	</div>

</body>
</html>