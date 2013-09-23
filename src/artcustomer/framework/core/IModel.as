/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import artcustomer.framework.context.*;
	import artcustomer.framework.engines.component.*;
	import artcustomer.framework.data.IViewData;
	
	
	/**
	 * IModel
	 * 
	 * @author David Massenot
	 */
	public interface IModel {
		function setup():void
		function reset():void
		function destroy():void
		function init():void
		function update(updateType:String, data:IViewData, viewID:String = null, isViewSetup:Boolean = true):void
		function hasregisterModel(id:String):Boolean
		function getModel(id:String):IMacroModel
		function get context():IContext
		function get component():IComponent
		function get numModels():int
	}
}