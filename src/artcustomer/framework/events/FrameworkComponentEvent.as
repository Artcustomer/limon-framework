/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.component.Component;
	
	
	/**
	 * FrameworkComponentEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkComponentEvent extends Event {
		public static const COMPONENT_BUILD:String = 'componentBuild';
		public static const COMPONENT_INIT:String = 'componentInit';
		public static const COMPONENT_DESTROY:String = 'componentDestroy';
		public static const COMPONENT_ADD:String = 'componentAdd';
		public static const COMPONENT_REMOVE:String = 'componentRemove';
		
		private var _component:Component;
		
		
		public function FrameworkComponentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, component:Component = null) {
			_component = component;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkComponentEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkComponentEvent(type, bubbles, cancelable, this.component);
		}
		
		/**
		 * Get String value of FrameworkComponentEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkComponentEvent", "type", "bubbles", "cancelable", "eventPhase", "component"); 
		}
		
		
		/**
		 * @private
		 */
		public function get component():Component {
			return _component;
		}
	}
}