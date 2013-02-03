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
	 * AbstractMacroCommand
	 * 
	 * @author David Massenot
	 */
	public class AbstractMacroCommand {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractMacroCommand';
		
		private var _command:ICommand;
		private var _id:String;
		
		private var _allowSetCommand:Boolean;
		private var _allowSetID:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractMacroCommand() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_MACROCOMMAND_CONSTRUCTOR);
			
			_allowSetCommand = true;
			_allowSetID = true;
		}
		
		
		/**
		 * Setup MacroCommand. Must be overrided and called at first in child !
		 */
		public function setup():void {
			
		}
		
		/**
		 * Destroy MacroCommand. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			_command = null;
			_id = null;
			_allowSetCommand = false;
			_allowSetID = false;
		}
		
		/**
		 * Execute MacroCommand. Must be overrided !
		 */
		public function execute(event:Event):void {
			throw new IllegalError(IllegalError.E_MACROCOMMAND_EXECUTE);
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