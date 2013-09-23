/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.events {
	import flash.events.Event;
	
	
	/**
	 * AssetsLoaderEvent
	 * 
	 * @author David Massenot
	 */
	public class AssetsLoaderEvent extends Event {
		public static const LOADING_START:String = 'loadingStart';
		public static const LOADING_CLOSE:String = 'loadingClose';
		public static const LOADING_PROGRESS:String = 'loadingProgress';
		public static const LOADING_ERROR:String = 'loadingError';
		public static const LOADING_COMPLETE:String = 'loadingComplete';
		
		private var _id:String;
		private var _description:String;
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
		 * @param	id
		 * @param	description
		 * @param	bytesLoaded
		 * @param	bytesTotal
		 * @param	progress
		 * @param	error
		 */
		public function AssetsLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, id:String = null, description:String = null, bytesLoaded:Number = 0, bytesTotal:Number = 0, progress:Number = 0, error:String = null) {
			_id = id;
			_description = description;
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			_progress = progress;
			_error = error;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone AssetsLoaderEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new AssetsLoaderEvent(type, bubbles, cancelable, _id, _description, _bytesLoaded, _bytesTotal, _progress, _error);
		}
		
		/**
		 * Get String format of AssetsLoaderEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("AssetsLoaderEvent", "type", "bubbles", "cancelable", "eventPhase", "id", "description", "bytesLoaded", "bytesTotal", "progress", "error"); 
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
		public function get description():String {
			return _description;
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