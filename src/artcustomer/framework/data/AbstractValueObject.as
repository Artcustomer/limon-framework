/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.data {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * AbstractValueObject
	 * 
	 * @author David Massenot
	 */
	public class AbstractValueObject extends Object implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.data::AbstractValueObject';
		
		
		/**
		 * Constructor
		 */
		public function AbstractValueObject() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_VALUEOBJECT_CONSTRUCTOR);
		}
		
		
		/**
		 * Format to string.
		 * 
		 * @param	object
		 * @param	className
		 * @param	...properties
		 * @return
		 */
		public final function formatToString(object:*, className:String, ...properties:*):String {
			var s:String = '[' + className;
			var prop:String;
			
			for (var i:int = 0 ; i < properties.length ; i++) {
				prop = properties[i];
				
				s += ' ' + prop + '=' + object[prop];
			}
			
			return s + ']';
        }
		
		/**
		 * Get object in string format. Can be overrided.
		 * 
		 * @return
		 */
		public function toString():String {
			return formatToString(this, 'AbstractValueObject');
		}
		
		/**
		 * Destroy data in object. Override it !
		 */
		public function destroy():void {
			
		}
	}
}