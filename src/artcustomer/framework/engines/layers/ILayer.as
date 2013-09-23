/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers {
	import artcustomer.framework.context.IContext;
	
	
	/**
	 * ILayer
	 * 
	 * @author David Massenot
	 */
	public interface ILayer {
		function setup():void
		function destroy():void
		function onRender():void
		function onResize():void
		function get context():IContext
		function get index():int
	}
}