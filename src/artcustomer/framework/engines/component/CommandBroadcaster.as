/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.component {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.errors.*;
	
	
	/**
	 * CommandBroadcaster
	 * 
	 * @author David Massenot
	 */
	public class CommandBroadcaster extends AbstractInteractiveComponent {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.component::CommandBroadcaster';
		
		
		/**
		 * Constructor
		 */
		public function CommandBroadcaster() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_COMMANDBORADCASTER_CONSTRUCTOR);
		}
		
		
		/**
		 * Dispatch Event for Command.
		 * 
		 * @param	event
		 * @param	macroCommandID
		 */
		public function dispatchCommand(event:Event, macroCommandID:String):void {
			this.command.execute(event, macroCommandID)
		}
	}
}
