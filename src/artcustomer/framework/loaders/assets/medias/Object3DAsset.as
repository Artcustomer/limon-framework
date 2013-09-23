/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.medias {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import artcustomer.framework.loaders.assets.consts.AssetType;
	
	
	/**
	 * Object3DAsset
	 * 
	 * @author David Massenot
	 */
	public class Object3DAsset extends AbstractLoadableAsset {
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		
		private var _isCollada:Boolean;
		private var _is3DS:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function Object3DAsset() {
			super();
			
			_type = AssetType.OBJECT3D;
			
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
		private function loadURLLoader(dataformat:String):void {
			if (_urlLoader) {
				_urlLoader.dataFormat = dataformat;
				_urlLoader.load(_urlRequest);
			}
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
			_error = e.text;
			
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
			if (_is3DS) {
				_data = (e.target as URLLoader).data;
				_data = (_data as ByteArray);
			} else if (_isCollada) {
				_data = XML((e.target as URLLoader).data);
				_data = (_data as XML);
			}
			
			super.onComplete();
		}
		
		
		/**
		 * Start loading.
		 */
		override public function load():void {
			var dataformat:String;
			
			switch (_extension) {
				case('3ds'):
				case('a3d'):
				case('md2'):
				case('md5'):
					dataformat = URLLoaderDataFormat.BINARY;
					
					_is3DS = true;
					break;
					
				case('dae'):
					dataformat = URLLoaderDataFormat.TEXT;
					
					_isCollada = true;
					break;
					
				default:
					break;
			}
			
			setupURLRequest();
			loadURLLoader(dataformat);
			
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
			
			_isCollada = false;
			_is3DS = false;
			
			super.destroy();
		}
	}
}