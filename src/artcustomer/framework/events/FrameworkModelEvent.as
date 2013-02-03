/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.core.IModel;
	
	
	/**
	 * FrameworkModelEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkModelEvent extends Event {
		public static const MODEL_SETUP:String = 'modelSetup';
		public static const MODEL_RESET:String = 'modelReset';
		public static const MODEL_DESTROY:String = 'modelDestroy';
		public static const MODEL_INIT:String = 'modelInit';
		public static const MODEL_UPDATE:String = 'modelUpdate';
		public static const MODEL_UPDATE_ALL_VIEWS:String = 'modelUpdateAllViews';
		public static const MODEL_UPDATE_VIEW:String = 'modelUpdateView';
		
		private var _model:IModel;
		private var _viewID:String;
		
		
		public function FrameworkModelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, model:IModel = null, viewID:String = null) {
			_model = model;
			_viewID = viewID;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkModelEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkModelEvent(type, bubbles, cancelable, this.model, this.viewID);
		}
		
		/**
		 * Get String value of FrameworkModelEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkModelEvent", "type", "bubbles", "cancelable", "eventPhase", "model", "viewID"); 
		}
		
		
		/**
		 * @private
		 */
		public function get model():IModel {
			return _model;
		}
		
		/**
		 * @private
		 */
		public function get viewID():String {
			return _viewID;
		}
	}
}