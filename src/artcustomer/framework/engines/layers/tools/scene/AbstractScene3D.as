/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers.tools.scene {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.engines.layers.Layer3D;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * AbstractScene3D
	 * 
	 * @author David Massenot
	 */
	public class AbstractScene3D extends Object implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.layers.tools.scene::AbstractScene3D';
		
		private var _index:int;
		private var _id:String;
		
		private var _layer3D:Layer3D;
		
		private var _allowSetID:Boolean;
		private var _allowSetLayer:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractScene3D() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_SCENE3D_CONSTRUCTOR);
			
			_allowSetID = true;
			_allowSetLayer = true;
		}
		
		
		/**
		 * Setup scene. Must be overrided.
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destroy scene. Must be overrided.
		 */
		public function destroy():void {
			_id = null;
			_index = 0;
			_layer3D = null;
			_allowSetID = false;
			_allowSetLayer = false;
		}
		
		/**
		 * Render scene. Called by Layer3D if RenderEngine is on. Override it !
		 */
		public function render():void {
			
		}
		
		
		/**
		 * @private
		 */
		public function set layer3D(value:Layer3D):void {
			if (_allowSetLayer) {
				_layer3D = value;
				
				_allowSetLayer = false;
			}
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
	}
}