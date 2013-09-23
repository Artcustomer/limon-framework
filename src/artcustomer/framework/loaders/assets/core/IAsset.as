/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.core {
	
	
	/**
	 * IAsset
	 * 
	 * @author David Massenot
	 */
	public interface IAsset {
		function get source():String
		function get name():String
		function get group():String
		function get file():String
		function get type():String
		function get data():*
		function get bytes():*
	}
}