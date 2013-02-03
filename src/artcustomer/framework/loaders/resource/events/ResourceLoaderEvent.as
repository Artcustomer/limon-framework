/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.events {
	import flash.events.Event;
	
	import artcustomer.framework.loaders.resource.core.ILoadableFile;
	
	
	/**
	 * ResourceLoaderEvent
	 * 
	 * @author David Massenot
	 */
	public class ResourceLoaderEvent extends Event {
		public static const ON_FILE_ERROR:String = "onFileError";
		public static const ON_FILE_PROGRESS:String = "onFileProgress";
		public static const ON_FILE_COMPLETE:String = "onFileComplete";
		public static const ON_LOADING_START:String = "onLoadingStart";
		public static const ON_LOADING_CLOSE:String = "onLoadingClose";
		public static const ON_LOADING_ERROR:String = "onLoadingError";
		public static const ON_LOADING_PROGRESS:String = "onLoadingProgress";
		public static const ON_LOADING_COMPLETE:String = "onLoadingComplete";
		
		private var _name:String;
		private var _description:String;
		private var _loadablefile:ILoadableFile;
		private var _bytesLoaded:int;
		private var _bytesTotal:int;
		private var _percent:int;
		private var _error:String;
		private var _stack:Vector.<ILoadableFile>;
		
		
		
		public function ResourceLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, name:String = '', description:String = '', loadablefile:ILoadableFile = null, bytesLoaded:int = 0, bytesTotal:int = 0, percent:int = 0, error:String = null, stack:Vector.<ILoadableFile> = null) {
			_name = name;
			_description = description;
			_loadablefile = loadablefile;
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			_percent = percent;
			_error = error;
			_stack = stack;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone ResourceLoaderEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new ResourceLoaderEvent(type, bubbles, cancelable, this.name, this.description, this.loadablefile, this.bytesLoaded, this.bytesTotal, this.percent, this.error, this.stack);
		} 
		
		/**
		 * Get String value of ResourceLoaderEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("ResourceLoaderEvent", "type", "bubbles", "cancelable", "eventPhase", "name", "description", "loadablefile", "bytesLoaded", "bytesTotal", "percent", "error", "stack"); 
		}
		
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function get description():String {
			return _description;
		}
		
		/**
		 * @private
		 */
		public function get loadablefile():ILoadableFile {
			return _loadablefile;
		}
		
		/**
		 * @private
		 */
		public function get bytesLoaded():int {
			return _bytesLoaded;
		}
		
		/**
		 * @private
		 */
		public function get bytesTotal():int {
			return _bytesTotal;
		}
		
		/**
		 * @private
		 */
		public function get percent():int {
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
		public function get stack():Vector.<ILoadableFile> {
			return _stack;
		}
	}
}