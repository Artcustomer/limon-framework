/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.events {
	import flash.events.Event;
	
	import artcustomer.framework.loaders.assets.medias.AbstractLoadableAsset;
	
	
	/**
	 * LoadableAssetEvent
	 * 
	 * @author David Massenot
	 */
	public class LoadableAssetEvent extends Event {
		public static const ASSET_LOADING_PROGRESS:String = 'assetLoadingProgress';
		public static const ASSET_LOADING_ERROR:String = 'assetLoadingError';
		public static const ASSET_LOADING_COMPLETE:String = 'assetLoadingComplete';
		
		private var _asset:AbstractLoadableAsset;
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		private var _progress:Number;
		private var _error:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	asset
		 * @param	bytesLoaded
		 * @param	bytesTotal
		 * @param	progress
		 * @param	error
		 */
		public function LoadableAssetEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, asset:AbstractLoadableAsset = null, bytesLoaded:Number = 0, bytesTotal:Number = 0, progress:Number = 0, error:String = null) {
			_asset = asset;
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			_progress = progress;
			_error = error;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone LoadableAssetEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new LoadableAssetEvent(type, bubbles, cancelable, _asset, _bytesLoaded, _bytesTotal, _progress, _error);
		}
		
		/**
		 * Get String format of LoadableAssetEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("LoadableAssetEvent", "type", "bubbles", "cancelable", "eventPhase", "asset", "bytesLoaded", "bytesTotal", "progress", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get asset():AbstractLoadableAsset {
			return _asset;
		}
		
		/**
		 * @private
		 */
		public function get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		/**
		 * @private
		 */
		public function get bytesTotal():Number {
			return _bytesTotal;
		}
		
		/**
		 * @private
		 */
		public function get progress():Number {
			return _progress;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}