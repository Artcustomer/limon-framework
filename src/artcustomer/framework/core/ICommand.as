/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import artcustomer.framework.events.FrameworkCommandEvent;
	
	
	/**
	 * ICommand
	 * 
	 * @author David Massenot
	 */
	public interface ICommand {
		function setup():void
		function reset():void
		function destroy():void
		function execute(e:FrameworkCommandEvent):void
		function set model(value:IModel):void
		function get model():IModel
	}
}