/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import flash.events.Event;
	
	
	/**
	 * IMacroCommand
	 * 
	 * @author David Massenot
	 */
	public interface IMacroCommand {
		function execute(event:Event):void
		function destroy():void
		function set command(value:ICommand):void
		function get command():ICommand
		function get id():String
	}
}