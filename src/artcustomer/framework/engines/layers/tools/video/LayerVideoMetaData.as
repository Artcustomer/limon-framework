/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers.tools.video {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.utils.tools.StringTools;
	
	
	/**
	 * LayerVideoMetaData : MetaData for StageVideo Layer
	 * 
	 * @author David Massenot
	 */
	public class LayerVideoMetaData extends Object implements IDestroyable {
		private static var __instance:LayerVideoMetaData;
		private static var __allowInstanciation:Boolean;
		
		private var _audioCodecID:String;
		private var _videoCodecID:String;
		private var _avcLevel:String;
		private var _avcProfile:String;
		private var _duration:int;
		private var _videoFramerate:int;
		private var _audioSamplerate:int;
		private var _audioChannels:int;
		private var _videoWidth:int;
		private var _videoHeight:int;
		
		
		/**
		 * Constructor
		 */
		public function LayerVideoMetaData() {
			if (!__allowInstanciation) return;
		}
		
		
		/**
		 * Destroy instance.
		 */
		public function destroy():void {
			_audioCodecID = null;
			_videoCodecID = null;
			_avcLevel = null;
			_avcProfile = null;
			_duration = 0;
			_videoFramerate = 0;
			_audioSamplerate = 0;
			_audioChannels = 0;
			_videoWidth = 0;
			_videoHeight = 0;
		}
		
		/**
		 * Get String value of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'LayerVideoMetaData', 'audioCodecID', 'videoCodecID', 'avcLevel', 'avcProfile', 'duration', 'videoFramerate', 'audioSamplerate', 'audioChannels', 'videoWidth', 'videoHeight');
		}
		
		
		/* *
		 * Instantiate LayerVideoMetaData.
		 * */
		public static function getInstance():LayerVideoMetaData {
			if (!__instance) {
				__allowInstanciation = true;
				__instance = new LayerVideoMetaData();
				__allowInstanciation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function set audioCodecID(value:String):void {
			_audioCodecID = value;
		}
		
		/**
		 * @private
		 */
		public function get audioCodecID():String {
			return _audioCodecID;
		}
		
		/**
		 * @private
		 */
		public function set videoCodecID(value:String):void {
			_videoCodecID = value;
		}
		
		/**
		 * @private
		 */
		public function get videoCodecID():String {
			return _videoCodecID;
		}
		
		/**
		 * @private
		 */
		public function set avcLevel(value:String):void {
			_avcLevel = value;
		}
		
		/**
		 * @private
		 */
		public function get avcLevel():String {
			return _avcLevel;
		}
		
		/**
		 * @private
		 */
		public function set avcProfile(value:String):void {
			_avcProfile = value;
		}
		
		/**
		 * @private
		 */
		public function get avcProfile():String {
			return _avcProfile;
		}
		
		/**
		 * @private
		 */
		public function set duration(value:int):void {
			_duration = value;
		}
		
		/**
		 * @private
		 */
		public function get duration():int {
			return _duration;
		}
		
		/**
		 * @private
		 */
		public function set videoFramerate(value:int):void {
			_videoFramerate = value;
		}
		
		/**
		 * @private
		 */
		public function get videoFramerate():int {
			return _videoFramerate;
		}
		
		/**
		 * @private
		 */
		public function set audioSamplerate(value:int):void {
			_audioSamplerate = value;
		}
		
		/**
		 * @private
		 */
		public function get audioSamplerate():int {
			return _audioSamplerate;
		}
		
		/**
		 * @private
		 */
		public function set audioChannels(value:int):void {
			_audioChannels = value;
		}
		
		/**
		 * @private
		 */
		public function get audioChannels():int {
			return _audioChannels;
		}
		
		/**
		 * @private
		 */
		public function set videoWidth(value:int):void {
			_videoWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get videoWidth():int {
			return _videoWidth;
		}
		
		/**
		 * @private
		 */
		public function set videoHeight(value:int):void {
			_videoHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get videoHeight():int {
			return _videoHeight;
		}
	}
}