/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.errors.IllegalError;
	
	
	/**
	 * AbstractMacroModel
	 * 
	 * @author David Massenot
	 */
	public class AbstractMacroModel {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractMacroModel';
		
		private var _model:IModel;
		private var _id:String;
		
		private var _allowSetModel:Boolean;
		private var _allowSetID:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractMacroModel() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_MACROMODEL_CONSTRUCTOR);
			
			_allowSetModel = true;
			_allowSetID = true;
		}
		
		
		/**
		 * Setup MacroModel. Must be overrided and called at first in child !
		 */
		public function setup():void {
			
		}
		
		/**
		 * Init MacroModel. Must be overrided and called at last in child !
		 */
		public function init():void {
			
		}
		
		/**
		 * Reset MacroModel. Must be overrided and called at first in child !
		 */
		public function reset():void {
			
		}
		
		/**
		 * Update MacroModel. Must be overrided and called at first in child !
		 */
		public function update():void {
			
		}
		
		/**
		 * Destroy MacroModel. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			_model = null;
			_id = null;
			_allowSetModel = false;
			_allowSetID = false;
		}
		
		
		/**
		 * @private
		 */
		public function set model(value:IModel):void {
			if (_allowSetModel) {
				_model = value;
				
				_allowSetModel = false;
			}
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
	}
}