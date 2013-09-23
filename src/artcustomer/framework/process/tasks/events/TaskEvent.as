/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.process.tasks.events {
	import flash.events.Event;
	
	
	/**
	 * TaskEvent
	 * 
	 * @author David Massenot
	 */
	public class TaskEvent extends Event {
		public static const ON_START_TASK:String = 'onStartTask';
		public static const ON_END_TASK:String = 'onEndTask';
		public static const ON_ERROR_TASK:String = 'onErrorTask';
		
		private var _index:int;
		private var _description:String;
		private var _error:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	index
		 * @param	description
		 * @param	error
		 */
		public function TaskEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = 0, description:String = null, error:String = null) {
			_index = index;
			_description = description;
			_error = error;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone TaskEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new TaskEvent(type, bubbles, cancelable, _index, _description, _error);
		}
		
		/**
		 * Get String format of event.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("TaskEvent", "type", "bubbles", "cancelable", "eventPhase", "index", "description", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * @private
		 */
		public function get description():String {
			return _description;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}