/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * FileTools : Tools for files.
	 * 
	 * @author David Massenot
	 */
	public class FileTools {
		
		
		/**
		 * Get a file extension.
		 * 
		 * @param file
		 * @return String extension
		 */
		public static function getExtension(file:String):String {			
			return file.substring(file.lastIndexOf('.') + 1, file.length);
		}
	}
}