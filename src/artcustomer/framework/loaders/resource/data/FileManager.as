/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.data {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.loaders.resource.core.*;
	import artcustomer.framework.loaders.resource.vo.*;
	import artcustomer.framework.loaders.resource.errors.ResourceLoaderError;
	
	
	/**
	 * FileManager
	 * 
	 * @author David Massenot
	 */
	public class FileManager extends Object implements IDestroyable {
		private static var __instance:FileManager;
		private static var __allowInstantiation:Boolean;
		
		private var _files:Vector.<ResourceFile>;
		
		private var _isSetup:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function FileManager() {
			if (!__allowInstantiation) {
				throw new ResourceLoaderError(ResourceLoaderError.E_FILEMANAGER_ALLOWINSTANTIATION);
				
				return;
			}
			
			init();
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_isSetup = false;
		}
		
		//---------------------------------------------------------------------
		//  Files
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupFiles():void {
			_files = new Vector.<ResourceFile>();
			
			_files.push(createResourceFile(LoadableImage, 'image', ['jpg', 'jpeg', 'png', 'bmp', 'gif'], ['image/jpeg', 'image/jpeg', 'image/png', 'image/png', 'image/gif']));
			_files.push(createResourceFile(LoadableSound, 'sound', ['mp3', 'wav', 'wma'], ['audio/mpeg', 'audio/x-wav', 'audio/x-ms-wma']));
			_files.push(createResourceFile(LoadableAnimation, 'animation', ['swf'], ['application/octet-stream']));
			_files.push(createResourceFile(LoadableText, 'text', ['txt', 'xml', 'rss', 'html', 'css', 'js'], ['text/plain', 'text/xml', 'text/xml', 'text/html', 'text/css', 'text/javascript']));
			_files.push(createResourceFile(LoadableObject3D, 'object3d', ['dae', '3ds', 'a3d', 'md5', 'md2'], ['model/x3d+xml', 'model/x3d+binary', 'model/x3d+binary', 'application/octet-stream', 'application/octet-stream']));
		}
		
		/**
		 * @private
		 */
		private function destroyFiles():void {
			var resourceFile:ResourceFile;
			
			if (_files) {
				for each (resourceFile in _files) {
					resourceFile.destroy();
					resourceFile = null;
				}
				
				_files = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Resources
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createResourceFile(definition:Class, type:String, extensions:Array, mimeTypes:Array):ResourceFile {
			var resourceFile:ResourceFile = new ResourceFile();
			var i:int = 0;
			var length:int = extensions.length;
			
			for (i ; i < length ; i++) {
				resourceFile.addExtension(extensions[i], mimeTypes[i]);
			}
			
			resourceFile.definition = definition;
			resourceFile.type = type;
			
			return resourceFile;
		}
		
		
		/**
		 * Setup FileManager.
		 */
		public function setup():void {
			if (_isSetup) return;
			
			_isSetup = true;
			
			setupFiles(); 
		}
		
		/**
		 * Destroy FileManager.
		 */
		public function destroy():void {
			destroyFiles();
			
			_isSetup = false;
		}
		
		/**
		 * Get a file extension.
		 * 
		 * @param	file
		 * @return  String
		 */
		public function getExtension(file:String):String {
			var dot:int = file.lastIndexOf('.');
			
			if (dot == -1) return null;
			
			return file.substring(dot + 1, file.length);
		}
		
		/**
		 * Get a file Mime Type.
		 * 
		 * @param	file
		 * @return  String
		 */
		public function getMimeType(file:String):String {
			var resourceFile:ResourceFile;
			var resourceType:ResourceType;
			var extension:String = this.getExtension(file);
			
			for each (resourceFile in _files) {
				for each (resourceType in resourceFile.extensions) {
					if (extension == resourceType.extension) return resourceType.mimeType;
				}
			}
			
			return null;
		}
		
		/**
		 * Get Loadable definition.
		 * 
		 * @param	file
		 * @return  String
		 */
		public function getDefinition(file:String):Class {
			var resourceFile:ResourceFile;
			var resourceType:ResourceType;
			var extension:String = this.getExtension(file);
			
			for each (resourceFile in _files) {
				for each (resourceType in resourceFile.extensions) {
					if (extension == resourceType.extension) return resourceFile.definition;
				}
			}
			
			return null;
		}
		
		
		/**
		 * Instantiate FileManager (Singleton).
		 */
		public static function getInstance():FileManager {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new FileManager();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}