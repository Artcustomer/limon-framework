/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.context.ui.logo.*;
	import artcustomer.framework.context.ui.menu.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.consts.*;
	
	[Event(name = "displayNormalScreen", type = "artcustomer.framework.events.ContextDisplayEvent")]
	[Event(name = "displayFullScreen", type = "artcustomer.framework.events.ContextDisplayEvent")]
	[Event(name = "error", type = "artcustomer.framework.events.ContextErrorEvent")]
	[Event(name = "frameworkError", type = "artcustomer.framework.events.ContextErrorEvent")]
	[Event(name = "illegalError", type = "artcustomer.framework.events.ContextErrorEvent")]
	
	
	/**
	 * InteractiveContext
	 * 
	 * @author David Massenot
	 */
	public class InteractiveContext extends EventContext implements IContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::InteractiveContext';
		
		private var _contextView:DisplayObjectContainer;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _contextMinWidth:int;
		private var _contextMinHeight:int;
		private var _contextPosition:String;
		private var _scaleToStage:Boolean;
		
		private var _viewPortContainer:Sprite;
		private var _headUpContainer:Sprite;
		
		private var _logo:ContextLogo;
		private var _menu:ContextFrameworkMenu;
		
		private var _contextDisplayState:String;
		
		private var _logoAlign:String;
		private var _logoVerticalMargin:int;
		private var _logoHorizontalMargin:int;
		
		private var _allowSetContextView:Boolean;
		private var _isLogoShow:Boolean;
		private var _isMenuShow:Boolean;
		private var _isFocusOnStage:Boolean;
		private var _isFullScreen:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function InteractiveContext() {
			_allowSetContextView = true;
			
			_contextView = null;
			_contextWidth = ContextDisplaySize.DEFAULT_WIDTH;
			_contextHeight = ContextDisplaySize.DEFAULT_HEIGHT;
			_contextMinWidth = ContextDisplaySize.DEFAULT_MIN_WIDTH;
			_contextMinHeight = ContextDisplaySize.DEFAULT_MIN_HEIGHT;
			_contextDisplayState = ContextDisplayState.NORMAL;
			_contextPosition = ContextPosition.TOP_LEFT;
			_scaleToStage = true;
			_isFullScreen = true;
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_INTERACTIVECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_logoAlign = LogoPosition.TOP_LEFT;
			_logoVerticalMargin = 10;
			_logoHorizontalMargin = 10;
			_isLogoShow = false;
			_isMenuShow = false;
		}
		
		//---------------------------------------------------------------------
		//  LoaderInfo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLoaderInfo():void {
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyLoaderInfo():void {
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError);
		}
		
		//---------------------------------------------------------------------
		//  StageEvents
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenStageEvents():void {
			_contextView.stage.addEventListener(Event.ACTIVATE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.DEACTIVATE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.RESIZE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.FULLSCREEN, handleStage, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenStageEvents():void {
			_contextView.stage.removeEventListener(Event.ACTIVATE, handleStage);
			_contextView.stage.removeEventListener(Event.DEACTIVATE, handleStage);
			_contextView.stage.removeEventListener(Event.RESIZE, handleStage);
			_contextView.stage.removeEventListener(Event.FULLSCREEN, handleStage);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStage(e:Event):void {
			if (!_contextView) return;
			
			var stageWidth:int = _contextView.stage.stageWidth;
			var stageHeight:int = _contextView.stage.stageHeight;
			var contextWidth:int = Math.max(_contextMinWidth, stageWidth);
			var contextHeight:int = Math.max(_contextMinHeight, stageHeight);
			
			e.preventDefault();
			
			switch (e.type) {
				case(Event.ACTIVATE):
					if (!_isFocusOnStage) {
						_isFocusOnStage = true;
						
						this.focus();
					}
					break;
					
				case(Event.DEACTIVATE):
					if (_isFocusOnStage) {
						_isFocusOnStage = false;
						
						this.unfocus();
					}
					break;
					
				case(Event.RESIZE):
					setupSize(contextWidth, contextHeight);
					refreshView();
					setLogoPosition();
					
					this.resize();
					break;
					
				case(Event.FULLSCREEN):
					if (_contextView.stage.displayState == StageDisplayState.NORMAL) {
						_contextDisplayState = ContextDisplayState.NORMAL;
						
						this.dispatchEvent(new ContextDisplayEvent(ContextDisplayEvent.DISPLAY_NORMAL_SCREEN, false, false, contextWidth, contextHeight, stageWidth, stageHeight, _contextDisplayState));
					} else if (_contextView.stage.displayState == StageDisplayState.FULL_SCREEN) {
						_contextDisplayState = ContextDisplayState.FULL_SCREEN;
						
						this.dispatchEvent(new ContextDisplayEvent(ContextDisplayEvent.DISPLAY_FULL_SCREEN, false, false, contextWidth, contextHeight, stageWidth, stageHeight, _contextDisplayState));
					}
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleUncaughtError(e:UncaughtErrorEvent):void {
			e.preventDefault();
			
			var error:Error = e.error as Error;
			var errorID:int = error.errorID;
			var errorName:String = ErrorName.FLASH_ERROR;
			var frameworkError:int = errorID / FrameworkError.ERROR_ID;
			var illegalError:int = errorID / IllegalError.ERROR_ID;
			var eventType:String = ContextErrorEvent.ERROR;
			
			if (frameworkError == 1) {
				eventType = ContextErrorEvent.FRAMEWORK_ERROR;
				errorName = ErrorName.FRAMEWORK_ERROR;
			}
			
			if (illegalError == 1) {
				eventType = ContextErrorEvent.ILLEGAL_ERROR;
				errorName = ErrorName.ILLEGAL_ERROR;
			}
			
			this.dispatchEvent(new ContextErrorEvent(eventType, true, false, error, errorName))
		}
		
		//---------------------------------------------------------------------
		//  ViewPortContainer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPortContainer():void {
			_viewPortContainer = new Sprite();
			
			_contextView.addChild(_viewPortContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyViewPortContainer():void {
			if (_viewPortContainer) {
				_contextView.removeChild(_viewPortContainer);
				
				_viewPortContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  HeadUpContainer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupHeadUpContainer():void {
			_headUpContainer = new Sprite();
			
			_contextView.addChild(_headUpContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyHeadUpContainer():void {
			if (_headUpContainer) {
				_contextView.removeChild(_headUpContainer);
				
				_headUpContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Logo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLogo():void {
			if (!_logo) {
				_logo = new ContextLogo();
				_logo.setup();
				
				if (_headUpContainer && _logo.bitmap) _headUpContainer.addChild(_logo.bitmap);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyLogo():void {
			if (_logo) {
				if (_headUpContainer && _logo.bitmap) _headUpContainer.removeChild(_logo.bitmap);
				
				_logo.destroy();
				_logo = null;
			}
		}
		
		/**
		 * @private
		 */
		private function setLogoPosition():void {
			if (_logo) {
				if (_logoAlign == LogoPosition.TOP_LEFT || _logoAlign == LogoPosition.LEFT || _logoAlign == LogoPosition.BOTTOM_LEFT) _logo.x = _logoHorizontalMargin;
				if (_logoAlign == LogoPosition.TOP || _logoAlign == LogoPosition.BOTTOM) _logo.x = (_contextWidth - _logo.width) >> 1;
				if (_logoAlign == LogoPosition.TOP_RIGHT || _logoAlign == LogoPosition.RIGHT || _logoAlign == LogoPosition.BOTTOM_RIGHT) _logo.x = _contextWidth - _logoHorizontalMargin - _logo.width;
				if (_logoAlign == LogoPosition.TOP_LEFT || _logoAlign == LogoPosition.TOP || _logoAlign == LogoPosition.TOP_RIGHT) _logo.y = _logoVerticalMargin;
				if (_logoAlign == LogoPosition.LEFT || _logoAlign == LogoPosition.RIGHT) _logo.y = (_contextHeight - _logo.height) >> 1;
				if (_logoAlign == LogoPosition.BOTTOM_LEFT || _logoAlign == LogoPosition.BOTTOM || _logoAlign == LogoPosition.BOTTOM_RIGHT) _logo.y = _contextHeight - _logoVerticalMargin - _logo.height;
			}
		}
		
		//---------------------------------------------------------------------
		//  Menu
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMenu():void {
			if (!_menu) {
				_menu = new ContextFrameworkMenu();
				_menu.setup();
			}
		}
		
		/**
		 * @private
		 */
		private function destroyMenu():void {
			if (_menu) {
				_menu.destroy();
				_menu = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Size
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function initSize():void {
			if (_scaleToStage) {
				if (_contextView) {
					_contextWidth = _contextView.stage.stageWidth;
					_contextHeight = _contextView.stage.stageHeight;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function setupSize(width:int, height:int):void {
			if (_scaleToStage) {
				if (_contextView) {
					_contextWidth = width;
					_contextHeight = height;
				}
			}
		}
		
		/**
		 * When player window is resized.
		 */
		protected function resize():void {
			
		}
		
		/**
		 * When FlashPlayer receive focus. Can be overrided.
		 */
		protected function focus():void {
			
		}
		
		/**
		 * When FlashPlayer lose focus. Can be overrided.
		 */
		protected function unfocus():void {
			
		}
		
		
		/**
		 * Setup InteractiveContext.
		 */
		override public function setup():void {
			init();
			
			super.setup();
			
			listenStageEvents();
			setupLoaderInfo();
			setupViewPortContainer();
			setupHeadUpContainer();
			initSize();
			refreshView();
			showLogo();
		}
		
		/**
		 * Destroy InteractiveContext.
		 */
		override public function destroy():void {
			unlistenStageEvents();
			hideLogo();
			destroyViewPortContainer();
			destroyHeadUpContainer();
			destroyLoaderInfo();
			
			_contextView = null;
			_contextWidth = 0;
			_contextHeight = 0;
			_contextMinWidth = 0;
			_contextMinHeight = 0;
			_contextDisplayState = null;
			_contextPosition = null;
			_scaleToStage = false;
			_viewPortContainer = null;
			_logoAlign = null;
			_logoVerticalMargin = 0;
			_logoHorizontalMargin = 0;
			_allowSetContextView = false;
			_isLogoShow = false;
			_isMenuShow = false;
			_isFocusOnStage = false;
			
			super.destroy();
		}
		
		/**
		 * Move the context view.
		 * 
		 * @param	x
		 * @param	y
		 */
		public function move(x:int = 0, y:int = 0):void {
			if (_contextView) {
				_contextView.x = x;
				_contextView.y = y;
			}
		}
		
		/**
		 * Refresh the context view.
		 */
		public function refreshView():void {
			var xPos:int = 0;
			var yPos:int = 0;
			
			switch (_contextPosition) {
				case(ContextPosition.CENTER):
					xPos = (_contextView.stage.stageWidth - _contextWidth) >> 1;
					yPos = (_contextView.stage.stageHeight - _contextHeight) >> 1;
					break;
					
				case(ContextPosition.TOP_LEFT):
					xPos = 0;
					yPos = 0;
					break;
					
				case(ContextPosition.TOP_RIGHT):
					xPos = _contextView.stage.stageWidth - _contextWidth;
					yPos = 0;
					break;
					
				case(ContextPosition.BOTTOM_LEFT):
					xPos = 0;
					yPos = _contextView.stage.stageHeight - _contextHeight;
					break;
					
				case(ContextPosition.BOTTOM_RIGHT):
					xPos = _contextView.stage.stageWidth - _contextWidth;
					yPos = _contextView.stage.stageHeight - _contextHeight;
					break;
					
				default:
					xPos = 0;
					yPos = 0;
					break;
			}
			
			if (!_scaleToStage) move(xPos, yPos);
		}
		
		/**
		 * Show Framework logo.
		 */
		public function showLogo():void {
			if (!_isLogoShow) {
				setupLogo();
				setLogoPosition();
				
				_isLogoShow = true;
			}
		}
		
		/**
		 * Hide Framework logo.
		 */
		public function hideLogo():void {
			if (_isLogoShow) {
				destroyLogo();
				
				_isLogoShow = false;
			}
		}
		
		/**
		 * Show Framework context menu.
		 */
		public function showMenu():void {
			if (!_isMenuShow) {
				setupMenu();
				
				_isMenuShow = true;
			}
		}
		
		/**
		 * Hide Framework context menu.
		 */
		public function hideMenu():void {
			if (_isMenuShow) {
				destroyMenu();
				
				_isMenuShow = false;
			}
		}
		
		/**
		 * Move Framework logo.
		 * 
		 * @param	align : Use consts of LogoPosition
		 * @param	verticalMargin
		 * @param	horizontalMargin
		 */
		public function moveLogo(align:String, verticalMargin:int = 0, horizontalMargin:int = 0):void {
			if (_isLogoShow) {
				_logoAlign = align;
				_logoVerticalMargin = verticalMargin;
				_logoHorizontalMargin = horizontalMargin;
				
				setLogoPosition();
			}
		}
		
		/**
		 * Switch Normal / FullScreen mode
		 */
		public function toggleFullScreen():void {
			if (_isFullScreen) {
				_isFullScreen = false;
				
				this.stageReference.displayState = StageDisplayState.NORMAL;
			} else {
				_isFullScreen = true;
				
				this.stageReference.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		
		
		/**
		 * @private
		 */
		public function set contextView(value:DisplayObjectContainer):void {
			if (_allowSetContextView) {
				_contextView = value;
				
				_allowSetContextView = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get contextView():DisplayObjectContainer {
			return _contextView;
		}
		
		/**
		 * @private
		 */
		public function set contextWidth(value:int):void {
			_contextWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get contextWidth():int {
			return _contextWidth;
		}
		
		/**
		 * @private
		 */
		public function set contextHeight(value:int):void {
			_contextHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get contextHeight():int {
			return _contextHeight;
		}
		
		/**
		 * @private
		 */
		public function set contextMinWidth(value:int):void {
			_contextMinWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get contextMinWidth():int {
			return _contextMinWidth;
		}
		
		/**
		 * @private
		 */
		public function set contextMinHeight(value:int):void {
			_contextMinHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get contextMinHeight():int {
			return _contextMinHeight;
		}
		
		/**
		 * @private
		 */
		public function set contextPosition(value:String):void {
			_contextPosition = value;
		}
		
		/**
		 * @private
		 */
		public function get contextPosition():String {
			return _contextPosition;
		}
		
		/**
		 * @private
		 */
		public function set scaleToStage(value:Boolean):void {
			_scaleToStage = value;
		}
		
		/**
		 * @private
		 */
		public function get scaleToStage():Boolean {
			return _scaleToStage;
		}
		
		/**
		 * @private
		 */
		public function get contextDisplayState():String {
			return _contextDisplayState;
		}
		
		/**
		 * @private
		 */
		public function get stageReference():Stage {
			return _contextView.stage;
		}
		
		/**
		 * @private
		 */
		public function get viewPortContainer():Sprite {
			return _viewPortContainer;
		}
		
		/**
		 * @private
		 */
		public function get headUpContainer():Sprite {
			return _headUpContainer;
		}
		
		/**
		 * @private
		 */
		public function get isFocusOnStage():Boolean {
			return _isFocusOnStage;
		}
		
		/**
		 * @private
		 */
		public function get isFullScreen():Boolean {
			return _isFullScreen;
		}
	}
}