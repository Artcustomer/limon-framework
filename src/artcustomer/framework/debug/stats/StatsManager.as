/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.debug.stats {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	
	
	/**
	 * StatsManager
	 * 
	 * @author David Massenot
	 */
	public class StatsManager {
		public static const MEMORY:Number = 0.000000954;
		public static const MAX_MEMORY:int = 1024 * 1024 * 40;
		
		private static const BACKGROUND_WIDTH:int = 140;
		private static const BACKGROUND_HEIGHT:int = 110;
		private static const TEXTFIELD_HEIGHT:int = 35;
		
		private static var __instance:StatsManager;
		private static var __allowInstantiation:Boolean;
		private static var __enableStatsManager:Boolean = false;
		
		private var _stageReference:Stage;
		
		private var _container:Sprite;
		private var _background:Shape;
		private var _diagram:Bitmap;
		private var _diagramData:BitmapData;
		
		private var _textField:TextField;
		private var _styleSheet:StyleSheet;
		private var _xmlText:XML;
		
		private var _colors:Object;
		
		private var _framerate:Number = 0;
		private var _stageFramerate:int = 0;
		private var _usedMemory:Number = 0;
		private var _totalMemory:Number = 0;
		private var _maxMemory:Number = 0;
		
		private var _frames:int = 0;
		private var _ticks:int = 0;
		private var _currentTime:int = 0;
		private var _lastTime:int = 0;
		
		private var _isInit:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function StatsManager() {
			if (!__allowInstantiation) {
				throw new Error("Use static method to instantiate StatsManager");
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  Colors
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupColors():void {
			_colors = new Object();
			
			_colors.background = 0x000000;
			_colors.framerate = 0xFFFF00;
			_colors.usedmemory = 0x00FFFF;
			_colors.maxmemory = 0xFF0070;
		}
		
		//---------------------------------------------------------------------
		//  Container
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupContainer():void {
			_container = new Sprite();
			
			_stageReference.addChild(_container);
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
		
		//---------------------------------------------------------------------
		//  Background
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupBackground():void {
			_background = new Shape();
			
			_container.addChild(_background);
		}
		
		/**
		 * @private
		 */
		private function destroyBackground():void {
			if (_background) {
				_background.graphics.clear();
				
				if (_container.contains(_background)) _container.removeChild(_background);
				
				_background = null;
			}
		}
		
		/**
		 * @private
		 */
		private function drawBackground():void {
			if (_background) {
				_background.graphics.clear();
				_background.graphics.beginFill(_colors.background, 1);
				_background.graphics.drawRect(0, 0, BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
				_background.graphics.endFill();
			}
		}
		
		//---------------------------------------------------------------------
		//  Diagram
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDiagram():void {
			_diagram = new Bitmap(_diagramData, 'auto', true);
			
			_container.addChild(_diagram);
		}
		
		/**
		 * @private
		 */
		private function destroyDiagram():void {
			if (_diagram) {
				if (_container.contains(_diagram)) _container.removeChild(_diagram);
				
				_diagram = null;
			}
		}
		
		/**
		 * @private
		 */
		private function setupDiagramData():void {
			_diagramData = new BitmapData(BACKGROUND_WIDTH, BACKGROUND_HEIGHT - TEXTFIELD_HEIGHT, false, _colors.background); 
		}
		
		/**
		 * @private
		 */
		private function destroyDiagramData():void {
			if (_diagramData) {
				_diagramData.dispose();
				
				_diagramData = null;
			}
		}
		
		/**
		 * @private
		 */
		private function drawDiagramData():void {
			var diagramHeight:int = BACKGROUND_HEIGHT - TEXTFIELD_HEIGHT;
			var time:Number = 1000 / (_currentTime - _lastTime);
            var rate:Number = time > this.stageFramerate ? 1 : time / this.stageFramerate;
			var usedmemory:Number = this.totalMemory / MAX_MEMORY;
			var maxmemory:Number = this.maxMemory * MEMORY / MAX_MEMORY;
			
			if (_diagramData) {
				_diagramData.scroll(1, 0);
				_diagramData.fillRect(new Rectangle(0, 0, 1, _diagramData.height) ,_colors.background);
				_diagramData.setPixel32(0, diagramHeight * (1 - rate), _colors.framerate);
				_diagramData.setPixel32(0, diagramHeight * (1 - usedmemory), _colors.usedmemory);
				_diagramData.setPixel32(0, diagramHeight * (1 - maxmemory), _colors.maxmemory);
			}
		}
		
		//---------------------------------------------------------------------
		//  Text
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStyleSheet():void {
			_styleSheet = new StyleSheet();
			_styleSheet.setStyle('xml', { fontSize:'9px', fontFamily:'_sans', leading:'-2px' } );
			_styleSheet.setStyle('framerate', { color: hexaColorToCSS(_colors.framerate) } );
			_styleSheet.setStyle('usedMemory', { color: hexaColorToCSS(_colors.usedmemory) } );
			_styleSheet.setStyle('maxMemory', { color: hexaColorToCSS(_colors.maxmemory) } );
		}
		
		/**
		 * @private
		 */
		private function destroyStyleSheet():void {
			_styleSheet = null;
			
		}
		
		/**
		 * @private
		 */
		private function setupXML():void {
			_xmlText = <xml><framerate>FPS:</framerate><usedMemory>MEM:</usedMemory><maxMemory>MAX:</maxMemory></xml>;
		}
		
		/**
		 * @private
		 */
		private function destroyXML():void {
			_xmlText = null;
		}
		
		/**
		 * @private
		 */
		private function setupTextField():void {
			_textField = new TextField();
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.mouseWheelEnabled = false;
			_textField.condenseWhite = true;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.width = BACKGROUND_WIDTH - 5;
			_textField.styleSheet = _styleSheet;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.gridFitType = GridFitType.PIXEL;
			
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
		private function moveTextField():void {
			if (_textField) {
				_textField.x = 0;
				_textField.y = BACKGROUND_HEIGHT - TEXTFIELD_HEIGHT + 1;
			}
		}
		
		/**
		 * @private
		 */
		private function setValues():void {
			_xmlText.framerate = 'FPS: ' + this.framerate.toFixed(0) + " / " + this.stageFramerate.toFixed(0);
			_xmlText.usedMemory = 'MEM: ' + this.usedMemory.toFixed(3);
			_xmlText.maxMemory = 'MAX: ' + this.maxMemory.toFixed(3);
			
			if (_textField) _textField.htmlText = _xmlText;
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			_stageReference.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			_stageReference.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleEnterFrame(e:Event):void {
			var delta:int = 0;
			
			_frames++;
			_ticks++;
			_currentTime = getTimer();
			_totalMemory = System.totalMemory;
			_usedMemory = _totalMemory * MEMORY;
			_maxMemory = _maxMemory > _usedMemory ? _maxMemory : _usedMemory;
			_stageFramerate = _stageReference.frameRate;
			
			delta = _currentTime - _lastTime;
			
			if (delta >= 1000) {
				_framerate = _ticks / delta * 1000;
				_ticks = 0;
				_lastTime = _currentTime;
			}
			
			drawDiagramData();
			setValues();
		}
		
		//---------------------------------------------------------------------
		//  Core
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function hexaColorToCSS(color:uint):String {
			return '#' + color.toString(16);
		}
		
		
		/**
		 * Initialize StatsManager
		 */
		public function init():void {
			if (!_stageReference) {
				throw new Error("Can't initialize StatsManager without Stage reference !");
				
				return;
			}
			
			if (!_isInit) {
				_isInit = true;
				
				setupColors();
				setupContainer();
				setupBackground();
				drawBackground();
				setupDiagramData();
				setupDiagram();
				setupXML();
				setupStyleSheet();
				setupTextField();
				moveTextField();
				listenEvents();
			}
		}
		
		/**
		 * Destroy StatsManager.
		 */
		public function destroy():void {
			unlistenEvents();
			destroyXML();
			destroyStyleSheet();
			destroyTextField();
			destroyDiagram();
			destroyDiagramData();
			destroyBackground();
			destroyContainer();
			
			_stageReference = null;
			_isInit = false;
		}
		
		/**
		 * Move StatsManager.
		 * 
		 * @param	pX
		 * @param	pY
		 */
		public function move(pX:int = 0, pY:int = 0):void {
			if (_container) {
				_container.x = pX;
				_container.y = pY;
			}
		}
		
		
		/**
		 * Instantiate StatsManager.
		 */
		public static function getInstance():StatsManager {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new StatsManager();
				__allowInstantiation = false;
			}
			
			return __instance;
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
		public function get frames():int {
			return _frames;
		}
		
		/**
		 * @private
		 */
		public function get framerate():Number {
			return _framerate;
		}
		
		/**
		 * @private
		 */
		public function get stageFramerate():Number {
			return _stageFramerate;
		}
		
		/**
		 * @private
		 */
		public function get usedMemory():Number {
			return _usedMemory;
		}
		
		/**
		 * @private
		 */
		public function get totalMemory():Number {
			return _totalMemory;
		}
		
		/**
		 * @private
		 */
		public function get maxMemory():Number {
			return _maxMemory;
		}
		
		
		/**
		 * @private
		 */
		public static function set enableStatsManager(value:Boolean):void {
			__enableStatsManager = value;
		}
		
		/**
		 * @private
		 */
		public static function get enableStatsManager():Boolean {
			return __enableStatsManager;
		}
	}
}