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
	
	import artcustomer.framework.engines.component.*;
	import artcustomer.framework.data.IViewData;
	import artcustomer.framework.errors.IllegalError;
	import artcustomer.framework.events.*;
	
	[Event(name = "viewSetup", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewReset", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewDestroy", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewAdd", type = "artcustomer.framework.events.FrameworkViewEvent")]
	[Event(name = "viewRemove", type = "artcustomer.framework.events.FrameworkViewEvent")]
	
	
	/**
	 * AbstractFlashView
	 * 
	 * @author David Massenot
	 */
	public class AbstractFlashView implements IView {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractFlashView';
		
		private var _id:String;
		private var _index:int;
		private var _component:FlashComponent;
		private var _objectParent:DisplayObjectContainer;
		
		private var _viewContainer:Sprite;
		
		private var _isSetup:Boolean;
		private var _isReset:Boolean;
		private var _allowSetID:Boolean;
		private var _allowSetIndex:Boolean;
		private var _allowSetComponent:Boolean;
		private var _allowSetParent:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractFlashView() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_ABSTRACTVIEW_CONSTRUCTOR);
			
			_isSetup = false;
			_isReset = false;
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
				_objectParent = _component.viewPort;
				
				setupViewContainer();
			}
			
			_isReset = false;
		}
		
		/**
		 * Reset View. Can be overrided.
		 */
		public function reset():void {
			_isReset = true;
		}
		
		/**
		 * Reset View. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			remove();
			destroyViewContainer();
			
			_id = null;
			_index = 0;
			_component = null;
			_objectParent = null;
			_viewContainer = null;
			_isSetup = false;
			_isReset = false;
			_allowSetID = false;
			_allowSetIndex = false;
			_allowSetComponent = false;
			_allowSetParent = false;
		}
		
		/**
		 * Add View to parent.
		 */
		public function add():void {
			if (_objectParent && _viewContainer) if (!_objectParent.contains(_viewContainer)) _objectParent.addChild(_viewContainer);
		}
		
		/**
		 * Remove View from parent.
		 */
		public function remove():void {
			if (_objectParent && _viewContainer) if (_objectParent.contains(_viewContainer)) _objectParent.removeChild(_viewContainer);
		}
		
		/**
		 * Init View. Can be overrided.
		 */
		public function init():void {
			
		}
		
		/**
		 * Update View. Must be overrided.
		 * 
		 * @param	updateType
		 * @param	data
		 */
		public function update(updateType:String, data:IViewData):void {
			
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
		 * Listen an event from Context.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function addContextEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_component.context.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Unlisten an event from Context.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public function removeContextEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_component.context.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Listen an event from Component.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function addComponentEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_component.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Unlisten an event from Component.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public function removeComponentEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_component.removeEventListener(type, listener, useCapture);
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
		public function set component(value:IComponent):void {
			if (_allowSetComponent) {
				_component = value as FlashComponent;
				
				_allowSetComponent = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get component():IComponent {
			return _component;
		}
		
		/**
		 * @private
		 */
		public function set objectParent(value:DisplayObjectContainer):void {
			if (_allowSetParent) {
				_objectParent;
				
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
		
		/**
		 * @private
		 */
		public function get isReset():Boolean {
			return _isReset;
		}
	}
}