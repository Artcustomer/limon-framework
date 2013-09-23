/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.core {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.utils.tools.StringTools;
	
	
	/**
	 * AssetObject
	 * 
	 * @author David Massenot
	 */
	public class AssetObject implements IAsset, IDestroyable {
		private var _source:String;
		private var _name:String;
		private var _group:String;
		private var _file:String;
		private var _type:String;
		private var _data:*;
		private var _bytes:*;
		
		
		/**
		 * Constructor
		 */
		public function AssetObject() {
			
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_source = null;
			_name = null;
			_group = null;
			_file = null;
			_type = null;
			_data = null;
			_bytes = null;
		}
		
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'AssetObject', 'source', 'name', 'group', 'file', 'type');
		}
		
		
		/**
		 * @private
		 */
		public function set source(value:String):void {
			_source = value;
		}
		
		/**
		 * @private
		 */
		public function get source():String {
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
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
		public function set group(value:String):void {
			_group = value;
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
		public function set file(value:String):void {
			_file = value;
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
		public function set type(value:String):void {
			_type = value;
		}
		
		/**
		 * @private
		 */
		public function get type():String {
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set data(value:*):void {
			_data = value;
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
		public function set bytes(value:*):void {
			_bytes = value;
		}
		
		/**
		 * @private
		 */
		public function get bytes():* {
			return _bytes;
		}
	}
}