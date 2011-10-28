<?php _log($content['keys']); ?>

<?php 
	$tag = $content['tag'];
	$render = '';
 ?>


<?php foreach($content['keys'] as $key): ?>
	
	<?php if(is_array()): ?>
		<?php $render.= $key['text']; ?>
	<?php else: ?>
		<?php $render.= Markdown($key); ?>
	<?php endif; ?>
		
<?php endforeach; ?>

<?php echo $render; ?>