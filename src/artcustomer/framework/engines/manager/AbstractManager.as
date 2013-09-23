/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.manager {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.context.*;
	import artcustomer.framework.errors.IllegalError;
	
	
	/**
	 * AbstractManager
	 * 
	 * @author David Massenot
	 */
	public class AbstractManager extends Object implements IDestroyable {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.manager::AbstractManager';
		
		private var _id:String;
		private var _context:IContext;
		
		
		/**
		 * Constructor
		 */
		public function AbstractManager() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_ABSTRACTVIEW_CONSTRUCTOR);
		}
		
		
		/**
		 * Entry point of the Manager. Must be overrided and called at first in child.
		 */
		public function build():void {
			
		}
		
		/**
		 * Destroy Manager. Must be overrided and called at last in child.
		 */
		public function destroy():void {
			_id = null;
			_context = null;
		}
		
		
		/**
		 * @private
		 */
		public function set id(value:String):void {
			_id = value;
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
		public function set context(value:IContext):void {
			_context = value;
		}
		
		/**
		 * @private
		 */
		public function get context():IContext {
			return _context;
		}
	}
}