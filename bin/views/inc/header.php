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
	<link rel="stylesheet" href="<?php echo($base_path); ?>/css/style.css" />
	<![endif]-->
	
	<?php /* ... and serve a separate CSS instead, which is compiled from the same source but sans mediaqueries */ ?>
	<!--[if lte IE 8]>
	<link rel="stylesheet" href="<?php echo($base_path); ?>/css/ie.css">
	<![endif]-->
	
	<?php /* Favicon */ ?>
	<link rel="shortcut icon" href="<?php echo($base_path); ?>/favicon.png">
	
	<?php /* All Javascript at the bottom, except modernizr */ ?>
	<script src="<?php echo($base_path); ?>/js/lib/flashdetect.min.js"></script>
	<script src="<?php echo($base_path); ?>/js/lib/modernizr.custom.00953.js"></script>
	
	<?php /* additional modernizr tests & init - inlined */ ?>
	<script>
		// <![CDATA[
			
			<?php 			
				$noFlash = isset($_GET['noflash']);
			?>
			
			var baseURL = "<?php echo($base_path); ?>/";
			var useFlash = <?php if($noFlash): ?>false<?php else: ?>true <?php endif; ?>;
			var FLASH_ID = "FlashMain";
			var version = "10.1"; // why bother with anything less than the latest, greatest version? It's not as if we don't have a proper fallback
			
			
			// Webkit detection script
			Modernizr.addTest('webkit', function(){
				return RegExp(" AppleWebKit/").test(navigator.userAgent);
			});
			
			// Mobile Webkit
			Modernizr.addTest('mobilewebkit', function(){
				return Modernizr.webkit && RegExp(" Mobile/").test(navigator.userAgent);
			});
			
			// Flash detection
			Modernizr.addTest('flash', function(){
				return FlashDetect.installed && FlashDetect.major >= parseInt(version.split('.')[0]) && useFlash;
			});
			
			Modernizr.load([
				// test mobile webkit (zepto or jquery?) and load the correct javascript library + history.js adapters
				{
					test: Modernizr.mobilewebkit,
					nope: ['//ajax.googleapis.com/ajax/libs/jquery/1/jquery.js', baseURL + 'js/lib/history.adapter.jquery.js'],
					yep: [baseURL + 'js/lib/zepto.min.js', baseURL + 'js/lib/history.adapter.zepto.js']
				},
				
				// add swfobject from CDN, onComplete: attach appropriate swf
				{
					test: !Modernizr.mobilewebkit && Modernizr.flash && useFlash,
					yep: ['//ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js'],
					complete: function(){
						if(swfobject){
							var flashvars = { 
									startPage:  "<?php echo(implode('/', url_parts())); ?>",
									globalURL: "<?php echo($base_path); ?>"
								},
								params = { allowFullScreen: true, allowScriptAccess: "always" },
								attributes = { id: FLASH_ID };
							
							swfobject.embedSWF(baseURL + 'swf/Main.swf', 'main', "100%", "100%", version, baseURL + 'swf/expressInstall.swf', flashvars, params, attributes);
						}
					}
				},
				
				// add history.js by default: enables fallback to hashbangs
				baseURL + 'js/lib/history.js',
				baseURL + 'js/mylibs/history.bridge.flash.js',
				
				// finally, your custom scripting
				baseURL + 'js/Main.js'
			]);
		// ]]>
	</script>
</head>
<body>

<?php flush(); ?>