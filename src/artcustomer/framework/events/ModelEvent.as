/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.data.IViewData;
	
	
	/**
	 * ModelEvent
	 * 
	 * @author David Massenot
	 */
	public class ModelEvent extends Event {
		public static const NOTIFY_UPDATE:String = 'notifyUpdate';
		
		private var _updateType:String;
		private var _data:IViewData;
		private var _viewID:String;
		private var _isViewSetup:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	updateType
		 * @param	data
		 * @param	viewID
		 * @param	isViewSetup
		 */
		public function ModelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, updateType:String = null, data:IViewData = null, viewID:String = null, isViewSetup:Boolean = false) {
			_updateType = updateType;
			_data = data;
			_viewID = viewID;
			_isViewSetup = isViewSetup;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone ModelEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new ModelEvent(type, bubbles, cancelable, _updateType, _data, _viewID, _isViewSetup);
		}
		
		/**
		 * Get String value of ModelEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("ModelEvent", "type", "bubbles", "cancelable", "eventPhase", "updateType", "data", "viewID", "isViewSetup"); 
		}
		
		
		/**
		 * @private
		 */
		public function get updateType():String {
			return _updateType;
		}
		
		/**
		 * @private
		 */
		public function get data():IViewData {
			return _data;
		}
		
		/**
		 * @private
		 */
		public function get viewID():String {
			return _viewID;
		}
		
		/**
		 * @private
		 */
		public function get isViewSetup():Boolean {
			return _isViewSetup;
		}
	}
}