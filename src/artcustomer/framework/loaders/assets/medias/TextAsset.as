/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.medias {
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.text.StyleSheet;
	
	import artcustomer.framework.loaders.assets.consts.AssetType;
	
	
	/**
	 * TextAsset
	 * 
	 * @author David Massenot
	 */
	public class TextAsset extends AbstractLoadableAsset {
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		
		
		/**
		 * Constructor
		 */
		public function TextAsset() {
			super();
			
			_type = AssetType.TEXT;
			
			setupURLLoader();
		}
		
		//---------------------------------------------------------------------
		//  URLLoader
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupURLLoader():void {
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleErrorURLLoader, false, 0, true);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, handleProgressURLLoader, false, 0, true);
			_urlLoader.addEventListener(Event.COMPLETE, handleCompleteURLLoader, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyURLLoader():void {
			if (_urlLoader) {
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorURLLoader);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, handleProgressURLLoader);
				_urlLoader.removeEventListener(Event.COMPLETE, handleCompleteURLLoader);
				_urlLoader = null;
			}
		}
		
		/**
		 * @private
		 */
		private function loadURLLoader():void {
			if (_urlLoader) _urlLoader.load(_urlRequest);
		}
		
		/**
		 * @private
		 */
		private function closeURLLoader():void {
			if (_urlLoader) _urlLoader.close();
		}
		
		//---------------------------------------------------------------------
		//  URLRequest
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupURLRequest():void {
			_urlRequest = new URLRequest(_source);
		}
		
		/**
		 * @private
		 */
		private function destroyURLRequest():void {
			_urlRequest = null;
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleErrorURLLoader(e:IOErrorEvent):void {
			_error = e.text
			
			super.onError();
		}
		
		/**
		 * @private
		 */
		private function handleProgressURLLoader(e:ProgressEvent):void {
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			_progress = _bytesLoaded / _bytesTotal;
			
			this.dispatchEvent(e.clone());
		}
		
		/**
		 * @private
		 */
		private function handleCompleteURLLoader(e:Event):void {
			switch (_extension) {
				case('xml'):
					_data = new XML(e.target.data).*;
					break;
					
				case('css'):
					_data = new StyleSheet()
					_data.parseCSS(e.target.data);
					break;
					
				default:
					_data = e.target.data as String;
					break;
			}
			
			super.onComplete();
		}
		
		
		/**
		 * Start loading.
		 */
		override public function load():void {
			setupURLRequest();
			loadURLLoader();
			
			super.load();
		}
		
		/**
		 * Close loading.
		 */
		override public function close():void {
			if (!_isLoading) {
				if (_isOpenStream) {
					try {
						closeURLLoader();
					} catch (er:Error) {
						
					}
				}
				
				destroyURLRequest();
				destroyURLLoader();
			}
			
			super.close();
		}
		
		/**
		 * Destructor
		 */
		override public function destroy():void {
			destroyURLRequest();
			destroyURLLoader();
			
			super.destroy();
		}
	}
}