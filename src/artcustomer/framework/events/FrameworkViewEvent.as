/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.core.AbstractView;
	
	
	/**
	 * FrameworkViewEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkViewEvent extends Event {
		public static const VIEW_SETUP:String = 'viewSetup';
		public static const VIEW_RESET:String = 'viewReset';
		public static const VIEW_DESTROY:String = 'viewDestroy';
		public static const VIEW_ADD:String = 'viewAdd';
		public static const VIEW_REMOVE:String = 'viewRemove';
		
		private var _view:AbstractView;
		
		
		public function FrameworkViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, view:AbstractView = null) {
			_view = view;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkViewEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkViewEvent(type, bubbles, cancelable, this.view);
		}
		
		/**
		 * Get String value of FrameworkViewEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkViewEvent", "type", "bubbles", "cancelable", "eventPhase", "view"); 
		}
		
		
		/**
		 * @private
		 */
		public function get view():AbstractView {
			return _view;
		}
	}
}