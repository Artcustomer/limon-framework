/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.data {
	import artcustomer.framework.base.*;
	import artcustomer.framework.loaders.assets.core.*;
	import artcustomer.framework.loaders.assets.medias.*;
	import artcustomer.framework.loaders.assets.resources.*;
	import artcustomer.framework.loaders.assets.consts.AssetType;
	
	
	/**
	 * AssetsFactory
	 * 
	 * @author David Massenot
	 */
	public class AssetsFactory implements IDestroyable {
		private var _files:Vector.<ResourceFile>;
		
		
		/**
		 * Constructor
		 */
		public function AssetsFactory() {
			setupFiles();
		}
		
		//---------------------------------------------------------------------
		//  Resources
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupFiles():void {
			_files = new Vector.<ResourceFile>();
			
			_files.push(createResourceFile(ImageAsset, AssetType.IMAGE, ['jpg', 'jpeg', 'png', 'bmp', 'gif'], ['image/jpeg', 'image/jpeg', 'image/png', 'image/png', 'image/gif']));
			_files.push(createResourceFile(SoundAsset, AssetType.SOUND, ['mp3', 'wav', 'wma'], ['audio/mpeg', 'audio/x-wav', 'audio/x-ms-wma']));
			_files.push(createResourceFile(AnimationAsset, AssetType.ANIMATION, ['swf'], ['application/octet-stream']));
			_files.push(createResourceFile(TextAsset, AssetType.TEXT, ['txt', 'xml', 'rss', 'html', 'css', 'js'], ['text/plain', 'text/xml', 'text/xml', 'text/html', 'text/css', 'text/javascript']));
			_files.push(createResourceFile(Object3DAsset, AssetType.OBJECT3D, ['dae', '3ds', 'a3d', 'md5', 'md2'], ['model/x3d+xml', 'model/x3d+binary', 'model/x3d+binary', 'application/octet-stream', 'application/octet-stream']));
		}
		
		/**
		 * @private
		 */
		private function destroyFiles():void {
			while (_files.length > 0) {
				_files.shift().destroy();
			}
			
			_files.length = 0;
			_files = null;
		}
		
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
		
		//---------------------------------------------------------------------
		//  Tools
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function getExtension(file:String):String {
			var dot:int = file.lastIndexOf('.');
			
			if (dot == -1) return null;
			
			return file.substring(dot + 1, file.length);
		}
		
		/**
		 * @private
		 */
		private function getMimeType(file:String):String {
			var resourceFile:ResourceFile;
			var resourceType:ResourceType;
			var extension:String = getExtension(file);
			
			for each (resourceFile in _files) {
				for each (resourceType in resourceFile.extensions) {
					if (extension == resourceType.extension) return resourceType.mimeType;
				}
			}
			
			return null;
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			destroyFiles();
		}
		
		/**
		 * Create AbstractLoadableAsset from properties.
		 * 
		 * @param	source
		 * @return
		 */
		public function createLoadableAsset(source:String):AbstractLoadableAsset {
			var resourceFile:ResourceFile;
			var resourceType:ResourceType;
			var extension:String = getExtension(source);
			
			for each (resourceFile in _files) {
				for each (resourceType in resourceFile.extensions) {
					if (extension == resourceType.extension) return new resourceFile.definition();
				}
			}
			
			return null;
		}
		
		/**
		 * Create Asset from AbstractLoadableAsset object.
		 * 
		 * @param	loadableAsset
		 * @return
		 */
		public function createAsset(loadableAsset:AbstractLoadableAsset):IAsset {
			var asset:AssetObject = new AssetObject();
			
			if (loadableAsset) {
				asset.source = loadableAsset.source;
				asset.name = loadableAsset.name;
				asset.group = loadableAsset.group;
				asset.file = loadableAsset.file;
				asset.type = loadableAsset.type;
				asset.data = loadableAsset.data;
				asset.bytes = loadableAsset.bytes;
			}
			
			return asset;
		}
	}
}