/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.debug.tracer {
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * DebugTracer
	 * 
	 * @author David Massenot
	 */
	public class DebugTracer {
		public static const PROD_MODE:String = 'prod';
		public static const DEV_MODE:String = 'dev';
		public static const DEBUG_MODE:String = 'debug';
		public static const TEST_MODE:String = 'test';
		
		private static var __mode:String;
		
		
		/**
		 * Add Flash trace.
		 * 
		 * @param	target : Object that contains the trace
		 * @param	id : Name
		 * @param	...rest : Properties to set in the trace
		 */
		public static function addTrace(target:Object, id:String, ...rest):void {
			if (!target) return;
			if (!id) id = 'null';
			
			switch (__mode) {
				case(PROD_MODE):
					// No trace
					break;
					
				case(DEV_MODE):
					trace(rest);
					break;
					
				case(DEBUG_MODE):
					trace(getQualifiedClassName(target), ' :: ', rest);
					break;
					
				case(TEST_MODE):
					trace('[[ ' + id + ' ]]', rest);
					break;
					
				default:
					trace(rest);
					break;
			}
		}
		
		/**
		 * Add Flash log.
		 * 
		 * @param	target
		 * @param	member
		 */
		public static function addLog(target:Object, member:String):void {
			if (!target) return;
			if (!member) member = 'null';
			
			switch (__mode) {
				case(PROD_MODE):
					// No trace
					break;
					
				case(DEV_MODE):
					trace(member);
					break;
					
				case(DEBUG_MODE):
					trace(getQualifiedClassName(target), ' :: ', member);
					break;
					
				case(TEST_MODE):
					trace(member);
					break;
					
				default:
					trace(member);
					break;
			}
		}
		
		/**
		 * Set DebugTracer mode.
		 * 
		 * @param	mode : Specify mode to render trace (PROD_MODE / DEV_MODE / DEBUG_MODE)
		 */
		public static function setMode(mode:String):void {
			__mode = mode;
		}
	}
}