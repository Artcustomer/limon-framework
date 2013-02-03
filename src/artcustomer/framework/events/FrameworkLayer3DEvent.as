/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.display.Stage3D;
	import flash.events.Event;
	
	import artcustomer.framework.layers.Layer3D;
	
	
	/**
	 * FrameworkLayer3DEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkLayer3DEvent extends Event {
		public static const LAYER3D_SETUP:String = 'layer3dSetup';
		public static const LAYER3D_DESTROY:String = 'layer3dDestroy';
		public static const LAYER3D_ERROR:String = 'layer3dError';
		public static const LAYER3D_CREATE:String = 'layer3dCreate';
		
		private var _layer3D:Layer3D;
		private var _stage3d:Stage3D;
		private var _error:String;
		
		
		public function FrameworkLayer3DEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, layer3D:Layer3D = null, stage3d:Stage3D = null, error:String = null) {
			_layer3D = layer3D;
			_stage3d = stage3d;
			_error = error;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkLayer3DEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkLayer3DEvent(type, bubbles, cancelable, this.layer3D, this.stage3d, this.error);
		}
		
		/**
		 * Get String value of FrameworkLayer3DEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkLayer3DEvent", "type", "bubbles", "cancelable", "eventPhase", "layer3D", "stage3d", "error"); 
		}
		
		
		/**
		 * @private
		 */
		public function get layer3D():Layer3D {
			return _layer3D;
		}
		
		/**
		 * @private
		 */
		public function get stage3d():Stage3D {
			return _stage3d;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}