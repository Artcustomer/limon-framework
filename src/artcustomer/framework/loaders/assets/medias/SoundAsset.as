/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.medias {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import artcustomer.framework.loaders.assets.consts.AssetType;
	
	
	/**
	 * SoundAsset
	 * 
	 * @author David Massenot
	 */
	public class SoundAsset extends AbstractLoadableAsset {
		private var _sound:Sound;
		private var _soundLoaderContext:SoundLoaderContext;
		private var _urlRequest:URLRequest;
		
		
		/**
		 * Constructor
		 */
		public function SoundAsset() {
			super();
			
			_type = AssetType.SOUND;
		}
		
		//---------------------------------------------------------------------
		//  Sound
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSound():void {
			_sound = new Sound(_urlRequest, _soundLoaderContext);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleErrorSound, false, 0, true);
			_sound.addEventListener(ProgressEvent.PROGRESS, handleProgressSound, false, 0, true);
			_sound.addEventListener(Event.COMPLETE, handleCompleteSound, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroySound():void {
			if (_sound) {
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorSound);
				_sound.removeEventListener(ProgressEvent.PROGRESS, handleProgressSound);
				_sound.removeEventListener(Event.COMPLETE, handleCompleteSound);
				_sound = null;
			}
		}
		
		/**
		 * @private
		 */
		private function closeSound():void {
			if (_sound) _sound.close();
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
		private function handleErrorSound(e:IOErrorEvent):void {
			_error = e.text;
			
			super.onError();
		}
		
		/**
		 * @private
		 */
		private function handleProgressSound(e:ProgressEvent):void {
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			_progress = _bytesLoaded / _bytesTotal;
			
			this.dispatchEvent(e.clone());
		}
		
		/**
		 * @private
		 */
		private function handleCompleteSound(e:Event):void {
			_data = _sound;
			
			super.onComplete();
		}
		
		
		/**
		 * Start loading.
		 */
		override public function load():void {
			setupURLRequest();
			setupSound();
			
			super.load();
		}
		
		/**
		 * Close loading.
		 */
		override public function close():void {
			if (!_isLoading) {
				if (_isOpenStream) {
					try {
						closeSound();
					} catch (er:Error) {
						
					}
				}
				
				destroyURLRequest();
				destroySound();
			}
			
			super.close();
		}
		
		/**
		 * Destructor
		 */
		override public function destroy():void {
			destroyURLRequest();
			destroySound();
			
			super.destroy();
		}
	}
}