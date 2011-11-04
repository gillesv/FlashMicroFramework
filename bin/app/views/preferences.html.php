<form action="<?php echo(url_for('/preferences/save')); ?>" id="preferences" method="post">
	<h1>This website is designed to be an immersive experience</h1>
	
	<p>The best experience requires the use of the Flash player plugin. However, all content is perfectly accessible with just a modern HTML5-compliant browser.</p>
	
	<h3>Make your choice</h3>
	
	<fieldset>
		<div class="checkboxes">
			<ul>
				<li><input type="radio" id="splash_choice_yes" name="choice" value="yes" checked /> 	<label for="splash_choice_yes">Use Flash</label></li>
				<li><input type="radio" id="splash_choice_no" name="choice" value="no" /> 	<label for="splash_choice_no">Just give me the content</label></li>
			</ul>
		</div>
		
		<input type="submit" value="Submit" />
	</fieldset>
</form>