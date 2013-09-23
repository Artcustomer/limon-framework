/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.display.Stage3D;
	import flash.events.Event;
	
	import artcustomer.framework.engines.layers.Layer3D;
	
	
	/**
	 * Layer3DEvent
	 * 
	 * @author David Massenot
	 */
	public class Layer3DEvent extends Event {
		public static const LAYER3D_SETUP:String = 'layer3dSetup';
		public static const LAYER3D_DESTROY:String = 'layer3dDestroy';
		public static const LAYER3D_ERROR:String = 'layer3dError';
		public static const LAYER3D_CREATE:String = 'layer3dCreate';
		
		private var _layer3DIndex:int;
		private var _error:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	_layer3DIndex
		 * @param	error
		 */
		public function Layer3DEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, _layer3DIndex:int = 0, error:String = null) {
			_layer3DIndex = layer3DIndex;
			_error = error;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone Layer3DEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new Layer3DEvent(type, bubbles, cancelable, _layer3DIndex, _error);
		}
		
		/**
		 * Get String value of Layer3DEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("Layer3DEvent", "type", "bubbles", "cancelable", "eventPhase", "layer3DIndex", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get layer3DIndex():int {
			return _layer3DIndex;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}