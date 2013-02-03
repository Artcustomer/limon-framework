/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import artcustomer.framework.loaders.resource.data.FileManager;
	import artcustomer.framework.loaders.resource.events.*;
	import artcustomer.framework.loaders.resource.utils.consts.*;
	
	[Event(name = "onFileError", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	[Event(name = "onFileProgress", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	[Event(name = "onFileComplete", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	
	
	/**
	 * LoadableFile
	 * 
	 * @author David Massenot
	 */
	public class LoadableFile extends EventDispatcher {
		protected var _id:int;
		protected var _file:String;
		protected var _folder:String;
		protected var _group:String;
		protected var _stackName:String;
		protected var _stackDescription:String;
		protected var _bytesLoaded:Number = 0;
		protected var _bytesTotal:Number = 0;
		protected var _percent:Number = 0;
		protected var _error:String;
		protected var _status:int;
		protected var _data:*;
		protected var _bytes:*;
		protected var _isLoading:Boolean;
		protected var _isOpenStream:Boolean;
		protected var _isAlreadyLoaded:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function LoadableFile() {
			_status = LoaderStatus.WAITING;
			_isOpenStream = false;
			_isLoading = false;
			_isAlreadyLoaded = false;
		}
		
		/**
		 * Start file loading.
		 */
		protected function startLoadingFile():void {
			_status = LoaderStatus.LOADING;
			_isOpenStream = true;
		}
		
		/**
		 * Called when an error is detected.
		 */
		protected function errorHandler():void {
			_status = LoaderStatus.FAILED;
			_isLoading = false;
			_isOpenStream = false;
			_isAlreadyLoaded = false;
			
			this.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_FILE_ERROR, true, false, _stackName, _stackDescription, (this as ILoadableFile), _bytesLoaded, _bytesTotal, _percent, _error));
		}
		
		/**
		 * Called on loading progess.
		 */
		protected function progressHandler():void {
			_status = LoaderStatus.LOADING;
			
			this.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_FILE_PROGRESS, false, false, _stackName, _stackDescription, (this as ILoadableFile), _bytesLoaded, _bytesTotal, _percent, _error));
		}
		
		/**
		 * Called when loading is completed.
		 */
		protected function completeHandler():void {
			_status = LoaderStatus.COMPLETED;
			_isLoading = true;
			_isOpenStream = false;
			_isAlreadyLoaded = true;
			
			this.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_FILE_COMPLETE, false, false, _stackName, _stackDescription, (this as ILoadableFile), _bytesLoaded, _bytesTotal, _percent, _error));
		}
		
		
		/**
		 * Return estimate extension.
		 */
		public function getExtension():String {
			return FileManager.getInstance().getExtension(_file);
		}
		
		/**
		 * Return estimate MimeType.
		 */
		public function getMimeType():String {
			return FileManager.getInstance().getMimeType(_file);
		}
		
		/**
		 * Release instance.
		 */
		public function destroy():void {
			_id = 0;
			_file = null;
			_folder = null;
			_group = null;
			_stackName = null;
			_stackDescription = null;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_percent = 0;
			_error = null;
			_status = 0;
			_data = null;
			_bytes = null;
			_isLoading = false;
			_isOpenStream = false;
			_isAlreadyLoaded = false;
		}
		
		
		/**
		 * @private
		 */
		public function set id(value:int):void {
			_id = value;
		}
		
		/**
		 * @private
		 */
		public function set file(value:String):void {
			_file = value;
		}
		
		/**
		 * @private
		 */
		public function set path(value:String):void {
			_folder = value;
		}
		
		/**
		 * @private
		 */
		public function set group(value:String):void {
			_group = value;
		}
		
		/**
		 * @private
		 */
		public function set stackName(value:String):void {
			_stackName = value;
		}
		
		/**
		 * @private
		 */
		public function set stackDescription(value:String):void {
			_stackDescription = value;
		}
		
		/**
		 * @private
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * @private
		 */
		public function get file():String {
			return _file;
		}
		
		/**
		 * @private
		 */
		public function get path():String {
			return _folder;
		}
		
		/**
		 * @private
		 */
		public function get group():String {
			return _group;
		}
		
		/**
		 * @private
		 */
		public function get stackName():String {
			return _stackName;
		}
		
		/**
		 * @private
		 */
		public function get stackDescription():String {
			return _stackDescription;
		}
		
		/**
		 * @private
		 */
		public function get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		/**
		 * @private
		 */
		public function get bytesTotal():Number {
			return _bytesTotal;
		}
		
		/**
		 * @private
		 */
		public function get percent():Number {
			return _percent;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
		
		/**
		 * @private
		 */
		public function get status():int {
			return _status;
		}
		
		/**
		 * @private
		 */
		public function get data():* {
			return _data;
		}
		
		/**
		 * @private
		 */
		public function get bytes():* {
			return _bytes;
		}
		
		/**
		 * @private
		 */
		public function get isLoading():Boolean {
			return _isLoading;
		}
		
		/**
		 * @private
		 */
		public function get isOpenStream():Boolean {
			return _isOpenStream;
		}
		
		/**
		 * @private
		 */
		public function get isAlreadyLoaded():Boolean {
			return _isAlreadyLoaded;
		}
	}
}