/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.component {
	import flash.events.Event;
	
	import artcustomer.framework.context.IContext;
	import artcustomer.framework.core.*;
	
	
	/**
	 * IComponent
	 * 
	 * @author David Massenot
	 */
	public interface IComponent {
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		function hasEventListener(type:String):Boolean
		function dispatchEvent(e:Event):Boolean;
		function dispatchCommand(event:Event, macroCommandID:String):void
		function getViewByID(id:String):IView
		function getViewByIndex(index:int):IView
		function hasViewByID(id:String):Boolean
		function hasViewByIndex(index:int):Boolean
		function get id():String
		function get index():int
		function get context():IContext
		function get model():IModel
		function get command():ICommand
		function get numViews():int
	}
}