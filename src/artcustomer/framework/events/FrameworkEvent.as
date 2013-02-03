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
	 * FrameworkEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkEvent extends Event {
		public static const FRAMEWORK_SETUP:String = 'frameworkSetup';
		public static const FRAMEWORK_RESET:String = 'frameworkReset';
		public static const FRAMEWORK_DESTROY:String = 'frameworkDestroy';
		public static const FRAMEWORK_RESIZE:String = 'frameworkResize';
		public static const FRAMEWORK_NORMAL_SCREEN:String = 'frameworkNormalScreen';
		public static const FRAMEWORK_FULL_SCREEN:String = 'frameworkFullScreen';
		public static const FRAMEWORK_FOCUS_IN:String = 'frameworkFocusIn';
		public static const FRAMEWORK_FOCUS_OUT:String = 'frameworkFocusOut';
		
		private var _context:IContext;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		
		public function FrameworkEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, context:IContext = null, contextWidth:int = 0, contextHeight:int = 0, stageWidth:int = 0, stageHeight:int = 0) {
			_context = context;
			_contextWidth = contextWidth;
			_contextHeight = contextHeight;
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkEvent(type, bubbles, cancelable, this.context, this.contextWidth, this.contextHeight, this.stageWidth, this.stageHeight);
		}
		
		/**
		 * Get String value of FrameworkEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkEvent", "type", "bubbles", "cancelable", "eventPhase", "context", "contextWidth", "contextHeight", "stageWidth", "stageHeight"); 
		}
		
		
		/**
		 * @private
		 */
		public function get context():IContext {
			return _context;
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