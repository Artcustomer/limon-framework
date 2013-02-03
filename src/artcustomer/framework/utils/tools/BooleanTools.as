/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * BooleanTools : Tools for booleans.
	 * 
	 * @author David Massenot
	 */
	public class BooleanTools {
		
		
		/**
		 * Test String value.
		 * 
		 * @param	string
		 * @return
		 */
		public static function testString(string:String):Boolean {
			if (!string || string == '') return false;
			
			return true;
		}
		
		/**
		 * Test exact String value ('true' / 'false').
		 * 
		 * @param	string
		 * @return
		 */
		public static function testTrueString(string:String):Boolean {
			if (!string || string != 'true') return false;
			
			return true;
		}
		
		/**
		 * Test Number value.
		 * 
		 * @param	string
		 * @return
		 */
		public static function testNumber(value:Number):Boolean {
			if (!value || value == 0) return false;
			
			return true;
		}
	}
}