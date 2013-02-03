/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.component {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.component.Component;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * EventBroadcaster : Events system available after building Component.
	 * 
	 * @author David Massenot
	 */
	public class EventBroadcaster extends Object implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.component::EventBroadcaster';
		
		private var _component:Component;
		private var _eventDispatcher:IEventDispatcher;
		
		private var _allowSetComponent:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function EventBroadcaster() {
			_allowSetComponent = true;
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_EVENTBORADCASTER_CONSTRUCTOR);
		}
		
		
		/**
		 * Entry point.
		 */
		public function build():void {
			_eventDispatcher = _component.context.eventDispatcher;
		}
		
		/**
		 * Destroy instance.
		 */
		public function destroy():void {
			_component = null;
			_allowSetComponent = false;
		}
		
		/**
		 * Add an eventListener. Call after build Component.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Remove an eventlistener. Call after build Component.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Test an eventlistener. Call after build Component.
		 * 
		 * @param	type
		 * @return
		 */
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * Test event trigger. Call after build Component.
		 * 
		 * @param	type
		 * @return
		 */
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
		
		/**
		 * Dispatch an event. Call after build Component.
		 * 
		 * @param	e
		 * @return
		 */
		public function dispatchEvent(e:Event):Boolean {
 		    if (_eventDispatcher.hasEventListener(e.type)) return _eventDispatcher.dispatchEvent(e);
			
 		 	return false;
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
	}
}