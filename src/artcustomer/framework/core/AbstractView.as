/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.component.Component;
	import artcustomer.framework.errors.IllegalError;
	import artcustomer.framework.events.*;
	
	[Event(name = "viewSetup", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewReset", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewDestroy", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewAdd", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewRemove", type = "artcustomer.framework.events.FrameworkViewEvent")]
	
	
	/**
	 * AbstractView
	 * 
	 * @author David Massenot
	 */
	public class AbstractView extends Object {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractView';
		
		private var _id:String;
		private var _index:int;
		private var _component:Component;
		private var _objectParent:DisplayObjectContainer;
		
		private var _viewContainer:Sprite;
		
		private var _isSetup:Boolean;
		private var _allowSetID:Boolean;
		private var _allowSetIndex:Boolean;
		private var _allowSetComponent:Boolean;
		private var _allowSetParent:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractView() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_ABSTRACTVIEW_CONSTRUCTOR);
			
			_isSetup = false;
			_allowSetID = true;
			_allowSetIndex = true;
			_allowSetComponent = true;
			_allowSetParent = true;
		}
		
		//---------------------------------------------------------------------
		//  View Container
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewContainer():void {
			if (!_viewContainer) _viewContainer = new Sprite();
		}
		
		/**
		 * @private
		 */
		private function destroyViewContainer():void {
			if (_viewContainer) _viewContainer = null;
		}
		
		
		/**
		 * Setup View. Must be overrided and called at first in child !
		 */
		public function setup():void {
			if (!_isSetup) {
				_isSetup = true;
				
				setupViewContainer();
			}
			
			this.component.context.dispatchEvent(new FrameworkViewEvent(FrameworkViewEvent.VIEW_SETUP, false, false, this));
		}
		
		/**
		 * Reset View. Can be overrided.
		 */
		public function reset():void {
			this.component.context.dispatchEvent(new FrameworkViewEvent(FrameworkViewEvent.VIEW_RESET, false, false, this));
		}
		
		/**
		 * Reset View. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			remove();
			destroyViewContainer();
			
			this.component.context.dispatchEvent(new FrameworkViewEvent(FrameworkViewEvent.VIEW_DESTROY, false, false, this));
			
			_id = null;
			_index = 0;
			_component = null;
			_objectParent = null;
			_viewContainer = null;
			_isSetup = false;
			_allowSetID = false;
			_allowSetIndex = false;
			_allowSetComponent = false;
			_allowSetParent = false;
		}
		
		/**
		 * Add View to parent.
		 */
		public function add():void {
			if (_objectParent && _viewContainer) if (!_objectParent.contains(_viewContainer)) {
				_objectParent.addChild(_viewContainer);
				
				this.component.context.dispatchEvent(new FrameworkViewEvent(FrameworkViewEvent.VIEW_ADD, false, false, this));
			}
		}
		
		/**
		 * Remove View from parent.
		 */
		public function remove():void {
			if (_objectParent && _viewContainer) if (_objectParent.contains(_viewContainer)) {
				_objectParent.removeChild(_viewContainer);
				
				this.component.context.dispatchEvent(new FrameworkViewEvent(FrameworkViewEvent.VIEW_REMOVE, false, false, this));
			}
		}
		
		/**
		 * Init View. Can be overrided.
		 */
		public function init():void {
			
		}
		
		/**
		 * Update View. Can be overrided.
		 */
		public function update():void {
			
		}
		
		/**
		 * Resize View. Can be overrided.
		 */
		public function resize():void {
			
		}
		
		/**
		 * Move View.
		 * 
		 * @param	pX
		 * @param	pY
		 */
		public function move(pX:int = 0, pY:int = 0):void {
			_viewContainer.x = pX;
			_viewContainer.y = pY;
		}
		
		/**
		 * Listen an event.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function listenEvent(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			this.component.context.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Stop listen an event.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public function unlistenEvent(type:String, listener:Function, useCapture:Boolean = false):void {
			this.component.context.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Test if an event is listened.
		 * 
		 * @param	type
		 * @return
		 */
		public function haslistenEvent(type:String):Boolean {
			return this.component.context.hasEventListener(type);
		}
		
		
		/**
		 * @private
		 */
		public function set id(value:String):void {
			if (_allowSetID) {
				_id = value;
				
				_allowSetID = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get id():String {
			return _id;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void {
			if (_allowSetIndex) {
				_index = value;
				
				_allowSetIndex = false;
			}
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
		
		/**
		 * @private
		 */
		public function get viewContainer():Sprite {
			return _viewContainer;
		}
		
		/**
		 * @private
		 */
		public function get isSetup():Boolean {
			return _isSetup;
		}
	}
}