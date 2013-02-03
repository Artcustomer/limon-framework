/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils {
	
	
	/**
	 * InputUtils
	 * 
	 * @author David Massenot
	 */
	public class InputUtils {
		
		
		/**
		 * Get key name by key code.
		 * 
		 * @param	keyCode
		 * @return
		 */
		public static function getNameByKeycode(keyCode:uint):String {
			var keyName:String = '';
			
			switch(keyCode) {
				case 8:
					keyName = 'Backspace';
					break;
					
				case 13:
					keyName = 'Enter';
					break;
					
				case 16:
					keyName = 'Shift';
					break;
					
				case 17:
					keyName = 'Ctrl';
					break;
					
				case 18:
					keyName = 'Alt';
					break;
					
				case 19:
					keyName = 'Pause';
					break;
					
				case 20:
					keyName = 'Caps Lock';
					break;
					
				case 27:
					keyName = 'Esc';
					break;
					
				case 32:
					keyName = 'Space';
					break;
					
				case 33:
					keyName = 'PgUp';
					break;
					
				case 34:
					keyName = 'PgDn';
					break;
					
				case 35:
					keyName = 'End';
					break;
					
				case 36:
					keyName = 'Home';
					break;
					
				case 37:
					keyName = 'Left';
					break;
					
				case 38:
					keyName = 'Up';
					break;
					
				case 39:
					keyName = 'Right';
					break;
					
				case 40:
					keyName = 'Down';
					break;
					
				case 45:
					keyName = 'Insert';
					break;
					
				case 46:
					keyName = 'Delete';
					break;
					
				case 112:
					keyName = 'F1';
					break;
					
				case 113:
					keyName = 'F2';
					break;
					
				case 114:
					keyName = 'F3';
					break;
					
				case 115:
					keyName = 'F4';
					break;
					
				case 116:
					keyName = 'F5';
					break;
					
				case 117:
					keyName = 'F6';
					break;
					
				case 118:
					keyName = 'F7';
					break;
					
				case 119:
					keyName = 'F8';
					break;
					
				case 120:
					keyName = 'F9';
					break;
					
				case 121:
					keyName = 'F10';
					break;
					
				case 122:
					keyName = 'F11';
					break;
					
				case 123:
					keyName = 'F12';
					break;
				
				case 145:
					keyName = 'Scroll Lock';
					break;
					
				default: 
					keyName = String.fromCharCode(keyCode);
					break;
			}
			
			return keyName;
		}
	}
}