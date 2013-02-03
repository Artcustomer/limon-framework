/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.errors {
	
	
	/**
	 * ResourceLoaderError
	 * 
	 * @author David Massenot
	 */
	public class ResourceLoaderError extends Error {
		public static const E_RESOURCELOADER_ALLOWINSTANTIATION:String = "Use Singleton to instantiate ResourceLoader !";
		public static const E_CACHEMANAGER_ALLOWINSTANTIATION:String = "Use Singleton to instantiate CacheManager !";
		public static const E_FILEMANAGER_ALLOWINSTANTIATION:String = "Use Singleton to instantiate FileManager !";
		
		public static const E_FILE_FORMAT:String = "Can't load external file because of invalid format !";
		
		public static const E_RESOURCELOADER_EMPTY:String = "Can't load files with empty stack !";
		public static const E_RESOURCELOADER_ONLOAD:String = "ResourceLoader is already on load !";
		public static const E_RESOURCELOADER_UNLOAD:String = "ResourceLoader isn't on load !";
		
		
		/**
		 * Throw a ResourceLoaderError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function ResourceLoaderError(message:String = "", id:int = 0) {
			super(message, id);
		}
	}
}