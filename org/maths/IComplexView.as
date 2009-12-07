package org.maths {
	
import org.maths.Complex;

public interface IComplexView {

	/**
	* This interface defines some geometric view of Complex numbers 
	*/
	//function clear():Void;
	
	/**
	 * Reset the any global view properties on ComplexState reset
	 * Called before (re)reading the Plex script
	 */
	function reset():void;
	
	/** 
	 * If all C is included in the view, then return true.
	 * i.e. True for spherical view unless back surface is hidden completely.
	 * False for planar view because window will clip the plane.
	 */
	function allPointsVisible():Boolean;
	
	/**
	 * True if screen coords are on screen
	 */
	function onScreen(screen:Complex):Boolean;
	
	/**
	 * True if an z is visible on screen
	 */
	function reallyVisible(z:Complex):Boolean;
	
	/** 
	 * Translate complex z to screen coordinates
	 */
	function complexToScreen(z:Complex):Complex;

	/**
	 * Translate screen coordinates to complex z
	 */
	function screenToComplex(z:Complex):Complex;
	
	/**
	 * Translate complex delta to screen delta
	 */
	function deltaToScreen(z:Complex):Complex;

	/**
	 * Translate screen delta to complex delta
	 */
	function screenToDelta(z:Complex):Complex;
	
	/**
	 * display a status message for interval milliseconds
	 */
	function statusMessage(msg:String, interval:Number):void;
	
	/**
	 * clear the status message
	 */
	function clearMessage():void;
	
	}
}