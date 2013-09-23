/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.xml.*;
	import flash.text.TextField;
	
	
	/**
	 * StringTools : Tools for String objects.
	 * 
	 * @author David Massenot
	 */
	public class StringTools {
		
		
		/**
		 * Format to string.
		 * 
		 * @param	object
		 * @param	className
		 * @param	...properties
		 * @return
		 */
		public static function formatToString(object:*, className:String, ...properties:*):String {
			var i:int = 0
			var s:String = '[' + className;
			var prop:String;
			
			for (i ; i < properties.length ; i++) {
				prop = properties[i];
				
				s += ' ' + prop + '=' + object[prop];
			}
			
			return s + ']';
        }
		
		/**
		 * Escape HTML chars.
		 * 
		 * @param	string
		 * @return
		 */
		public static function escapeHTML(string:String):String {
			if (!string) return '';
			
			return XML(new XMLNode(XMLNodeType.TEXT_NODE, string)).toXMLString();
		}
		
		/**
		 * Unescape HTML chars.
		 * 
		 * @param	string
		 * @return
		 */
		public static function unescapeHTML(string:String):String {
			if (!string) return '';
			
			return new XMLDocument(string).firstChild.nodeValue;
		}
		
		/**
		 * Unescape HTML entities.
		 * 
		 * @param	string
		 * @return
		 */
		public static function unescapeHTMLEntities(string:String):String {
			if (!string) return '';
			
			var tf:TextField = new TextField();
			tf.htmlText = unescape(string);
			
			return tf.text;
		}
	}
}