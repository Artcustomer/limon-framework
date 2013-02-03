/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.component.Component;
	import artcustomer.framework.core.IModel;
	
	
	/**
	 * FrameworkCommandEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkCommandEvent extends Event {
		public static const SEND_COMMAND:String = 'sendCommand';
		
		private var _event:Event;
		private var _component:Component;
		private var _macroCommandID:String;
		
		
		public function FrameworkCommandEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, event:Event = null, component:Component = null, macroCommandID:String = null) {
			_event = event;
			_component = component;
			_macroCommandID = macroCommandID;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkCommandEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkCommandEvent(type, bubbles, cancelable, this.event, this.component, this.macroCommandID);
		}
		
		/**
		 * Get String value of FrameworkCommandEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkCommandEvent", "type", "bubbles", "cancelable", "eventPhase", "event", "component", "macroCommandID"); 
		}
		
		
		/**
		 * @private
		 */
		public function get event():Event {
			return _event;
		}
		
		/**
		 * @private
		 */
		public function get component():Component {
			return _component;
		}
		
		/**
		 * @private
		 */
		public function get macroCommandID():String {
			return _macroCommandID;
		}
	}
}