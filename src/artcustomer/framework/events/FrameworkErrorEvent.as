/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	
	/**
	 * FrameworkErrorEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkErrorEvent extends Event {
		public static const ERROR:String = 'error';
		public static const FRAMEWORK_ERROR:String = 'frameworkError';
		public static const ILLEGAL_ERROR:String = 'illegalError';
		
		private var _error:Error;
		private var _errorName:String;
		
		
		public function FrameworkErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, error:Error = null, errorName:String = null) {
			_error = error;
			_errorName = errorName;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkErrorEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkErrorEvent(type, bubbles, cancelable, this.error, this.errorName);
		}
		
		/**
		 * Get String value of FrameworkErrorEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkErrorEvent", "type", "bubbles", "cancelable", "eventPhase", "error", "errorName"); 
		}
		
		
		/**
		 * @private
		 */
		public function get error():Error {
			return _error;
		}
		
		/**
		 * @private
		 */
		public function get errorName():String {
			return _errorName;
		}
	}
}