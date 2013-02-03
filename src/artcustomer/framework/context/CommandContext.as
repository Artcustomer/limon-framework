/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.component.Component;
	import artcustomer.framework.events.FrameworkCommandEvent;
	import artcustomer.framework.errors.*;
	
	[Event(name = "sendCommand", type = "artcustomer.framework.events.FrameworkCommandEvent")]
	
	
	/**
	 * CommandContext
	 * 
	 * @author David Massenot
	 */
	public class CommandContext extends EventContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::CommandContext';
		
		
		/**
		 * Constructor
		 */
		public function CommandContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_COMMANDCONTEXT_CONSTRUCTOR);
		}
		
		
		/**
		 * Dispatch Event for Command.
		 * 
		 * @param	event
		 * @param	macroCommandID
		 * @return
		 */
		public function dispatchCommand(event:Event, component:Component, macroCommandID:String):Boolean {
			return this.dispatchEvent(new FrameworkCommandEvent(FrameworkCommandEvent.SEND_COMMAND, false, false, event, component, macroCommandID));
		}
		
		/**
		 * Setup CommandContext.
		 */
		override public function setup():void {
			super.setup();
		}
		
		/**
		 * Destroy CommandContext.
		 */
		override public function destroy():void {
			super.destroy();
		}
	}
}
