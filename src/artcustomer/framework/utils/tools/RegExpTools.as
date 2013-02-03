/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * RegExpTools : Tools for RegExp.
	 * 
	 * @author David Massenot
	 */
	public class RegExpTools {
		private static var __pattern:RegExp = /^[\w\-.-._]+@[\w\.-]+\.[a-z]{2,3}$/i;
		
		
		/**
		 * Test if string is a mail address.
		 * 
		 * @param value
		 * @return
		 */
		public static function testMail(value:String):Boolean {
			return __pattern.test(value);
		}
		
		/**
		 * Test Regexp.
		 * 
		 * @param value
		 * @param pattern
		 * @return
		 */
		public static function testPattern(value:String, pattern:RegExp):Boolean {
			if (!value || !pattern) return false;
			
			return pattern.test(value);
		}
	}
}