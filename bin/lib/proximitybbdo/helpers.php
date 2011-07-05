<?php
# ============================================================================ #
/**
 * Proximity Framwork Helpers 
 * 
 * v0.01
 * @package proximitybbdo
 *
 * These functions are generic helpers that can be used throughout the framework
 * They can be called from everywhere since they are loaded from the moment
 * the app starts.
 */
# ============================================================================ #

/**
 * Logs input to the console (if available, won't crash on IE)
 * 
 * @param $msg  the input for the log, can be anything from a string to an object
 *              try me :)
 */
function _log($msg) {
  $out = "<script>//<![CDATA[\n";
  $out .= 'if(this.console) {';
  $out .= 'console.dir(' . json_encode($msg) . '); }';
  $out .= "\n//]]></script>";

  echo($out);
}

