/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.component {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.context.IContext;
	import artcustomer.framework.core.*;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * AbstractInteractiveComponent : Events system available after building Component.
	 * 
	 * @author David Massenot
	 */
	public class AbstractInteractiveComponent extends EventDispatcher implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.component::AbstractInteractiveComponent';
		
		private var _id:String;
		private var _index:int;
		private var _context:IContext;
		private var _model:IModel;
		private var _command:ICommand;
		
		private var _isActivate:Boolean;
		
		private var _allowSetID:Boolean;
		private var _allowSetContext:Boolean;
		private var _allowSetModel:Boolean;
		private var _allowSetCommand:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractInteractiveComponent() {
			_allowSetID = true;
			_allowSetContext = true;
			_allowSetModel = true;
			_allowSetCommand = true;
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_INTERACTIVECOMPONENT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Model
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupModel():void {
			if (_model) _model.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyModel():void {
			if (_model) {
				_model.destroy();
				_model = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Command
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupCommand():void {
			if (_command) _command.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyCommand():void {
			if (_command) {
				_command.destroy();
				_command = null;
			}
		}
		
		
		/**
		 * Entry point.
		 */
		public function build():void {
			setupModel();
			setupCommand();
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			destroyCommand();
			destroyModel();
			
			_id = null;
			_index = 0;
			_context = null;
			_model = null;
			_command = null;
			_isActivate = false;
			_allowSetID = false;
			_allowSetContext = false;
			_allowSetModel = false;
			_allowSetCommand = false;
		}
		
		/**
		 * Activate Component, useful for adding event listeners here. Must be overrided and called at first.
		 */
		public function activate():void {
			if (!_isActivate) {
				_isActivate = true;
			} else {
				return;
			}
		}
		
		/**
		 * Deactivate Component, useful for removed event listeners here. Must be overrided and called at first.
		 */
		public function deactivate():void {
			if (_isActivate) {
				_isActivate = false;
			} else {
				return;
			}
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
		
		/**
		 * @private
		 */
		public function set context(value:IContext):void {
			if (_allowSetContext) {
				_context = value;
				
				_allowSetContext = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get context():IContext {
			return _context;
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
		public function set command(value:ICommand):void {
			if (_allowSetCommand) {
				_command = value;
				
				_allowSetCommand = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get command():ICommand {
			return _command;
		}
	}
}