/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import artcustomer.framework.core.IModel;
	
	
	/**
	 * IMacroModel
	 * 
	 * @author David Massenot
	 */
	public interface IMacroModel{
		function setup():void
		function init():void
		function reset():void
		function update():void
		function destroy():void
		function set model(value:IModel):void
		function get model():IModel
		function get id():String
	}
}