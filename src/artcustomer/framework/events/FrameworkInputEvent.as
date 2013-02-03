/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import artcustomer.framework.context.IContext;
	
	
	/**
	 * FrameworkInputEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkInputEvent extends Event {
		public static const INPUT_KEY_PRESS:String = 'inputKeyPress';
		public static const INPUT_KEY_RELEASE:String = 'inputKeyRelease';
		public static const INPUT_KEY_REPEAT:String = 'inputKeyRepeat';
		public static const INPUT_KEY_FAST_REPEAT:String = 'inputKeyFastRepeat';
		public static const INPUT_MOUSE_ROLL_OVER:String = 'inputMouseRollOver';
		public static const INPUT_MOUSE_ROLL_OUT:String = 'inputMouseRollOut';
		public static const INPUT_MOUSE_OVER:String = 'inputMouseOver';
		public static const INPUT_MOUSE_OUT:String = 'inputMouseOut';
		public static const INPUT_MOUSE_MOVE:String = 'inputMouseMove';
		public static const INPUT_MOUSE_DOWN:String = 'inputMouseDown';
		public static const INPUT_MOUSE_UP:String = 'inputMouseUp';
		public static const INPUT_MOUSE_CLICK:String = 'inputMouseClick';
		public static const INPUT_MOUSE_DOUBLECLICK:String = 'inputMouseDoubleClick';
		public static const INPUT_MOUSE_WHEEL_UP:String = 'inputMouseWheelUp';
		public static const INPUT_MOUSE_WHEEL_DOWN:String = 'inputMouseWheelDown';
		public static const INPUT_MOUSE_LEAVE:String = 'inputMouseLeave';
		
		private var _context:IContext;
		private var _mouseEvent:MouseEvent;
		private var _keyboardEvent:KeyboardEvent;
		private var _keyCode:uint;
		private var _charCode:uint;
		private var _keyName:String;
		private var _mouseX:int;
		private var _mouseY:int;
		private var _mouseDelta:int;
		
		
		public function FrameworkInputEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, context:IContext = null, mouseEvent:MouseEvent = null, keyboardEvent:KeyboardEvent = null, keyCode:uint = 0, charCode:uint = 0, keyName:String = null, mouseX:int = 0, mouseY:int = 0, mouseDelta:int = 0) {
			_context = context;
			_mouseEvent = mouseEvent;
			_keyboardEvent = keyboardEvent;
			_keyCode = keyCode;
			_charCode = charCode;
			_keyName = keyName;
			_mouseX = mouseX;
			_mouseY = mouseY;
			_mouseDelta = mouseDelta;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkInputEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkInputEvent(type, bubbles, cancelable, this.context, this.mouseEvent, this.keyboardEvent, this.keyCode, this.charCode, this.keyName, this.mouseX, this.mouseY, this.mouseDelta);
		}
		
		/**
		 * Get String value of FrameworkInputEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkInputEvent", "type", "bubbles", "cancelable", "eventPhase", "context", "mouseEvent", "keyboardEvent", "keyCode", "charCode", "keyName", "mouseX", "mouseY", "mouseDelta");
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
		public function get mouseEvent():MouseEvent {
			return _mouseEvent;
		}
		
		/**
		 * @private
		 */
		public function get keyboardEvent():KeyboardEvent {
			return _keyboardEvent;
		}
		
		/**
		 * @private
		 */
		public function get keyCode():uint {
			return _keyCode;
		}
		
		/**
		 * @private
		 */
		public function get charCode():uint {
			return _charCode;
		}
		
		/**
		 * @private
		 */
		public function get keyName():String {
			return _keyName;
		}
		
		/**
		 * @private
		 */
		public function get mouseX():int {
			return _mouseX;
		}
		
		/**
		 * @private
		 */
		public function get mouseY():int {
			return _mouseY;
		}
		
		/**
		 * @private
		 */
		public function get mouseDelta():int {
			return _mouseDelta;
		}
	}
}