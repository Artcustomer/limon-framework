/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.resources {
	import artcustomer.framework.data.AbstractValueObject;
	
	
	/**
	 * ResourceFile
	 * 
	 * @author David Massenot
	 */
	public class ResourceFile extends AbstractValueObject {
		private var _definition:Class;
		private var _type:String;
		private var _extensions:Vector.<ResourceType>;
		
		
		/**
		 * Constructor
		 */
		public function ResourceFile(definition:Class = null, type:String = null, extensions:Vector.<ResourceType> = null) {
			_definition = definition;
			_type = type;
			_extensions = extensions;
		}
		
		
		/**
		 * Add extension in resource.
		 * 
		 * @param	extension
		 * @param	mimeType
		 */
		public function addExtension(extension:String, mimeType:String):void {
			if (!_extensions) _extensions = new Vector.<ResourceType>();
			
			_extensions.push(new ResourceType(extension, mimeType));
		}
		
		/**
		 * Get ResourceType at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function getExtensionAt(index:int):ResourceType {
			if (!_extensions || index < 0 || index >= _extensions.length) return null;
			
			return _extensions[index];
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			super.destroy();
		}
		
		/**
		 * Get Strng format of object.
		 * 
		 * @return
		 */
		override public function toString():String {
			return this.formatToString(this, 'ResourceFile', 'definition', 'type', 'extensions');
		}
		
		/**
		 * @private
		 */
		public function set definition(value:Class):void {
			_definition = value;
		}
		
		/**
		 * @private
		 */
		public function get definition():Class {
			return _definition;
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
		public function set extensions(value:Vector.<ResourceType>):void {
			_extensions = value;
		}
		
		/**
		 * @private
		 */
		public function get extensions():Vector.<ResourceType> {
			return _extensions;
		}
		
		/**
		 * @private
		 */
		public function get numExtensions():int {
			if (_extensions) return _extensions.length;
			
			return 0;
		}
	}
}