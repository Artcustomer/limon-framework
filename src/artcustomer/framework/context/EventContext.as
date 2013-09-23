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
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * EventContext
	 * 
	 * @author David Massenot
	 */
	public class EventContext implements IEventDispatcher, IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::EventContext';
		
		private var _context:BaseContext;
		private var _eventDispatcher:IEventDispatcher;
		
		private var _allowSetContext:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function EventContext() {
			_context = null;
			_eventDispatcher = new EventDispatcher(this);
			_allowSetContext = true;
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_EVENTCONTEXT_CONSTRUCTOR);
		}
		
		
		/**
		 * Add an eventListener.
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
		 * Remove an eventlistener.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Test an eventlistener.
		 * 
		 * @param	type
		 * @return
		 */
		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * Test event trigger.
		 * 
		 * @param	type
		 * @return
		 */
		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}
		
		/**
		 * Dispatch an event.
		 * 
		 * @param	e
		 * @return
		 */
		public function dispatchEvent(e:Event):Boolean {
 		    if (_eventDispatcher.hasEventListener(e.type)) return this.eventDispatcher.dispatchEvent(e);
			
 		 	return false;
		}
		
		/**
		 * Setup EventContext.
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destroy EventContext.
		 */
		public function destroy():void {
			_context = null;
			_eventDispatcher = null;
			_allowSetContext = false;
		}
		
		
		/**
		 * @private
		 */
		public function get eventDispatcher():IEventDispatcher {
			return _eventDispatcher;
		}
		
		/**
		 * @private
		 */
		public function set instance(value:BaseContext):void {
			if (_allowSetContext) {
				_context = value;
				
				_allowSetContext = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get instance():BaseContext {
			return _context;
		}
	}
}