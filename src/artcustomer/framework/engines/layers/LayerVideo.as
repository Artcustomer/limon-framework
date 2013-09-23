/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers {
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.context.IContext;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.engines.layers.tools.video.*;
	import artcustomer.framework.engines.layers.tools.video.consts.*;
	import artcustomer.framework.utils.consts.LayerErrorType;
	
	
	[Event(name = "layerVideoAvailable", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoReady", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoSetup", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoDestroy", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoError", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoRender", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoPlayStream", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoPauseStream", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoResumeStream", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoStopStream", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoOnStream", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoMetaDataReceived", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoStreamNotFound", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoBufferEmpty", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoBufferFlush", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoBufferFull", type = "artcustomer.framework.events.LayerVideoEvent")]
	[Event(name = "layerVideoChangeVolume", type = "artcustomer.framework.events.LayerVideoEvent")]
	
	
	/**
	 * LayerVideo : StageVideo Layer
	 * 
	 * @author David Massenot
	 */
	public class LayerVideo extends EventDispatcher implements ILayer {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.layers::LayerVideo';
		
		private var _context:IContext;
		private var _id:String;
		private var _index:int;
		
		private var _scaleOnStage:Boolean;
		private var _ratioType:String;
		private var _videoPosition:String;
		private var _videoHorizontalMargin:int;
		private var _videoVerticalMargin:int;
		
		private var _layerVideoMetaData:LayerVideoMetaData;
		
		private var _stageVideo:StageVideo;
		private var _viewPort:Rectangle;
		
		private var _netStream:NetStream;
		private var _netConnection:NetConnection;
		
		private var _currentStream:String;
		private var _currentStreamName:String;
		private var _currentStreamType:String;
		
		private var _totalTime:String;
		private var _playedTime:String;
		private var _time:Number;
		private var _duration:Number;
		private var _currentSeconds:int;
		private var _currentMinutes:int;
		private var _totalSeconds:int;
		private var _totalMinutes:int;
		private var _percentBuffered:Number;
		private var _percentPlayed:Number;
		
		private var _volume:Number;
		private var _status:String;
		
		private var _allowSetID:Boolean;
		private var _isStageVideoAvailable:Boolean;
		private var _onMetaDataReceived:Boolean;
		private var _allowRendering:Boolean;
		private var _isPlaying:Boolean;
		private var _isPlay:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function LayerVideo() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_LAYERVIDEO_CONSTRUCTOR);
			
			_allowSetID = true;
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_volume = 1;
			_time = 0;
			_duration = 0;
			_currentSeconds = 0;
			_totalSeconds = 0;
			_totalSeconds = 0;
			_totalMinutes = 0;
			_totalTime = '00:00';
			_playedTime = '00:00';
			_videoPosition = LayerVideoPosition.LEFT;
			_videoHorizontalMargin = 0;
			_videoVerticalMargin = 0;
			_isStageVideoAvailable = false;
			_onMetaDataReceived = false;
			_isPlaying = false;
			_isPlay = false;
		}
		
		/**
		 * @private
		 */
		private function reset():void {
			_time = 0;
			_duration = 0;
			_currentSeconds = 0;
			_totalSeconds = 0;
			_totalSeconds = 0;
			_totalMinutes = 0;
			_totalTime = '--:--';
			_playedTime = '--:--';
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			_context.instance.stageReference.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, handleStageVideoAvailability, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			_context.instance.stageReference.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, handleStageVideoAvailability);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStageVideoAvailability(e:StageVideoAvailabilityEvent):void {
			if (e.availability == StageVideoAvailability.UNAVAILABLE) {
				_isStageVideoAvailable = false;
				
				this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_ERROR, false, false, _currentStream, LayerErrorType.STAGEVIDEO_UNAVAILABLE));
			} else {
				_isStageVideoAvailable = true;
				
				this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_AVAILABLE, false, false, _currentStream, null, _volume));
				
				if (setupStageVideo()) {
					setupNetConnection();
					setupNetStream();
					attachStreamOnStageVideo();
					ready();
					
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_READY, false, false, _currentStream, null, _volume));
				} else {
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_ERROR, false, false, _currentStream, LayerErrorType.STAGEVIDEO_UNDEFINED));
				}
			}
		}
		
		//---------------------------------------------------------------------
		//  Rendering
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function render():void {
			if (!_netStream) return;
			
			_time = _netStream.time;
			_currentSeconds = int(_time % 60);
			_currentMinutes = int((_time / 60) % 60);
			_totalSeconds = int(_duration % 60);
			_totalMinutes = int((_duration / 60) % 60);
			_percentBuffered = (_netStream.bytesLoaded / _netStream.bytesTotal) * 100;
			_percentPlayed = (_time / _duration) * 100;
			_playedTime = setTimeFormat(_currentMinutes) + ':' + setTimeFormat(_currentSeconds);
			_totalTime = setTimeFormat(_totalMinutes) + ':' + setTimeFormat(_totalSeconds);
		}
		
		//---------------------------------------------------------------------
		//  LayerVideoMetaData
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLayerVideoMetaData():void {
			_layerVideoMetaData = LayerVideoMetaData.getInstance();
		}
		
		/**
		 * @private
		 */
		private function destroyLayerVideoMetaData():void {
			if (_layerVideoMetaData) {
				_layerVideoMetaData.destroy();
				
				_layerVideoMetaData = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  ViewPort
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPort():void {
			_viewPort = new Rectangle(0, 0, 0, 0);
		}
		
		/**
		 * @private
		 */
		private function destroyViewPort():void {
			if (_viewPort) _viewPort = null;
		}
		
		//---------------------------------------------------------------------
		//  StageVideo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStageVideo():Boolean {
			_stageVideo = _context.instance.stageReference.stageVideos[_index];
			
			if (_stageVideo) {
				_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, handleStageVideo, false, 0, true);
				_stageVideo.addEventListener(ErrorEvent.ERROR, handleErrorStageVideo, false, 0, true);
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function destroyStageVideo():void {
			if (_stageVideo) {
				_stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, handleStageVideo);
				_stageVideo.removeEventListener(ErrorEvent.ERROR, handleErrorStageVideo);
				
				_stageVideo = null;
			}
		}
		
		/**
		 * @private
		 */
		private function attachStreamOnStageVideo():void {
			if (_stageVideo && _netStream) _stageVideo.attachNetStream(_netStream);
		}
		
		/**
		 * @private
		 */
		private function playStreamOnStageVideo():Boolean {
			if (_stageVideo) {
				playNetStream();
				
				_isPlay = true;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function pauseStreamOnStageVideo():Boolean {
			if (_stageVideo) {
				pauseNetStream();
				
				_isPlay = false;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function resumeStreamOnStageVideo():Boolean {
			if (_stageVideo) {
				resumeNetStream();
				
				_isPlay = true;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function toggleStreamOnStageVideo():Boolean {
			if (_stageVideo) {
				toggleNetStream();
				
				_isPlay = !_isPlay;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function stopStreamOnStageVideo():Boolean {
			if (_stageVideo) {
				stopNetStream();
				
				_isPlay = false;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function updateViewPortPosition(width:int = 0, height:int = 0):void {
			var tempX:int = 0;
			var tempY:int = 0;
			var tempWidth:int = _viewPort.width;
			var tempHeight:int = _viewPort.height;
			var stageWidth:int = _context.contextWidth;
			var stageHeight:int = _context.contextHeight;
			
			if (width != 0) tempWidth = width;
			if (height != 0) tempHeight = height;
			
			if (_videoPosition == LayerVideoPosition.TOP_LEFT || _videoPosition == LayerVideoPosition.LEFT || _videoPosition == LayerVideoPosition.BOTTOM_LEFT) tempX = _videoHorizontalMargin;
			if (_videoPosition == LayerVideoPosition.TOP || _videoPosition == LayerVideoPosition.BOTTOM) tempX = (stageWidth - tempWidth) >> 1;
			if (_videoPosition == LayerVideoPosition.TOP_RIGHT || _videoPosition == LayerVideoPosition.RIGHT || _videoPosition == LayerVideoPosition.BOTTOM_RIGHT) tempX = stageWidth - _videoHorizontalMargin - tempWidth;
			if (_videoPosition == LayerVideoPosition.TOP_LEFT || _videoPosition == LayerVideoPosition.TOP || _videoPosition == LayerVideoPosition.TOP_RIGHT) tempY = _videoVerticalMargin;
			if (_videoPosition == LayerVideoPosition.LEFT || _videoPosition == LayerVideoPosition.RIGHT) tempY = (stageHeight - tempHeight) >> 1;
			if (_videoPosition == LayerVideoPosition.BOTTOM_LEFT || _videoPosition == LayerVideoPosition.BOTTOM || _videoPosition == LayerVideoPosition.BOTTOM_RIGHT) tempY = stageHeight - _videoVerticalMargin - tempHeight;
			if (_videoPosition == LayerVideoPosition.CENTER) {
				tempX = ((stageWidth - tempWidth) >> 1) + _videoHorizontalMargin;
				tempY = ((stageHeight - tempHeight) >> 1) + _videoVerticalMargin;
			}
			
			updateViewPort(tempX, tempY, tempWidth, tempHeight);
		}
		
		/**
		 * @private
		 */
		private function setViewPortOnStageVideo():void {
			updateViewPort(0, 0, _layerVideoMetaData.videoWidth, _layerVideoMetaData.videoHeight);
		}
		
		/**
		 * @private
		 */
		private function scaleViewPortOnStage():void {
			var ratio:Number = 0;
			var x:int = 0;
			var y:int = 0;
			var width:int = 0;
			var height:int = 0;
			var stageWidth:int = _context.contextWidth;
			var stageHeight:int = _context.contextHeight;
			var videoWidth:int = _layerVideoMetaData.videoWidth;
			var videoHeight:int = _layerVideoMetaData.videoHeight;
			
			switch (_ratioType) {
				case(LayerVideoRatio.SCALE_ON_STAGEWIDTH):
					ratio = Math.min((stageWidth / videoWidth), (videoHeight / videoHeight));
					break;
					
				case(LayerVideoRatio.SCALE_ON_STAGEWIDTH):
					ratio = Math.min((videoWidth / videoWidth), (stageHeight / videoHeight));
					break;
					
				default:
					ratio = 1;
					break;
			}
			
			width = videoWidth * ratio;
			height = videoHeight * ratio;
			x = (stageWidth - width) >> 1;
			y = (stageHeight - height) >> 1;
			
			updateViewPort(x, y, width, height);
		}
		
		/**
		 * @private
		 */
		private function updateViewPort(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void {
			if (!_viewPort) _viewPort = new Rectangle();
			
			_viewPort.x = x;
			_viewPort.y = y;
			_viewPort.width = width;
			_viewPort.height = height;
			
			if (_stageVideo) _stageVideo.viewPort = _viewPort
		}
		
		/**
		 * @private
		 */
		private function handleStageVideo(e:StageVideoEvent):void {
			switch (e.type) {
				case(StageVideoEvent.RENDER_STATE):
					_status = e.status;
					
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_RENDER, false, false, _currentStream, null, _volume));
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleErrorStageVideo(e:ErrorEvent):void {
			switch (e.type) {
				case(ErrorEvent.ERROR):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_ERROR, false, false, _currentStream, e.text, _volume));
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  NetConnection
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupNetConnection():void {
			_netConnection = new NetConnection();
			_netConnection.connect(null);
		}
		
		/**
		 * @private
		 */
		private function destroyNetConnection():void {
			if (_netConnection) {
				try {
					_netConnection.close();
				} catch (er:Error) {
					
				}
				
				_netConnection = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  NetStream
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupNetStream():void {
			_netStream = new NetStream(_netConnection);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus, false, 0, true);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsync, false, 0, true);
			_netStream.client = this;
			_netStream.bufferTime = 1;
		}
		
		/**
		 * @private
		 */
		private function destroyNetStream():void {
			if (_netStream) {
				try {
					_netStream.dispose();
					_netStream.close();
				} catch (er:Error) {
					
				}
				
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
				_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsync);
				_netStream = null;
			}
		}
		
		/**
		 * @private
		 */
		private function playNetStream():void {
			if (_netStream) _netStream.play(_currentStream);
		}
		
		/**
		 * @private
		 */
		private function pauseNetStream():void {
			if (_netStream) _netStream.pause();
		}
		
		/**
		 * @private
		 */
		private function resumeNetStream():void {
			if (_netStream) _netStream.resume();
		}
		
		/**
		 * @private
		 */
		private function toggleNetStream():void {
			if (_netStream) _netStream.togglePause();
		}
		
		/**
		 * @private
		 */
		private function stopNetStream():void {
			if (_netStream) _netStream.seek(this._duration - 0.001);
		}
		
		/**
		 * @private
		 */
		private function seekStream(offset:Number):void {
			if (_netStream) _netStream.seek(offset);
		}
		
		/**
		 *  @private
		 */
		private function setStreamVolume():void {
			if (_netStream) _netStream.soundTransform = new SoundTransform(_volume);
		}
		
		/**
		 *  @private
		 */
		private function getStreamTime():Number {
			if (_netStream) return _netStream.time;
			
			return 0;
		}
		
		/**
		 * @private
		 */
		private function handleNetStatus(e:NetStatusEvent):void {
			switch (e.info.code) {
				case ('NetStream.Play.StreamNotFound'):
					reset();
					
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_STREAM_NOT_FOUND, false, false, _currentStream, null, _volume));
					break;
					
				case ('NetStream.Play.Start'):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_PLAYSTREAM, false, false, _currentStream, null, _volume));
					break;
					
				case ('NetStream.Play.Stop'):
					_allowRendering = false;
					
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_STOPSTREAM, false, false, _currentStream, null, _volume));
					break;
					
				case ('NetStream.Pause.Notify'):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_PAUSESTREAM, false, false, _currentStream, null, _volume));
					break;
					
				case ('NetStream.Unpause.Notify'):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_RESUMESTREAM, false, false, _currentStream, null, _volume));
					break;
						
				case ('NetStream.Seek.Notify'):
					resumeNetStream();
					break;
					
				case ('NetStream.Seek.Complete'):
					break;
					
				case ('NetStream.SeekStart.Notify'):
					pauseNetStream();
					break;
					
				case ('NetStream.Buffer.Empty'):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_BUFFER_EMPTY, false, false, _currentStream, null, _volume));
					break;
					
				case ('NetStream.Buffer.Flush'):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_BUFFER_FLUSH, false, false, _currentStream, null, _volume));
					break;
					
				case ('NetStream.Buffer.Full'):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_BUFFER_FULL, false, false, _currentStream, null, _volume));
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleAsync(e:AsyncErrorEvent):void {
			switch (e.type) {
				case(AsyncErrorEvent.ASYNC_ERROR):
					this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_ERROR, false, false, _currentStream, LayerErrorType.STAGEVIDEO_ASYNCHRONOUS_ERROR, _volume));
					break;
					
				default:
					break
			}
		}
		
		//---------------------------------------------------------------------
		//  Stream Infos
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setStreamInfos():void {
			if (!_currentStream) return;
			
			var slash:int = _currentStream.lastIndexOf('/');
			var dot:int = _currentStream.lastIndexOf('.');
			
			if (slash == -1) {
				_currentStreamName = _currentStream.substring(0, dot);
			} else {
				_currentStreamName = _currentStream.substring(slash + 1, dot);
			}
			
			if (dot == -1) {
				_currentStreamType = '';
			} else {
				_currentStreamType = _currentStream.substring(dot + 1, _currentStream.length);
			}
		}
		
		//---------------------------------------------------------------------
		//  Tools
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setTimeFormat(time:int):String {
			var stringTime:String = time.toString();
			var convertedTime:String = '';
			var charsLength:int = 2;
			
			if (stringTime.length < charsLength) {
				convertedTime = '0' + stringTime;
			} else {
				convertedTime = stringTime.toString();
			}
			
			return convertedTime;
		}
		
		
		/**
		 * Setup LayerVideo. Must be overrided and called at first in child.
		 */
		public function setup():void {
			init();
			setupLayerVideoMetaData();
			listenEvents();
			
			this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_SETUP, false, false, _currentStream, null, _volume));
		}
		
		/**
		 * Destroy LayerVideo. Must be overrided and call at last in child.
		 */
		public function destroy():void {
			destroyStageVideo();
			destroyViewPort();
			destroyNetConnection();
			destroyNetStream();
			destroyLayerVideoMetaData();
			unlistenEvents();
			
			this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_DESTROY, false, false, _currentStream, null, _volume));
			
			_context = null;
			_id = null;
			_index = 0;
			_scaleOnStage = false;
			_ratioType = null;
			_videoPosition = null;
			_videoHorizontalMargin = 0;
			_videoVerticalMargin = 0;
			_currentStream = null;
			_currentStreamName = null;
			_currentStreamType = null;
			_totalTime = null;
			_playedTime = null;
			_duration = 0;
			_currentSeconds = 0;
			_currentMinutes = 0;
			_totalSeconds = 0;
			_totalMinutes = 0;
			_percentBuffered = 0;
			_percentPlayed = 0;
			_volume = 0;
			_status = null;
			_time = 0;
			_duration = 0;
			_allowSetID = false;
			_isStageVideoAvailable = false;
			_onMetaDataReceived = false;
			_allowRendering = false;
			_isPlaying = false;
			_isPlay = false;
		}
		
		/**
		 * Called when RenderEngine is rendering. Don't call it !
		 */
		public final function onRender():void {
			if (_allowRendering) {
				render();
				
				this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_ONSTREAM, false, false, _currentStream, null, _volume));
			}
		}
		
		/**
		 * Called when player window is resized. Don't call it !
		 */
		public final function onResize():void {
			if (_scaleOnStage) {
				scaleViewPortOnStage();
			} else {
				updateViewPortPosition();
			}
		}
		
		/**
		 * Call when StageVideo is available and ready. Must be overrided and used to start playing video.
		 */
		public function ready():void {
			
		}
		
		/**
		 * Play Stream on StageVideo.
		 * 
		 * @param	stream
		 */
		public final function play(stream:String):void {
			_currentStream = stream;
			
			setStreamInfos();
			playStreamOnStageVideo();
		}
		
		/**
		 * Pause current stream if playing.
		 */
		public final function pause():void {
			pauseStreamOnStageVideo();
		}
		
		/**
		 * Resume current stream if playing.
		 */
		public final function resume():void {
			resumeStreamOnStageVideo();
		}
		
		/**
		 * Toggle current stream if playing.
		 */
		public final function toggle():void {
			toggleStreamOnStageVideo();
		}
		
		/**
		 * Stop current stream if playing.
		 */
		public final function stop():void {
			stopStreamOnStageVideo();
		}
		
		/**
		 * Seek stream by offset.
		 * 
		 * @param	offset
		 */
		public final function seekOffset(offset:Number):void {
			seekStream(offset);
		}
		
		/**
		 * Seek stream by step.
		 * 
		 * @param	step
		 */
		public final function seekByStep(step:Number):void {
			this.seekOffset(getStreamTime() + step);
		}
		
		/**
		 * Set sound volume.
		 * 
		 * @param	value : Between 0 and 1
		 */
		public final function setVolume(value:Number):void {
			value = Math.min(1, value);
			value = Math.max(0, value);
			
			_volume = value;
			
			setStreamVolume();
			
			this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_CHANGE_VOLUME, false, false, _currentStream, null, _volume));
		}
		
		/**
		 * Set sound volume by step.
		 * 
		 * @param	step : Between 0 and 1
		 */
		public final function setVolumeByStep(step:Number):void {
			this.setVolume(this.volume + step);
		}
		
		/**
		 * Set video size if scaleOnStage property is false.
		 * 
		 * @param	width
		 * @param	height
		 */
		public final function setSize(width:int, height:int):void {
			if (!_scaleOnStage) updateViewPortPosition(width, height);
		}
		
		/**
		 * Set video scaled size if scaleOnStage property is false.
		 * 
		 * @param	size
		 * @param	scaleType : 'scaleOnWidth' / 'scaleOnHeight' on LayerVideoScaleType.
		 */
		public final function setScaleSize(size:int, scaleType:String):void {
			if (_scaleOnStage) return;
			
			var ratio:Number = 0;
			var width:int = 0;
			var height:int = 0;
			var videoWidth:int = _layerVideoMetaData.videoWidth;
			var videoHeight:int = _layerVideoMetaData.videoHeight;
			
			switch (scaleType) {
				case(LayerVideoScaleType.SCALE_ON_WIDTH):
					ratio = Math.min((size / videoWidth), (videoHeight / videoHeight));
					break;
					
				case(LayerVideoScaleType.SCALE_ON_HEIGHT):
					ratio = Math.min((videoWidth / videoWidth), (size / videoHeight));
					break;
					
				default:
					ratio = 1;
					break;
			}
			
			width = videoWidth * ratio;
			height = videoHeight * ratio;
			
			updateViewPortPosition(width, height);
		}
		
		/**
		 * Client : On MetaData received.
		 * 
		 * @param	info
		 */
		public final function onMetaData(info:Object):void {
			_layerVideoMetaData.audioCodecID = info.audiocodecid;
			_layerVideoMetaData.videoCodecID = info.videocodecid;
			_layerVideoMetaData.avcLevel = info.avclevel;
			_layerVideoMetaData.avcProfile = info.avcprofile;
			_layerVideoMetaData.duration = info.duration;
			_layerVideoMetaData.videoFramerate = info.videoframerate;
			_layerVideoMetaData.audioSamplerate = info.audiosamplerate;
			_layerVideoMetaData.audioChannels = info.audiochannels;
			_layerVideoMetaData.videoWidth = info.width;
			_layerVideoMetaData.videoHeight = info.height;
			
			_time = getStreamTime();
			_duration = info.duration;
			_onMetaDataReceived = true;
			
			if (_scaleOnStage) {
				scaleViewPortOnStage();
			} else {
				setViewPortOnStageVideo();
			}
			
			_allowRendering = true;
			
			this.dispatchEvent(new LayerVideoEvent(LayerVideoEvent.LAYERVIDEO_METADATA_RECEIVED, false, false, _currentStream, null, _volume));
		}
		
		/**
		 * Client : On XMPData received.
		 * 
		 * @param	info
		 */
		public final function onXMPData(info:Object):void {
			
		}
		
		/**
		 * Client : On Cue Point.
		 * 
		 * @param	info
		 */
		public final function onCuePoint(info:Object):void {
			
		}
		
		/**
		 * Client : On Play Status.
		 * 
		 * @param	info
		 */
		public final function onPlayStatus(info:Object):void {
			
		}
		
		
		/**
		 * @private
		 */
		public function set context(value:IContext):void {
			_context = value;
		}
		
		/**
		 * @private
		 */
		public function get context():IContext {
			return _context;
		}
		
		/**
		 * @private
		 */
		public function set id(value:String):void {
			if (_allowSetID) {
				_id = value;
				
				_allowSetID = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get id():String {
			return _id;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void {
			_index = value;
		}
		
		/**
		 * @private
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * @private
		 */
		public function set scaleOnStage(value:Boolean):void {
			_scaleOnStage = value;
		}
		
		/**
		 * @private
		 */
		public function get scaleOnStage():Boolean {
			return _scaleOnStage;
		}
		
		/**
		 * @private
		 */
		public function set ratioType(value:String):void {
			_ratioType = value;
		}
		
		/**
		 * @private
		 */
		public function get ratioType():String {
			return _ratioType;
		}
		
		/**
		 * @private
		 */
		public function set videoPosition(value:String):void {
			_videoPosition = value;
		}
		
		/**
		 * @private
		 */
		public function get videoPosition():String {
			return _videoPosition;
		}
		
		/**
		 * @private
		 */
		public function set videoHorizontalMargin(value:int):void {
			_videoHorizontalMargin = value;
		}
		
		/**
		 * @private
		 */
		public function get videoHorizontalMargin():int {
			return _videoHorizontalMargin;
		}
		
		/**
		 * @private
		 */
		public function set videoVerticalMargin(value:int):void {
			_videoVerticalMargin = value;
		}
		
		/**
		 * @private
		 */
		public function get videoVerticalMargin():int {
			return _videoVerticalMargin;
		}
		
		/**
		 * @private
		 */
		public function get viewPort():Rectangle {
			return _viewPort;
		}
		
		/**
		 * @private
		 */
		public function get stageVideo():StageVideo {
			return _stageVideo;
		}
		
		/**
		 * @private
		 */
		public function get currentStream():String {
			return _currentStream;
		}
		
		/**
		 * @private
		 */
		public function get currentStreamName():String {
			return _currentStreamName;
		}
		
		/**
		 * @private
		 */
		public function get currentStreamType():String {
			return _currentStreamType;
		}
		
		/**
		 * @private
		 */
		public function get totalTime():String {
			return _totalTime;
		}
		
		/**
		 * @private
		 */
		public function get playedTime():String {
			return _playedTime;
		}
		
		/**
		 * @private
		 */
		public function get time():Number {
			return _time;
		}
		
		/**
		 * @private
		 */
		public function get duration():Number {
			return _duration;
		}
		
		/**
		 * @private
		 */
		public function get currentSeconds():int {
			return _currentSeconds;
		}
		
		/**
		 * @private
		 */
		public function get currentMinutes():int {
			return _currentMinutes;
		}
		
		/**
		 * @private
		 */
		public function get totalSeconds():int {
			return _totalSeconds;
		}
		
		/**
		 * @private
		 */
		public function get totalMinutes():int {
			return _totalMinutes;
		}
		
		/**
		 * @private
		 */
		public function get percentBuffered():Number {
			return _percentBuffered;
		}
		
		/**
		 * @private
		 */
		public function get percentPlayed():Number {
			return _percentPlayed;
		}
		
		/**
		 * @private
		 */
		public function get volume():Number {
			return _volume;
		}
		
		/**
		 * @private
		 */
		public function get status():String {
			return _status;
		}
		
		/**
		 * @private
		 */
		public function get metaData():LayerVideoMetaData {
			return _layerVideoMetaData;
		}
		
		/**
		 * @private
		 */
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**
		 * @private
		 */
		public function get isPlay():Boolean {
			return _isPlay;
		}
		
		/**
		 * @private
		 */
		public function get isStageVideoAvailable():Boolean {
			return _isStageVideoAvailable;
		}
		
		/**
		 * @private
		 */
		public function get onMetaDataReceived():Boolean {
			return _onMetaDataReceived;
		}
	}
}