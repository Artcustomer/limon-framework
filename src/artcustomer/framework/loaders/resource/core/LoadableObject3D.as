/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.core {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import artcustomer.framework.loaders.resource.data.FileManager;
	
	
	/**
	 * LoadableObject3D
	 * 
	 * @author David Massenot
	 */
	public class LoadableObject3D extends LoadableFile implements ILoadableFile {
		private var _urlloader:URLLoader;
		private var _urlrequest:URLRequest;
		
		private var _isCollada:Boolean;
		private var _is3DS:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function LoadableObject3D() {
			setupURLLoader();
		}
		
		//---------------------------------------------------------------------
		//  URLLoader
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupURLLoader():void {
			_urlloader = new URLLoader();
			
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, handleErrorURLLoader, false, 0, true);
			_urlloader.addEventListener(ProgressEvent.PROGRESS, handleProgressURLLoader, false, 0, true);
			_urlloader.addEventListener(Event.COMPLETE, handleCompleteURLLoader, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyURLLoader():void {
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorURLLoader);
			_urlloader.removeEventListener(ProgressEvent.PROGRESS, handleProgressURLLoader);
			_urlloader.removeEventListener(Event.COMPLETE, handleCompleteURLLoader);
			
			_urlloader = null;
		}
		
		/**
		 * @private
		 */
		private function loadURLLoader(dataformat:String):void {
			_urlloader.dataFormat = dataformat;
			_urlloader.load(_urlrequest);
		}
		
		//---------------------------------------------------------------------
		//  URLRequest
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupURLRequest():void {
			_urlrequest = new URLRequest(_folder + _file);
		}
		
		/**
		 * @private
		 */
		private function destroyURLRequest():void {
			_urlrequest = null;
		}
		
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleErrorURLLoader(e:IOErrorEvent):void {
			_error = e.text;
			
			super.errorHandler();
		}
		
		/**
		 * @private
		 */
		private function handleProgressURLLoader(e:ProgressEvent):void {
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			_percent = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			
			this.dispatchEvent(e.clone());
		}
		
		/**
		 * @private
		 */
		private function handleCompleteURLLoader(e:Event):void {
			if (_is3DS) {
				_data = (e.target as URLLoader).data;
				_data = (_data as ByteArray);
			} else if (_isCollada) {
				_data = XML((e.target as URLLoader).data);
				_data = (_data as XML);
			}
			
			super.completeHandler();
		}
		
		
		/**
		 * Start loading file.
		 */
		public function startLoading():void {
			var extension:String = FileManager.getInstance().getExtension(_file).toLowerCase();
			var dataformat:String;
			
			if (extension == '3ds' || extension == 'a3d' || extension == 'md5' || extension == 'md2') {
				dataformat = URLLoaderDataFormat.BINARY;
				
				_is3DS = true;
			}
			
			if (extension == 'dae') {
				dataformat = URLLoaderDataFormat.TEXT;
				
				_isCollada = true;
			}
			
			if (this.isAlreadyLoaded) {
				super.completeHandler();
			} else {
				setupURLRequest();
				loadURLLoader(dataformat);
				
				super.startLoadingFile();
			}
		}
		
		/**
		 * Close loading file.
		 */
		public function closeLoading():void {
			if (!isLoading) {
				if (_isOpenStream) {
					try {
						_urlloader.close();
					} catch (er:Error) {
						
					}
				}
				
				destroyURLRequest();
				destroyURLLoader();
			}
		}
		
		/**
		 * Release instance.
		 */
		override public function destroy():void {
			_urlloader = null;
			_urlrequest = null;
			_isCollada = false;
			_is3DS = false;
			
			super.destroy();
		}
	}
}