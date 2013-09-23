/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	
	/**
	 * LayerVideoEvent
	 * 
	 * @author David Massenot
	 */
	public class LayerVideoEvent extends Event {
		public static const LAYERVIDEO_AVAILABLE:String = 'layerVideoAvailable';
		public static const LAYERVIDEO_READY:String = 'layerVideoReady';
		public static const LAYERVIDEO_SETUP:String = 'layerVideoSetup';
		public static const LAYERVIDEO_DESTROY:String = 'layerVideoDestroy';
		public static const LAYERVIDEO_ERROR:String = 'layerVideoError';
		public static const LAYERVIDEO_RENDER:String = 'layerVideoRender';
		
		public static const LAYERVIDEO_PLAYSTREAM:String = 'layerVideoPlayStream';
		public static const LAYERVIDEO_PAUSESTREAM:String = 'layerVideoPauseStream';
		public static const LAYERVIDEO_RESUMESTREAM:String = 'layerVideoResumeStream';
		public static const LAYERVIDEO_STOPSTREAM:String = 'layerVideoStopStream';
		public static const LAYERVIDEO_ONSTREAM:String = 'layerVideoOnStream';
		
		public static const LAYERVIDEO_METADATA_RECEIVED:String = 'layerVideoMetaDataReceived';
		public static const LAYERVIDEO_STREAM_NOT_FOUND:String = 'layerVideoStreamNotFound';
		public static const LAYERVIDEO_BUFFER_EMPTY:String = 'layerVideoBufferEmpty';
		public static const LAYERVIDEO_BUFFER_FLUSH:String = 'layerVideoBufferFlush';
		public static const LAYERVIDEO_BUFFER_FULL:String = 'layerVideoBufferFull';
		
		public static const LAYERVIDEO_CHANGE_VOLUME:String = 'layerVideoChangeVolume';
		
		private var _stream:String;
		private var _error:String;
		private var _volume:Number;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	stream
		 * @param	error
		 * @param	volume
		 */
		public function LayerVideoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, stream:String = null, error:String = null, volume:Number = 0) {
			_stream = stream;
			_error = error;
			_volume = volume;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone LayerVideoEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new LayerVideoEvent(type, bubbles, cancelable, _stream, _error, _volume);
		}
		
		/**
		 * Get String value of LayerVideoEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("LayerVideoEvent", "type", "bubbles", "cancelable", "eventPhase", "stream", "error", "volume"); 
		}
		
		
		/**
		 * @private
		 */
		public function get stream():String {
			return _stream;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
		
		/**
		 * @private
		 */
		public function get volume():Number {
			return _volume;
		}
	}
}