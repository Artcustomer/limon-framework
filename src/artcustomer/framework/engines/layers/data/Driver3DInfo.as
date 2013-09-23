/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers.data {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.errors.FrameworkError;
	import artcustomer.framework.utils.tools.StringTools;
	
	
	/**
	 * Driver3DInfo
	 * 
	 * @author David Massenot
	 */
	public class Driver3DInfo extends Object implements IDestroyable {
		private var _driverInfo:String;
		private var _mode:String;
		private var _description:String;
		private var _driver:String;
		private var _version:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	driverInfo : Driver Info
		 */
		public function Driver3DInfo(driverInfo:String) {
			if (driverInfo) {
				_driverInfo = driverInfo;
				
				parseDriverInfo();
			}
		}
		
		//---------------------------------------------------------------------
		//  Parsing
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function parseDriverInfo():void {
			var delim:String = '=';
			var spaceDelim:String = ' ';
			var charsArray:Array = _driverInfo.split(delim);
			var charsArrayLength:int = charsArray.length;
			
			try {
				if (charsArrayLength > 1) {
					_mode = charsArray[0].substr(0, charsArray[0].lastIndexOf(spaceDelim));
					_description = charsArray[1].substr(0, charsArray[1].lastIndexOf(spaceDelim));
					_driver = charsArray[2].substr(0, charsArray[2].lastIndexOf(spaceDelim));
					_version = charsArray[3].substr(0, charsArray[3].lastIndexOf(spaceDelim));
				} else {
					_mode = _driverInfo;
				}
			} catch (er:Error) {
				throw new FrameworkError(FrameworkError.E_LAYER3D_PARSE_DRIVER, FrameworkError.ERROR_ID);
			}
		}
		
		
		/**
		 * Get String value of object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'Driver3DInfo', 'driverInfo', 'mode', 'description', 'driver', 'version');
		}
		
		/**
		 * Destroy instance.
		 */
		public function destroy():void {
			_driverInfo = null;
			_mode = null;
			_description = null;
			_driver = null;
			_version = null;
		}
		
		
		/**
		 * @private
		 */
		public function get driverInfo():String {
			return _driverInfo;
		}
		
		/**
		 * @private
		 */
		public function get mode():String {
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function get description():String {
			return _description;
		}
		
		/**
		 * @private
		 */
		public function get driver():String {
			return _driver;
		}
		
		/**
		 * @private
		 */
		public function get version():String {
			return _version;
		}
	}
}