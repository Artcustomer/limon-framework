/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.context.IContext;
	
	
	/**
	 * ContextEvent
	 * 
	 * @author David Massenot
	 */
	public class ContextEvent extends Event {
		public static const CONTEXT_SETUP:String = 'contextSetup';
		public static const CONTEXT_RESET:String = 'contextReset';
		public static const CONTEXT_DESTROY:String = 'contextDestroy';
		
		private var _name:String;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	name
		 * @param	contextWidth
		 * @param	contextHeight
		 * @param	stageWidth
		 * @param	stageHeight
		 */
		public function ContextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, name:String = null, contextWidth:int = 0, contextHeight:int = 0, stageWidth:int = 0, stageHeight:int = 0) {
			_name = name;
			_contextWidth = contextWidth;
			_contextHeight = contextHeight;
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone ContextEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new ContextEvent(type, bubbles, cancelable, _name, _contextWidth, _contextHeight, _stageWidth, _stageHeight);
		}
		
		/**
		 * Get String value of ContextEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("ContextEvent", "type", "bubbles", "cancelable", "eventPhase", "name", "contextWidth", "contextHeight", "stageWidth", "stageHeight"); 
		}
		
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function get contextWidth():int {
			return _contextWidth;
		}
		
		/**
		 * @private
		 */
		public function get contextHeight():int {
			return _contextHeight;
		}
		
		/**
		 * @private
		 */
		public function get stageWidth():int {
			return _stageWidth;
		}
		
		/**
		 * @private
		 */
		public function get stageHeight():int {
			return _stageHeight;
		}
	}
}