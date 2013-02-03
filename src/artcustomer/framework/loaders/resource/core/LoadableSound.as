/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.resource.core {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	
	/**
	 * LoadableSound
	 * 
	 * @author David Massenot
	 */
	public class LoadableSound extends LoadableFile implements ILoadableFile {
		private var _sound:Sound;
		private var _soundloadercontext:SoundLoaderContext;
		private var _urlrequest:URLRequest;
		
		
		/**
		 * Constructor
		 */
		public function LoadableSound() {
			
		}
		
		//---------------------------------------------------------------------
		//  Sound
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSound():void {
			_sound = new Sound(_urlrequest, _soundloadercontext);
			
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleErrorSound, false, 0, true);
			_sound.addEventListener(ProgressEvent.PROGRESS, handleProgressSound, false, 0, true);
			_sound.addEventListener(Event.COMPLETE, handleCompleteSound, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroySound():void {
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorSound);
			_sound.removeEventListener(ProgressEvent.PROGRESS, handleProgressSound);
			_sound.removeEventListener(Event.COMPLETE, handleCompleteSound);
			
			_sound = null;
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
		private function handleErrorSound(e:IOErrorEvent):void {
			_error = e.text;
			
			super.errorHandler();
		}
		
		/**
		 * @private
		 */
		private function handleProgressSound(e:ProgressEvent):void {
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			_percent = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			
			this.dispatchEvent(e.clone());
		}
		
		/**
		 * @private
		 */
		private function handleCompleteSound(e:Event):void {
			_data = _sound;
			
			super.completeHandler();
		}
		
		
		/**
		 * Start loading file.
		 */
		public function startLoading():void {
			if (this.isAlreadyLoaded) {
				super.completeHandler();
			} else {
				setupURLRequest();
				setupSound();
				
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
						_sound.close();
					} catch (er:Error) {
						
					}
				}
				
				destroyURLRequest();
				destroySound();
			}
		}
		
		/**
		 * Release instance.
		 */
		override public function destroy():void {
			_sound = null;
			_soundloadercontext = null;
			_urlrequest = null;
			
			super.destroy();
		}
	}
}