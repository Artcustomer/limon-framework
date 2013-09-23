/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.errors {
	
	
	/**
	 * AssetsLoaderError
	 * 
	 * @author David Massenot
	 */
	public class AssetsLoaderError extends Error {
		public static const E_ASSETSLOADER_ALLOWINSTANTIATION:String = "Use Singleton to instantiate AssetsLoader !";
		
		public static const E_FILE_FORMAT:String = "Can't load external file because of invalid format !";
		
		public static const E_ASSETSLOADER_EMPTY:String = "Can't load files with empty stack !";
		public static const E_ASSETSLOADER_ONLOAD:String = "AssetsLoader is already on load !";
		public static const E_ASSETSLOADER_UNLOAD:String = "AssetsLoader isn't on load !";
		
		
		/**
		 * Throw a AssetsLoaderError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function AssetsLoaderError(message:String = "", id:int = 0) {
			super(message, id);
		}
	}
}