/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers.tools.template {
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.engines.layers.Layer3D;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * AbstractEngineTemplate
	 * 
	 * @author David Massenot
	 */
	public class AbstractEngineTemplate extends Object implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.layers.tools.template::AbstractEngineTemplate';
		
		private var _layer3D:Layer3D;
		
		private var _allowSetLayer:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractEngineTemplate() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_ENGINETEMPLATE_CONSTRUCTOR);
			
			_allowSetLayer = true;
		}
		
		
		/**
		 * Setup template. Must be overrided.
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destroy template. Must be overrided.
		 */
		public function destroy():void {
			_layer3D = null;
			_allowSetLayer = false;
		}
		
		/**
		 * Render template. Called by Layer3D if RenderEngine is on. Override it !
		 */
		public function render():void {
			
		}
		
		/**
		 * Resize template. Called when Stage is resized. Override it !
		 */
		public function resize():void {
			
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
	}
}