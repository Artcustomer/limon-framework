/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.text.StyleSheet;
	
	import artcustomer.framework.loaders.resource.data.FileManager;
	
	
	/**
	 * LoadableText
	 * 
	 * @author David Massenot
	 */
	public class LoadableText extends LoadableFile implements ILoadableFile {
		private var _urlloader:URLLoader;
		private var _urlrequest:URLRequest;
		
		
		/**
		 * Constructor
		 */
		public function LoadableText() {
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
		private function loadURLLoader():void {
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
			_error = e.text
			
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
			var extension:String = FileManager.getInstance().getExtension(_file);
			
			if (extension == 'xml') {
				_data = new XML(e.target.data).*;
			} else if (extension == 'css') {
				_data = new StyleSheet()
				_data.parseCSS(e.target.data);
			} else {
				_data = e.target.data as String;
			}
			
			super.completeHandler();
		}
		
		
		/**
		 * Start file loading.
		 */
		public function startLoading():void {
			if (this.isAlreadyLoaded) {
				super.completeHandler();
			} else {
				setupURLRequest();
				loadURLLoader();
				
				super.startLoadingFile();
			}
		}
		
		/**
		 * Close file loading.
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
			
			super.destroy();
		}
	}
}