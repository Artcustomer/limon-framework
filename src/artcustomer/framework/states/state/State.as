/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.states.state {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.utils.tools.StringTools;
	
	
	/**
	 * State
	 * 
	 * @author David Massenot
	 */
	public class State extends Object implements IDestroyable {
		private var _id:String;
		private var _entry:Function;
		private var _exit:Function;
		
		
		/**
		 * Constructor
		 */
		public function State(id:String, entry:Function, exit:Function) {
			_id = id;
			_entry = entry;
			_exit = exit;
		}
		
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'State', 'id', 'entry', 'exit');
		}
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			_id = null;
			_entry = null;
			_exit = null;
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
		public function get entry():Function {
			return _entry;
		}
		
		/**
		 * @private
		 */
		public function get exit():Function {
			return _exit;
		}
	}
}