/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.data {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.loaders.resource.core.ILoadableFile;
	import artcustomer.framework.loaders.resource.errors.ResourceLoaderError;
	
	
	/**
	 * CacheManager
	 * 
	 * @author David Massenot
	 */
	public class CacheManager extends Object implements IDestroyable {
		private static var __instance:CacheManager;
		private static var __allowInstantiation:Boolean;
		
		private static var _stack:Vector.<ILoadableFile>;
		private static var _numResources:int;
		
		private var _isSetup:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function CacheManager() {
			if (!__allowInstantiation) {
				throw new ResourceLoaderError(ResourceLoaderError.E_CACHEMANAGER_ALLOWINSTANTIATION);
				
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
			_isSetup = false;
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
		
		/**
		 * @private
		 */
		private function sortStack(a:ILoadableFile, b:ILoadableFile):int {
			var result:int;
			
			if (a.id < b.id) {
				result = -1;
			} else if (a.id > b.id) {
				result =  1;    
			} else {
				result 0;
			}
			
			return result;
		}
		
		
		/**
		 * Setup CacheManager.
		 */
		public function setup():void {
			if (_isSetup) return;
			
			_isSetup = true;
			
			setupStack();
		}
		
		/**
		 * Destroy CacheManager.
		 */
		public function destroy():void {
			destroyStack();
			
			_isSetup = false;
		}
		
		/**
		 * Add resource in stack.
		 * 
		 * @param	resource : IloadableFile object
		 */
		public function addResource(resource:ILoadableFile):Boolean {
			if (!resource) return false;
			
			var stackResource:ILoadableFile;
			
			for each (stackResource in _stack) {
				if (stackResource.file == resource.file) return false; 
			}
			
			_stack.push(resource);
			_stack.sort(sortStack);
			_numResources = _stack.length;
			
			return true;
		}
		
		/**
		 * Get resources by group name
		 * 
		 * @param	group
		 * @return
		 */
		public function getResourcesByGroup(group:String):Vector.<ILoadableFile> {
			if (!_stack) return null;
			
			var vector:Vector.<ILoadableFile> = new Vector.<ILoadableFile>;
			var resource:ILoadableFile;
			
			for each (resource in stack) {
				if (resource.group == group) vector.push(resource);
			}
			
			return vector;
		}
		
		/**
		 * Get resource.
		 * 
		 * @param	fileName
		 * @return
		 */
		public function getResource(fileName:String):ILoadableFile {
			if (!_stack) return null;
			
			var resource:ILoadableFile;
			
			for each (resource in _stack) {
				if (resource.file == fileName) return resource; 
			}
			
			return null;
		}
		
		/**
		 * Test resource in stack.
		 * 
		 * @param	fileName
		 * @return
		 */
		public function hasResource(fileName:String):Boolean {
			if (!_stack) return false;
			
			var resource:ILoadableFile;
			
			for each (resource in stack) {
				if (resource.file == fileName) return true; 
			}
			
			return false;
		}
		
		
		/**
		 * Instantiate CacheManager (Singleton).
		 */
		public static function getInstance():CacheManager {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new CacheManager();
				__allowInstantiation = false;
			}
			
			return __instance;
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
		public function get numResources():int {
			return _numResources;
		}
		
		/**
		 * @private
		 */
		public function get isSetup():Boolean {
			return _isSetup;
		}
	}
}