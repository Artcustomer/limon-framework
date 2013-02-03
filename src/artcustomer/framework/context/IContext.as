/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import artcustomer.framework.component.Component;
	
	
	/**
	 * IContext
	 * 
	 * @author David Massenot
	 */
	public interface IContext{
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		function hasEventListener(type:String):Boolean
		function dispatchEvent(e:Event):Boolean;
		function dispatchCommand(event:Event, component:Component, macroCommandID:String):Boolean;
		function get eventDispatcher():IEventDispatcher;
		function get contextView():DisplayObjectContainer;
		function get contextWidth():int;
		function get contextHeight():int;
		function get instance():Context;
	}
}