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
	 * ContextDisplayEvent
	 * 
	 * @author David Massenot
	 */
	public class ContextDisplayEvent extends Event {
		public static const DISPLAY_NORMAL_SCREEN:String = 'displayNormalScreen';
		public static const DISPLAY_FULL_SCREEN:String = 'displayFullScreen';
		
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _displayState:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	contextWidth
		 * @param	contextHeight
		 * @param	stageWidth
		 * @param	stageHeight
		 * @param	displayState
		 */
		public function ContextDisplayEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, contextWidth:int = 0, contextHeight:int = 0, stageWidth:int = 0, stageHeight:int = 0, displayState:String = null) {
			_contextWidth = contextWidth;
			_contextHeight = contextHeight;
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			_displayState = displayState;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone ContextDisplayEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new ContextDisplayEvent(type, bubbles, cancelable, _contextWidth, _contextHeight, _stageWidth, _stageHeight, _displayState);
		}
		
		/**
		 * Get String value of ContextDisplayEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("ContextDisplayEvent", "type", "bubbles", "cancelable", "eventPhase", "contextWidth", "contextHeight", "stageWidth", "stageHeight", "displayState"); 
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
		
		/**
		 * @private
		 */
		public function get displayState():String {
			return _displayState;
		}
	}
}