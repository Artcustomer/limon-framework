/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.display {
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.component.Component;
	import artcustomer.framework.events.FrameworkEvent;
	import artcustomer.framework.errors.FrameworkError;
	
	
	/**
	 * DisplayContainer
	 * 
	 * @author David Massenot
	 */
	public class DisplayContainer extends Sprite implements IDestroyable {
		private var _component:Component;
		private var _objectParent:DisplayObjectContainer;
		
		private var _allowSetComponent:Boolean;
		private var _allowSetParent:Boolean;
		private var _isSetup:Boolean;
		
		
		/**
		 * Constructor : Create a DisplayContainer.
		 * 
		 * @param	component
		 * @param	objectParent
		 */
		public function DisplayContainer(component:Component = null, objectParent:DisplayObjectContainer = null) {
			_component = component;
			_objectParent = objectParent;
			
			_allowSetComponent = true;
			_allowSetParent = true;
			
			if (_component) {
				_allowSetComponent = false;
				
				this.setup();
			}
			
			if (_objectParent) _allowSetParent = false;
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			this.component.context.instance.addEventListener(FrameworkEvent.FRAMEWORK_RESIZE, handleFramework, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			this.component.context.instance.removeEventListener(FrameworkEvent.FRAMEWORK_RESIZE, handleFramework);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleFramework(e:FrameworkEvent):void {
			switch (e.type) {
				case('frameworkResize'):
					resize();
					break;
			}
		}
		
		
		/**
		 * Destroy DisplayContainer. Must be overrided and called at last in child !
		 */
		public function setup():void {
			if (_isSetup) return;
			if (!_component) throw new FrameworkError(FrameworkError.E_DISPLAYCONTAINER_SETUP);
			
			listenEvents();
			
			_isSetup = true;
		}
		
		/**
		 * Destroy DisplayContainer. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			if (!_isSetup) throw new FrameworkError(FrameworkError.E_DISPLAYCONTAINER_DESTROY);
			
			clean();
			remove();
			unlistenEvents();
			
			_component = null;
			_objectParent = null;
			_allowSetComponent = false;
			_allowSetParent = false;
			_isSetup = false;
		}
		
		/**
		 * Reset DisplayContainer.
		 */
		public function reset():void {
			
		}
		
		/**
		 * Update DisplayContainer.
		 */
		public function update():void {
			
		}
		
		/**
		 * Resize DisplayContainer.
		 */
		public function resize():void {
			
		}
		
		/**
		 * Move DisplayContainer.
		 * 
		 * @param	x
		 * @param	y
		 */
		public function move(x:int = 0, y:int = 0):void {
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Add DisplayContainer to display list.
		 */
		public function add():void {
			if (!_objectParent) _objectParent = _component.viewPort;
			if (!_objectParent.contains(this)) _objectParent.addChild(this);
		}
		
		/**
		 * Remove DisplayContainer from display list.
		 */
		public function remove():void {
			if (this.parent) this.parent.removeChild(this);
		}
		
		/**
		 * Remove childs in DisplayContainer.
		 */
		public function clean():void {
			while (this.numChildren) {
				this.removeChildAt(0);
			}
		}
		
		
		/**
		 * @private
		 */
		public function set component(value:Component):void {
			if (_allowSetComponent) {
				_component = value;
				
				_allowSetComponent = false;
			}
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
		public function set objectParent(value:DisplayObjectContainer):void {
			if (_allowSetParent) {
				_objectParent = value;
				
				_allowSetParent = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get objectParent():DisplayObjectContainer {
			return _objectParent;
		}
	}
}