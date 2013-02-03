/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.debug.console {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	
	
	/**
	 * ConsoleLog
	 * 
	 * @author David Massenot
	 */
	public class ConsoleLog extends Object {
		public static const LEVEL_DEFAULT:String = 'default';
		public static const LEVEL_INFOS:String = 'infos';
		public static const LEVEL_DEBUG:String = 'debug';
		public static const LEVEL_WARNING:String = 'warning';
		public static const LEVEL_ERROR:String = 'error';
		
		private static const BACKGROUND_COLOR:uint = 0xFFFFFF;
		private static const TEXT_COLOR:uint = 0x000000;
		
		private static const DEFAULT_WIDTH:int = 300;
		private static const DEFAULT_HEIGHT:int = 500;
		
		private static const DEFAULT_COLOR:String = '000000';
		private static const INFOS_COLOR:String = '0000FF';
		private static const DEBUG_COLOR:String = '00FF00';
		private static const WARNING_COLOR:String = 'FFA500';
		private static const ERROR_COLOR:String = 'FF0000';
		
		private static var __instance:ConsoleLog;
		private static var __allowInstantiation:Boolean;
		
		private var _stageReference:Stage;
		
		private var _history:String;
		private var _currentLog:String;
		private var _numLogs:int;
		private var _numSpaces:int;
		
		private var _backgroundColor:uint;
		private var _textColor:uint;
		private var _defaultTextColor:String;
		
		private var _container:Sprite;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _bounds:Rectangle;
		
		private var _setBackground:Boolean;
		private var _autoScroll:Boolean;
		private var _isInit:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function ConsoleLog() {
			setupBounds();
		}
		
		//---------------------------------------------------------------------
		//  Bounds
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupBounds():void {
			_bounds = new Rectangle(0, 0, 0, 0);
		}
		
		/**
		 * @private
		 */
		private function destroyBounds():void {
			if (_bounds) _bounds = null;
		}
		
		/**
		 * @private
		 */
		private function applyBounds(position:Boolean = true, size:Boolean = false):void {
			if (!_bounds) return;
			
			if (position) moveContainer(_bounds.x, _bounds.y);
			if (size) resizeTextField(_bounds.width, _bounds.height);
		}
		
		//---------------------------------------------------------------------
		//  Container
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupContainer():void {
			_container = new Sprite();
		}
		
		/**
		 * @private
		 */
		private function destroyContainer():void {
			if (_container) {
				if (_stageReference.contains(_container)) _stageReference.removeChild(_container);
				
				_container = null;
			}
		}
		
		/**
		 * @private
		 */
		private function moveContainer(x:int, y:int):void {
			if (_container) {
				_container.x = x;
				_container.y = y;
			}
		}
		
		//---------------------------------------------------------------------
		//  Text
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTextFormat():void {
			_textFormat = new TextFormat('_sans');
		}
		
		/**
		 * @private
		 */
		private function destroyTextFormat():void {
			if (_textFormat) _textFormat = null;
		}
		
		/**
		 * @private
		 */
		private function setupTextField():void {
			_textField = new TextField();
			_textField.selectable = true;
			_textField.mouseEnabled = true;
			_textField.mouseWheelEnabled = true;
			_textField.condenseWhite = true;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.gridFitType = GridFitType.PIXEL;
			_textField.defaultTextFormat = _textFormat;
			_textField.textColor = _textColor;
			
			_container.addChild(_textField);
		}
		
		/**
		 * @private
		 */
		private function destroyTextField():void {
			if (_textField) {
				if (_container.contains(_textField)) _container.removeChild(_textField);
				
				_textField = null;
			}
		}
		
		/**
		 * @private
		 */
		private function clearTextField():void {
			if (_textField) _textField.text = '';
		}
		
		/**
		 * @private
		 */
		private function resizeTextField(width:int, height:int):void {
			if (_textField) {
				_textField.width = width;
				_textField.height = height;
				_textField.scrollRect = new Rectangle(0, 0, width, height);
			}
		}
		
		/**
		 * @private
		 */
		private function toggleTextFieldBackground():void {
			if (_textField) _textField.background = _setBackground;
		}
		
		/**
		 * @private
		 */
		private function setTextFieldBackgroundColor():void {
			if (_textField) _textField.backgroundColor = _backgroundColor;
		}
		
		/**
		 * @private
		 */
		private function setTextFieldColor():void {
			if (_textField) _textField.textColor = _textColor;
		}
		
		/**
		 * @private
		 */
		private function setText(value:String):void {
			if (_numLogs > 0) jumpLineInText();
			
			if (_textField) {
				_textField.htmlText += value;
				_currentLog = _textField.htmlText;
			}
		}
		
		/**
		 * @private
		 */
		private function jumpLineInText():void {
			if (_textField) _textField.appendText('\n');
		}
		
		/**
		 * @private
		 */
		private function updateTextScroll():void {
			if (_autoScroll) if (_textField) _textField.scrollV = _textField.maxScrollV;
		}
		
		//---------------------------------------------------------------------
		//  Log
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setLog(value:*, level:String = 'default', time:String = null, header:Boolean = false):void {
			var text:String;
			var html:String = '<font color="#[COLOR]">[TEXT]</font>';
			var color:String;
			
			switch (level) {
				case(LEVEL_DEFAULT):
					color = _defaultTextColor;
					break;
					
				case(LEVEL_INFOS):
					color = INFOS_COLOR;
					break;
					
				case(LEVEL_DEBUG):
					color = DEBUG_COLOR;
					break;
					
				case(LEVEL_WARNING):
					color = WARNING_COLOR;
					break;
					
				case(LEVEL_ERROR):
					color = ERROR_COLOR;
					break;
					
				default:
					level = LEVEL_DEFAULT;
					color = DEFAULT_COLOR;
					break;
			}
			
			text = value.toString();
			if (time) text = time + ' : ' + text;
			if (header) text = '[' + level.toUpperCase() + '] ' + text
			html = html.split('[COLOR]').join(color);
			html = html.split('[TEXT]').join(text);
			
			setText(html);
			updateTextScroll();
			
			_numLogs++;
		}
		
		
		/**
		 * Init ConsoleLog. Set params before calling this method.
		 */
		public function init():void {
			if (!_stageReference) {
				throw new Error("Can't initialize ConsoleLog without Stage reference !");
				
				return;
			}
			
			if (!_isInit) {
				_autoScroll = true;
				_isInit = true;
				_backgroundColor = BACKGROUND_COLOR;
				_textColor = TEXT_COLOR;
				_defaultTextColor = DEFAULT_COLOR;
				
				setupContainer();
				setupTextFormat();
				setupTextField();
				resize(DEFAULT_WIDTH, DEFAULT_HEIGHT);
				
				this.background = true;
				this.backgroundColor = BACKGROUND_COLOR;
			}
		}
		
		/**
		 * Destroy ConsoleLog.
		 */
		public function destroy():void {
			destroyTextField();
			destroyTextFormat();
			destroyContainer();
			destroyBounds();
			
			_stageReference = null;
			_history = null;
			_numLogs = 0;
			_numSpaces = 0;
			_backgroundColor = 0;
			_textColor = 0;
			_setBackground = false;
			_autoScroll = false;
			_isInit = false;
			
			__instance = null;
			__allowInstantiation = false;
		}
		
		/**
		 * Add Console to Stage.
		 */
		public function add():void {
			if (_stageReference && _container) if (!_stageReference.contains(_container)) _stageReference.addChild(_container);
		}
		
		/**
		 * Remove Console from Stage.
		 */
		public function remove():void {
			if (_stageReference && _container) if (_stageReference.contains(_container)) _stageReference.removeChild(_container);
		}
		
		/**
		 * Set size to Console.
		 * 
		 * @param	width
		 * @param	height
		 */
		public function resize(width:int, height:int):void {
			if (_bounds) {
				_bounds.width = width;
				_bounds.height = height;
			}
			
			applyBounds(false, true);
		}
		
		/**
		 * Set news bounds to Console.
		 * 
		 * @param	bounds
		 */
		public function setBounds(bounds:Rectangle):void {
			if (bounds) {
				_bounds = bounds;
				
				applyBounds(true, true);
			}
		}
		
		/**
		 * Set font name to text.
		 * 
		 * @param	fontName
		 * @param	embed
		 */
		public function setFont(fontName:String, embed:Boolean = false):void {
			if (_textFormat) _textFormat.font = fontName;
			
			if (_textField) {
				_textField.defaultTextFormat = _textFormat;
				_textField.embedFonts = embed;
			}
		}
		
		/**
		 * Write data in Console.
		 * 
		 * @param	value
		 * @param	level
		 * @param	displayTime
		 * @param	header
		 */
		public function log(value:*, level:String = 'default', displayTime:Boolean = false, header:Boolean = false):void {
			var date:Date = new Date();
			var time:String;
			
			if (displayTime) time = date.toTimeString();
			
			setLog(value, level, time, header);
		}
		
		/**
		 * Write space in Console.
		 */
		public function space():void {
			jumpLineInText();
			updateTextScroll();
			
			_numSpaces++;
		}
		
		/**
		 * Clear Console.
		 */
		public function clear():void {
			clearTextField();
			updateTextScroll();
			
			_currentLog = '';
			_numLogs = 0;
			_numSpaces = 0;
		}
		
		
		/**
		 * Instantiate ConsoleLog.
		 */
		public static function getInstance():ConsoleLog {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new ConsoleLog();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		/**
		 * Write log in Console (static method).
		 * 
		 * @param	value
		 * @param	level
		 * @param	displayTime
		 */
		public static function log(value:*, level:String = 'default', displayTime:Boolean = false, header:Boolean = false):void {
			getInstance().log(value, level, displayTime, header);
		}
		
		
		/**
		 * @private
		 */
		public function set stageReference(value:Stage):void {
			_stageReference = value;
		}
		
		/**
		 * @private
		 */
		public function get stageReference():Stage {
			return _stageReference;
		}
		
		/**
		 * @private
		 */
		public function set x(value:int):void {
			_bounds.x = value;
			
			applyBounds(true, false);
		}
		
		/**
		 * @private
		 */
		public function get x():int {
			return _bounds.x;
		}
		
		/**
		 * @private
		 */
		public function set y(value:int):void {
			_bounds.y = value;
			
			applyBounds(true, false);
		}
		
		/**
		 * @private
		 */
		public function get y():int {
			return _bounds.y;
		}
		
		/**
		 * @private
		 */
		public function set background(value:Boolean):void {
			_setBackground = value;
			
			toggleTextFieldBackground();
		}
		
		/**
		 * @private
		 */
		public function get background():Boolean {
			return _setBackground;
		}
		
		/**
		 * @private
		 */
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			
			setTextFieldBackgroundColor();
		}
		
		/**
		 * @private
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		/**
		 * @private
		 */
		public function set textColor(value:uint):void {
			_textColor = value;
			
			setTextFieldColor();
		}
		
		/**
		 * @private
		 */
		public function get textColor():uint {
			return _textColor;
		}
		
		/**
		 * @private
		 */
		public function set defaultTextColor(value:String):void {
			_defaultTextColor = value;
		}
		
		/**
		 * @private
		 */
		public function get defaultTextColor():String {
			return _defaultTextColor;
		}
		
		/**
		 * @private
		 */
		public function set autoScroll(value:Boolean):void {
			_autoScroll = value;
		}
		
		/**
		 * @private
		 */
		public function get autoScroll():Boolean {
			return _autoScroll;
		}
		
		/**
		 * @private
		 */
		public function get history():String {
			return _history;
		}
		
		/**
		 * @private
		 */
		public function get currentLog():String {
			return _currentLog;
		}
		
		/**
		 * @private
		 */
		public function get numLogs():int {
			return _numLogs;
		}
		
		/**
		 * @private
		 */
		public function get numSpaces():int {
			return _numSpaces;
		}
	}
}