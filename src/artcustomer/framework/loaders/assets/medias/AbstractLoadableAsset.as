/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.medias {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.loaders.assets.events.LoadableAssetEvent;
	import artcustomer.framework.loaders.assets.consts.AssetLoadingStatus;
	import artcustomer.framework.utils.tools.FileTools;
	
	[Event(name = "assetLoadingProgress", type = "artcustomer.framework.loaders.assets.events.LoadableAssetEvent")]
	[Event(name = "assetLoadingError", type = "artcustomer.framework.loaders.assets.events.LoadableAssetEvent")]
	[Event(name = "assetLoadingComplete", type = "artcustomer.framework.loaders.assets.events.LoadableAssetEvent")]
	
	
	/**
	 * AbstractLoadableAsset
	 * 
	 * @author David Massenot
	 */
	public class AbstractLoadableAsset extends EventDispatcher implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.loaders.assets.medias::AbstractLoadableAsset';
		
		protected var _source:String;
		protected var _name:String;
		protected var _group:String;
		protected var _file:String;
		protected var _type:String;
		protected var _extension:String;
		protected var _data:*;
		protected var _bytes:*;
		
		protected var _bytesLoaded:Number;
		protected var _bytesTotal:Number;
		protected var _progress:Number;
		
		protected var _error:String;
		protected var _status:int;
		
		protected var _isLoading:Boolean;
		protected var _isOpenStream:Boolean;
		protected var _isAlreadyLoaded:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractLoadableAsset() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_ABSTRACT_CLASS);
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_progress = 0;
			_status = AssetLoadingStatus.WAITING;
			_isOpenStream = false;
			_isLoading = false;
			_isAlreadyLoaded = false;
		}
		
		
		/**
		 * Start loading. Override it !
		 */
		public function load():void {
			_file = FileTools.resolveFileInPath(_source);
			_extension = FileTools.getExtension(_source).toLowerCase();
			_isOpenStream = true;
			_status = AssetLoadingStatus.LOADING;
		}
		
		/**
		 * Close loading. Override it !
		 */
		public function close():void {
			
		}
		
		/**
		 * On progress asset loading.
		 */
		protected final function onProgress():void {
			_status = AssetLoadingStatus.LOADING;
			
			this.dispatchEvent(new LoadableAssetEvent(LoadableAssetEvent.ASSET_LOADING_PROGRESS, false, false, this, _bytesLoaded, _bytesTotal, _progress, _error));
		}
		
		/**
		 * On error asset loading.
		 */
		protected final function onError():void {
			_status = AssetLoadingStatus.FAILED;
			_isLoading = false;
			_isOpenStream = false;
			_isAlreadyLoaded = false;
			
			this.dispatchEvent(new LoadableAssetEvent(LoadableAssetEvent.ASSET_LOADING_ERROR, false, false, this, _bytesLoaded, _bytesTotal, _progress, _error));
		}
		
		/**
		 * On complete asset loading.
		 */
		protected final function onComplete():void {
			_status = AssetLoadingStatus.COMPLETED;
			_isLoading = true;
			_isOpenStream = false;
			_isAlreadyLoaded = true;
			
			this.dispatchEvent(new LoadableAssetEvent(LoadableAssetEvent.ASSET_LOADING_COMPLETE, false, false, this, _bytesLoaded, _bytesTotal, _progress, _error));
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_source = null;
			_name = null;
			_group = null;
			_file = null;
			_type = null;
			_extension = null;
			_data = null;
			_bytes = null;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_progress = 0;
			_error = null;
			_status = 0;
			_isLoading = false;
			_isOpenStream = false;
			_isAlreadyLoaded = false;
		}
		
		
		/**
		 * @private
		 */
		public function set source(value:String):void {
			_source = value;
		}
		
		/**
		 * @private
		 */
		public function get source():String {
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set group(value:String):void {
			_group = value;
		}
		
		/**
		 * @private
		 */
		public function get group():String {
			return _group;
		}
		
		/**
		 * @private
		 */
		public function get file():String {
			return _file;
		}
		
		/**
		 * @private
		 */
		public function get type():String {
			return _type;
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
		public function get status():int {
			return _status;
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
		public function get data():* {
			return _data;
		}
		
		/**
		 * @private
		 */
		public function get bytes():* {
			return _bytes;
		}
	}
}