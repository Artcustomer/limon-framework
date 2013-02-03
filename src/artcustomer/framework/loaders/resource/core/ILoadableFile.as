/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.core {
	
	
	/**
	 * ILoadableFile
	 * 
	 * @author David Massenot
	 */
	public interface ILoadableFile {
		function startLoading():void;
		function closeLoading():void;
		function destroy():void;
		function get id():int;
		function get file():String;
		function get path():String;
		function get group():String;
		function get stackName():String;
		function get stackDescription():String;
		function get bytesLoaded():Number;
		function get bytesTotal():Number;
		function get percent():Number;
		function get status():int
		function get data():*
		function get bytes():*
		function get isAlreadyLoaded():Boolean
		function set id(value:int):void;
		function set file(value:String):void;
		function set path(value:String):void;
		function set group(value:String):void;
		function set stackName(value:String):void
		function set stackDescription(value:String):void
	}
}