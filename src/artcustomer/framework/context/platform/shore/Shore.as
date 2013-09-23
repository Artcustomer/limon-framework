/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context.platform.shore {
	import flash.utils.Dictionary;
	
	import artcustomer.framework.base.IDestroyable;
	
	
	/**
	 * Shore (Shared Object Repository)
	 * 
	 * @author David Massenot
	 */
	public class Shore extends Object implements IDestroyable {
		private static var __instance:Shore;
		private static var __allowInstantiation:Boolean;
		
		private var _repository:Dictionary;
		
		private var _numKeys:int;
		
		
		/**
		 * Constructor
		 */
		public function Shore() {
			setupDictionary();
		}
		
		//---------------------------------------------------------------------
		//  Dictionary
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDictionary():void {
			_repository = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyDictionary():void {
			_repository = null;
		}
		
		/**
		 * @private
		 */
		private function disposeDictionary():void {
			var key:String;
			
			for (key in _repository) {
				_repository[key] = null;
			}
		}
		
		
		/**
		 * Put data in Shore.
		 * @param	value
		 * @param	key
		 */
		public function put(value:*, key:String):Boolean {
			if (!_repository[key]) {
				_repository[key] = value;
				_numKeys++;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Get data in Shore.
		 * @param	value
		 * @param	key
		 */
		public function get(key:String):* {
			return _repository[key];
		}
		
		/**
		 * Test data in Shore.
		 * @param	value
		 * @param	key
		 */
		public function has(key:String):Boolean {
			return _repository[key] != null;
		}
		
		/**
		 * Remove data in Shore.
		 * @param	value
		 * @param	key
		 */
		public function remove(key:String):Boolean {
			if (_repository[key]) {
				_repository[key] = null;
				_numKeys--;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Clear Shore.
		 */
		public function clear():void {
			disposeDictionary();
			
			_numKeys = 0;
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeDictionary();
			destroyDictionary();
			
			_numKeys = 0;
			
			__instance = null;
			__allowInstantiation = false;
		}
		
		
		/**
		 * Instantiate Shore.
		 */
		public static function getInstance():Shore {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new Shore();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get numKeys():int {
			return _numKeys
		}
	}
}