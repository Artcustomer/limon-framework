/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.data {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.loaders.assets.core.*;
	import artcustomer.framework.utils.tools.FileTools;
	
	
	/**
	 * AssetsCache
	 * 
	 * @author David Massenot
	 */
	public class AssetsCache implements IDestroyable {
		private var _stack:Vector.<AssetObject>;
		
		private var _numAssets:int;
		
		
		/**
		 * Constructor
		 */
		public function AssetsCache() {
			createStack();
		}
		
		//---------------------------------------------------------------------
		//  Queue
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createStack():void {
			if (!_stack) _stack = new Vector.<AssetObject>;
		}
		
		/**
		 * @private
		 */
		private function releaseStack():void {
			if (_stack) {
				_stack.length = 0;
				_stack = null;
			}
		}
		
		/**
		 * @private
		 */
		private function disposeStack():void {
			if (!_stack) return;
			
			while (_stack.length > 0) {
				_stack.shift().destroy();
			}
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			disposeStack();
			releaseStack();
			
			_numAssets = 0;
		}
		
		/**
		 * Add Asset in cache.
		 * 
		 * @param	asset
		 */
		public function addAsset(asset:IAsset):void {
			if (asset) {
				_stack.push((asset as AssetObject));
				
				_numAssets++;
			}
		}
		
		/**
		 * Test Asset in cache.
		 * 
		 * @param	source
		 */
		public function hasAsset(source:String):Boolean {
			var asset:IAsset;
			
			for each (asset in _stack) {
				if (asset.source == source || asset.file == FileTools.resolveFileInPath(source)) return true;
			}
			
			return false;
		}
		
		/**
		 * Get Asset by source
		 * 
		 * @param	source
		 * @return
		 */
		public function getAsset(source:String):IAsset {
			var asset:IAsset;
			
			for each (asset in _stack) {
				if (asset.source == source) return asset;
			}
			
			return null;
		}
		
		/**
		 * Get Asset by name
		 * 
		 * @param	name
		 * @return
		 */
		public function getAssetByName(name:String):IAsset {
			var asset:IAsset;
			
			for each (asset in _stack) {
				if (asset.name == name) return asset;
			}
			
			return null;
		}
		
		/**
		 * Get Asset by file
		 * 
		 * @param	file
		 * @return
		 */
		public function getAssetByFile(file:String):IAsset {
			var asset:IAsset;
			
			for each (asset in _stack) {
				if (asset.file == file) return asset;
			}
			
			return null;
		}
		
		/**
		 * Get asset group.
		 * 
		 * @param	group
		 * @return
		 */
		public function getGroup(group:String):Vector.<IAsset> {
			var stack:Vector.<IAsset> = new Vector.<IAsset>;
			var asset:IAsset;
			
			for each (asset in _stack) {
				if (asset.group == group) stack.push(asset);
			}
			
			return stack;
		}
		
		/**
		 * Get assets list in String format.
		 * 
		 * @return
		 */
		public function dumpAssets():String {
			var dump:String = '';
			var asset:IAsset;
			var i:int = 0;
			
			for each (asset in _stack) {
				dump += asset.file;
				
				if (i < _numAssets - 1) dump += '\n';
				
				i++;
			}
			
			return dump;
		}
		
		
		/**
		 * @private
		 */
		public function get numAssets():int {
			return _numAssets;
		}
	}
}