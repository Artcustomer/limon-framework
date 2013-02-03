/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * ObjectTools : Tools for objects.
	 * 
	 * @author David Massenot
	 */
	public class ObjectTools {
		
		
		/**
		 * Parse data in Object.
		 * 
		 * @param	object
		 * @return
		 */
		public static function parse(object:Object):Array {
			if (!object) return null;
			
			var array:Array = new Array();
			var parameter:Object = null;
			var value:Object = null;
			
			for (var o:* in object) {
				parameter = o;
				value = object[o];
				
				if (value == '') {
					value = parse(value);
					
					if (value) if (value.length != 0) value = '{ ' + value + ' }';
				}
				
				array.push(String(parameter) + ' : ' + String(value));
			}
			
			if (array.length == 0) array.push('null');
			
			return array;
		}
	}
}