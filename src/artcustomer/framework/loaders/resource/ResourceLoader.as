/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.loaders.resource.core.*;
	import artcustomer.framework.loaders.resource.data.*;
	import artcustomer.framework.loaders.resource.events.*;
	import artcustomer.framework.loaders.resource.errors.*;
	import artcustomer.framework.loaders.resource.utils.consts.*;
	
	[Event(name = "onLoadingStart", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	[Event(name = "onLoadingClose", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	[Event(name = "onLoadingError", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	[Event(name = "onLoadingProgress", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	[Event(name = "onLoadingComplete", type = "artcustomer.framework.events.ResourceLoaderEvent")]
	
	
	/**
	 * ResourceLoader
	 * 
	 * @author David Massenot
	 */
	public class ResourceLoader extends Object implements IDestroyable {
		private static var __instance:ResourceLoader;
		private static var __allowInstantiation:Boolean;
		
		private var _eventDispatcher:IEventDispatcher;
		
		private var _fileManager:FileManager;
		private var _cacheManager:CacheManager;
		
		private var _stack:Vector.<ILoadableFile>;
		private var _name:String;
		private var _description:String;
		
		private var _index:int;
		private var _loadedFiles:int;
		private var _totalFiles:int;
		
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		private var _totalpercent:Number;
		
		private var _isSetup:Boolean;
		private var _onLoad:Boolean;
		private var _isLoaded:Boolean;
		private var _isUnLoaded:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function ResourceLoader() {
			if (!__allowInstantiation) {
				throw new ResourceLoaderError(ResourceLoaderError.E_RESOURCELOADER_ALLOWINSTANTIATION);
				
				return;
			}
			
			init();
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_loadedFiles = 0;
			_totalFiles = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_totalpercent = 0;
			_name = '';
			_description = '';
			_isSetup = false;
			_onLoad = false;
			_isLoaded = false;
			_isUnLoaded = false;
		}
		
		/**
		 * @private
		 */
		private function reset():void {
			_loadedFiles = 0;
			_totalFiles = _stack.length;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_totalpercent = 0;
			_isSetup = false;
			_onLoad = false;
			_isLoaded = false;
			_isUnLoaded = false;
		}
		
		//---------------------------------------------------------------------
		//  FileManager
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupFileManager():void {
			_fileManager = FileManager.getInstance();
			_fileManager.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyFileManager():void {
			if (_fileManager) {
				_fileManager.destroy();
				_fileManager = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  CacheManager
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupCacheManager():void {
			_cacheManager = CacheManager.getInstance();
			_cacheManager.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyCacheManager():void {
			if (_cacheManager) {
				_cacheManager.destroy();
				_cacheManager = null;
			}
		}
		
		/**
		 * @private
		 */
		private function addResourceInCache(resource:ILoadableFile):void {
			if (_cacheManager) _cacheManager.addResource(resource);
		}
		
		//---------------------------------------------------------------------
		//  Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStack():void {
			if (!_stack) _stack = new Vector.<ILoadableFile>;
		}
		
		/**
		 * @private
		 */
		private function destroyStack():void {
			if (_stack) {
				_stack.length = 0;
				_stack = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  LoadableFiles
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function start():void {
			var loadablefile:ILoadableFile;
			
			for each (loadablefile in _stack) {
				loadablefile.stackName = _name;
				loadablefile.stackDescription = _description;
				
				(loadablefile as LoadableFile).addEventListener(ProgressEvent.PROGRESS, handleProgressLoadableFile, false, 0, true);
				(loadablefile as LoadableFile).addEventListener(ResourceLoaderEvent.ON_FILE_ERROR, handleLoadableFile, false, 0, true);
				(loadablefile as LoadableFile).addEventListener(ResourceLoaderEvent.ON_FILE_COMPLETE, handleLoadableFile, false, 0, true);
				
				if (loadablefile.status == LoaderStatus.WAITING) loadablefile.startLoading();
			}
			
			_eventDispatcher.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_LOADING_START, true, false, _name, _description, null, 0, 0, 0, null, _stack));
			
			_onLoad = true;
		}
		
		/**
		 * @private
		 */
		private function close():void {
			for each (var loadablefile:ILoadableFile in _stack) {
				(loadablefile as LoadableFile).removeEventListener(ProgressEvent.PROGRESS, handleProgressLoadableFile);
				(loadablefile as LoadableFile).removeEventListener(ResourceLoaderEvent.ON_FILE_ERROR, handleLoadableFile);
				(loadablefile as LoadableFile).removeEventListener(ResourceLoaderEvent.ON_FILE_COMPLETE, handleLoadableFile);
				
				loadablefile.closeLoading();
			}
			
			_eventDispatcher.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_LOADING_CLOSE, true, false, _name, _description, null, 0, 0, 0, null, _stack));
			
			_onLoad = false;
		}
		
		/**
		 * @private
		 */
		private function count():void {
			if (_loadedFiles == _totalFiles) {
				var tempStack:Vector.<ILoadableFile> = this.cloneStack();
				
				close();
				destroyStack();
				
				_isLoaded = true;
				_totalpercent = 100;
				_eventDispatcher.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_LOADING_COMPLETE, true, false, _name, _description, null, _bytesLoaded, _bytesTotal, _totalpercent, null, tempStack));
			}
		}
		
		/**
		 * @private
		 */
		private function destroyAllLoadbleFiles():void {
			if (!_stack) return;
			
			var loadablefile:ILoadableFile;
			
			for each (loadablefile in _stack) {
				loadablefile.destroy();
				loadablefile = null;
			}
		}
		
		/**
		 * @private
		 */
		private function handleProgressLoadableFile(e:ProgressEvent):void {
			var loaded:Number = 0;
			var total:Number = 0;
			var percent:Number = 0;
			var loadablefile:ILoadableFile;
			
			for each (loadablefile in _stack) {
				if (loadablefile.status == LoaderStatus.LOADING || loadablefile.status == LoaderStatus.COMPLETED) {
					loaded += loadablefile.bytesLoaded;
					total += loadablefile.bytesTotal;
				}
			}
			
			_bytesLoaded = loaded;
			_bytesTotal = total;
			
			percent = Math.ceil(loaded / total * 100);
			
			if (percent != 0) {
				_totalpercent = percent;
				
				_eventDispatcher.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_LOADING_PROGRESS, true, false, _name, _description, (e.target as ILoadableFile), _bytesLoaded, _bytesTotal, percent, null, this.stack));
			}
		}
		
		/**
		 * @private
		 */
		private function handleLoadableFile(e:ResourceLoaderEvent):void {
			switch (e.type) {
				case('onFileError'):
					_eventDispatcher.dispatchEvent(new ResourceLoaderEvent(ResourceLoaderEvent.ON_LOADING_ERROR, true, false, _name, _description, e.loadablefile, _bytesLoaded, _bytesTotal, _totalpercent, e.error, this.stack));
					break;
					
				case('onFileComplete'):
					addResourceInCache(e.loadablefile);
					handleComplete();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Handlers
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleComplete():void {
			_loadedFiles++;
			
			count();
		}
		
		
		/**
		 * Add file in stack.
		 * 
		 * @param	path : Path of the file
		 * @param	file : Name of the file
		 * @param	group : Group of the file (useful for regrouping multiple assets)
		 * @return
		 */
		public function addResourceInStack(path:String, file:String, group:String = 'assets'):ILoadableFile {
			if (_onLoad) throw new ResourceLoaderError(ResourceLoaderError.E_RESOURCELOADER_ONLOAD);
			
			var loadablefile:ILoadableFile;
			var definition:Class = FileManager.getInstance().getDefinition(file);
			
			setupStack();
			
			if (definition) {
				loadablefile = new definition();
				loadablefile.id = _index;
				loadablefile.file = file;
				loadablefile.path = path;
				loadablefile.group = group;
				
				_stack.push(loadablefile);
				
				_index++;
			} else {
				throw new ResourceLoaderError(ResourceLoaderError.E_FILE_FORMAT);
			}
			
			return loadablefile;
		}
		
		/**
		 * Load files from stack.
		 * 
		 * @param stack : Vector stack of ILoadableFile
		 * @param name : Name of the loading process
		 */
		public function load(name:String = 'resources', description:String = ''):void {
			if (!_stack || _stack.length == 0) throw new ResourceLoaderError(ResourceLoaderError.E_RESOURCELOADER_EMPTY);
			if (_onLoad) throw new ResourceLoaderError(ResourceLoaderError.E_RESOURCELOADER_ONLOAD);
			
			_name = name;
			_description = description;
			_isUnLoaded = false;
			
			reset();
			start();
		}
		
		/**
		 * Unload files on stack.
		 */
		public function unload():void {
			if (_isUnLoaded) return;
			if (!_isLoaded && !_onLoad) throw new ResourceLoaderError(ResourceLoaderError.E_RESOURCELOADER_UNLOAD);
			
			_isUnLoaded = true;
			
			close();
			destroyStack();
		}
		
		/**
		 * Close Stack.
		 * 
		 * @return
		 */
		public function cloneStack():Vector.<ILoadableFile> {
			if (!_stack) return null;
			
			var loadablefile:ILoadableFile;
			var tempLoadablefile:ILoadableFile;
			var tempStack:Vector.<ILoadableFile> = new Vector.<ILoadableFile>;
			
			for each (loadablefile in _stack) {
				tempLoadablefile = loadablefile;
				
				tempStack.push(tempLoadablefile);
			}
			
			return tempStack;
		}
		
		/**
		 * Setup instance.
		 */
		public function setup():void {
			if (_isSetup) return;
			
			setupFileManager();
			setupCacheManager();
			
			_isSetup = true;
		}
		
		/**
		 * Release instance.
		 */
		public function destroy():void {
			destroyAllLoadbleFiles();
			destroyCacheManager();
			destroyFileManager();
			destroyStack();
			
			_eventDispatcher = null;
			_stack = null;
			_name = null;
			_description = null;
			_loadedFiles = 0;
			_totalFiles = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_totalpercent = 0;
			_onLoad = false;
			_isLoaded = false;
			_isUnLoaded = false;
			
			__instance == null;
			__allowInstantiation == false;
		}
		
		
		/**
		 * Instantiate ResourceLoader.
		 */
		public static function getInstance():ResourceLoader {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new ResourceLoader();
				__allowInstantiation = false;
			}
			
			return __instance;
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
		public function set eventDispatcher(value:IEventDispatcher):void {
			_eventDispatcher = value;
		}
		
		/**
		 * @private
		 */
		public function get stack():Vector.<ILoadableFile> {
			return _stack;
		}
		
		/**
		 * @private
		 */
		public function get cacheManager():CacheManager {
			return _cacheManager;
		}
		
		/**
		 * @private
		 */
		public function get numResources():int {
			return _index;
		}
		
		/**
		 * @private
		 */
		public function get isSetup():Boolean {
			return _isSetup;
		}
	}
}