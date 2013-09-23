/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.resources {
	import artcustomer.framework.data.AbstractValueObject;
	
	
	/**
	 * ResourceType
	 * 
	 * @author David Massenot
	 */
	public class ResourceType extends AbstractValueObject {
		private var _extension:String;
		private var _mimeType:String;
		
		
		/**
		 * Constructor
		 */
		public function ResourceType(extension:String = null, mimeType:String = null) {
			_extension = extension;
			_mimeType = mimeType;
		}
		
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			super.destroy();
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		override public function toString():String {
			return this.formatToString(this, 'ResourceType', 'extension', 'mimeType');
		}
		
		
		/**
		 * @private
		 */
		public function set extension(value:String):void {
			_extension = value;
		}
		
		/**
		 * @private
		 */
		public function get extension():String {
			return _extension;
		}
		
		/**
		 * @private
		 */
		public function set mimeType(value:String):void {
			_mimeType = value;
		}
		
		/**
		 * @private
		 */
		public function get mimeType():String {
			return _mimeType;
		}
	}
}