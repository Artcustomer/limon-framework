/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import flash.events.Event;
	
	
	/**
	 * ICommand
	 * 
	 * @author David Massenot
	 */
	public interface ICommand {
		function setup():void
		function reset():void
		function destroy():void
		function execute(event:Event, macroCommandID:String):void
		function hasregisterMacro(id:String):Boolean
		function getMacro(id:String):IMacroCommand
		function set model(value:IModel):void
		function get model():IModel
	}
}