/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.*;
	
	[Event(name = "inputKeyRelease", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputKeyRepeat", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputKeyFastRepeat", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseRollOver", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseRollOut", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseOver", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseOut", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseMove", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseDown", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseUp", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseClick", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseDoubleClick", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseWheelUp", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseWheelDown", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseLeave", type = "artcustomer.framework.events.InputsEvent")]
	
	
	/**
	 * CrossPlatformInputsContext
	 * 
	 * @author David Massenot
	 */
	public class CrossPlatformInputsContext extends InteractiveContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::CrossPlatformInputsContext';
		
		private var _keyInputCounter:int;
		private var _keyInputRepeatDelay:int;
		private var _keyInputFastRepeatDelay:int;
		
		private var _isKeyReleased:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function CrossPlatformInputsContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_CROSSPLATFORMINPUTSCONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 10;
			_keyInputFastRepeatDelay = 2;
			_isKeyReleased = false;
		}
		
		//---------------------------------------------------------------------
		//  StageEvents
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenStageEvents():void {
			this.contextView.stage.addEventListener(Event.MOUSE_LEAVE, handleStage, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.ROLL_OUT, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.ROLL_OVER, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_OVER, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_OUT, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.CLICK, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.DOUBLE_CLICK, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleStageMouse, false, 0, true);
			this.contextView.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys, false, 0, true);
			this.contextView.stage.addEventListener(KeyboardEvent.KEY_UP, handleStageKeys, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenStageEvents():void {
			this.contextView.stage.removeEventListener(Event.MOUSE_LEAVE, handleStage);
			this.contextView.stage.removeEventListener(MouseEvent.ROLL_OVER, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.ROLL_OUT, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_OVER, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_OUT, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.CLICK, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, handleStageMouse);
			this.contextView.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, handleStageMouse);
			this.contextView.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys);
			this.contextView.stage.removeEventListener(KeyboardEvent.KEY_UP, handleStageKeys);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStage(e:Event):void {
			switch (e.type) {
				case(Event.MOUSE_LEAVE):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_LEAVE, false, false));
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageMouse(e:MouseEvent):void {
			switch (e.type) {
				case(MouseEvent.ROLL_OVER):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_ROLL_OVER, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.ROLL_OUT):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_ROLL_OUT, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
				
				case(MouseEvent.MOUSE_OVER):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_OVER, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_OUT):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_OUT, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_MOVE):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_MOVE, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_DOWN):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_DOWN, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_UP):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_UP, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.CLICK):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_CLICK, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.DOUBLE_CLICK):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_DOUBLECLICK, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_WHEEL):
					if (e.delta > 0) {
						this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_WHEEL_UP, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					} else {
						this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_WHEEL_DOWN, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					}
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageKeys(e:KeyboardEvent):void {
			switch (e.type) {
				case(KeyboardEvent.KEY_DOWN):
					if (!_isKeyReleased) {
						this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_RELEASE, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
						
						_isKeyReleased = true;
					}
					
					_keyInputCounter++;
					
					if (_keyInputCounter % _keyInputRepeatDelay == 0) this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_REPEAT, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
					if (_keyInputCounter % _keyInputFastRepeatDelay == 0) this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_FAST_REPEAT, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
					break;
					
				case(KeyboardEvent.KEY_UP):
					_keyInputCounter = 0;
					_isKeyReleased = false;
					
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_PRESS, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Setup CrossPlatformInputsContext.
		 */
		override public function setup():void {
			init();
			
			super.setup();
			
			listenStageEvents();
		}
		
		/**
		 * Destroy CrossPlatformInputsContext.
		 */
		override public function destroy():void {
			unlistenStageEvents();
			
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 0;
			_keyInputFastRepeatDelay = 0;
			_isKeyReleased = false;
			
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
		public function set keyInputRepeatDelay(value:int):void {
			_keyInputRepeatDelay = value;
		}
		
		/**
		 * @private
		 */
		public function get keyInputRepeatDelay():int {
			return _keyInputRepeatDelay;
		}
		
		/**
		 * @private
		 */
		public function set keyInputFastRepeatDelay(value:int):void {
			_keyInputFastRepeatDelay = value;
		}
		
		/**
		 * @private
		 */
		public function get keyInputFastRepeatDelay():int {
			return _keyInputFastRepeatDelay;
		}
	}
}