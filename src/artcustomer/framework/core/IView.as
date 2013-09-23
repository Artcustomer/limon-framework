/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import artcustomer.framework.engines.component.IComponent;
	import artcustomer.framework.data.IViewData;
	
	
	/**
	 * IView
	 * 
	 * @author David Massenot
	 */
	public interface IView {
		function setup():void
		function reset():void
		function destroy():void
		function add():void
		function remove():void
		function init():void
		function update(updateType:String, data:IViewData):void
		function resize():void
		function move(pX:int = 0, pY:int = 0):void
		function set id(value:String):void
		function get id():String
		function set index(value:int):void
		function get index():int
		function set component(value:IComponent):void
		function get component():IComponent
		function get isSetup():Boolean
		function get isReset():Boolean
	}
}