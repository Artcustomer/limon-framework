/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.errors.*;
	import artcustomer.framework.events.*;
	
	
	/**
	 * AbstractCommand
	 * 
	 * @author David Massenot
	 */
	public class AbstractCommand {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractCommand';
		
		private var _model:IModel;
		private var _macros:Dictionary;
		
		private var _allowSetModel:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractCommand() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_COMMAND_CONSTRUCTOR);
			
			_allowSetModel = true;
		}
		
		//---------------------------------------------------------------------
		//  Macros Stacks
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMacroStack():void {
			if (!_macros) _macros = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyMacroStack():void {
			_macros = null;
		}
		
		/**
		 * @private
		 */
		private function clearMacroStack():void {
			if (_macros) {
				for (var id:String in _macros) {
					this.unregisterMacro(id);
				}
			}
		}
		
		//---------------------------------------------------------------------
		//  Execution
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function executeMacro(macroCommandID:String, event:Event):void {
			if (!macroCommandID) throw new FrameworkError(FrameworkError.E_COMMAND_EXECUTEMACRO);
			
			if (this.hasregisterMacro(macroCommandID)) this.getMacro(macroCommandID).execute(event);
		}
		
		
		/**
		 * Execute command. Never be overrided.
		 */
		public final function execute(event:Event, macroCommandID:String):void {
			executeMacro(macroCommandID, event);
		}
		
		/**
		 * Setup commands in controler. Must be overrided and called at first in child !
		 */
		public function setup():void {
			setupMacroStack();
		}
		
		/**
		 * Reset commands in controler. Can be overrided.
		 */
		public function reset():void {
			
		}
		
		/**
		 * Destroy commands in controler. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			clearMacroStack();
			destroyMacroStack();
			
			_model = null;
			_macros = null;
			_allowSetModel = false;
		}
		
		/**
		 * Register MacroCommand. Never be overrided.
		 * 
		 * @param	macroClass
		 * @param	macroID
		 */
		public final function registerMacro(macroClass:Class, macroID:String):void {
			if (!macroClass || !macroID) throw new FrameworkError(FrameworkError.E_MACRO_REGISTER);
			
			var macro:AbstractMacroCommand = new macroClass();
			macro.command = (this as ICommand);
			macro.id = macroID;
			macro.setup();
			
			_macros[macroID] = macro;
		}
		
		/**
		 * Unregister MacroCommand. Never be overrided.
		 * 
		 * @param	id
		 */
		public final function unregisterMacro(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_MACRO_UNREGISTER);
			
			try {
				if (_macros[id] != undefined) {
					(_macros[id] as IMacroCommand).destroy();
					
					_macros[id] = undefined;
					delete _macros[id];
				}
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Has Registered MacroCommand. Never be overrided.
		 * 
		 * @param	id
		 */
		public final function hasregisterMacro(id:String):Boolean {
			if (!id) throw new FrameworkError(FrameworkError.E_MACRO_HASREGISTER);
			
			if (_macros[id] != undefined) return true;
			
			return false;
		}
		
		/**
		 * Get MacroCommand. Never be overrided.
		 * 
		 * @param	id
		 */
		public final function getMacro(id:String):IMacroCommand {
			if (!id) throw new FrameworkError(FrameworkError.E_MACRO_GET);
			
			var macro:IMacroCommand = null;
			
			if (_macros[id] != undefined) macro = (_macros[id] as IMacroCommand);
			
			return macro;
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
	}
}