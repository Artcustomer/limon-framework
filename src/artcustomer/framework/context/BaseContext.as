/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.display.DisplayObjectContainer;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.core.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.utils.consts.*;
	import artcustomer.framework.context.platform.render.*;
	import artcustomer.framework.context.platform.shore.*;
	
	[Event(name = "contextSetup", type = "artcustomer.framework.events.ContextEvent")]
	[Event(name = "contextReset", type = "artcustomer.framework.events.ContextEvent")]
	[Event(name = "contextDestroy", type = "artcustomer.framework.events.ContextEvent")]
	
	
	/**
	 * BaseContext
	 * 
	 * @author David Massenot
	 */
	public class BaseContext extends ServiceContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::BaseContext';
		
		private var _renderEngine:RenderEngine;
		private var _shore:Shore;
		
		private var _isContextSetup:Boolean;
		
		private static var __allowInstantiation:Boolean;
		private static var __currentContext:IContext;
		
		
		/**
		 * Constructor
		 */
		public function BaseContext() {
			_isContextSetup = false;
			__allowInstantiation = true;
			
			super();
			
			if (!__allowInstantiation) throw new IllegalError(IllegalError.E_CONTEXT_INSTANTIATION);
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_BASECONTEXT_CONSTRUCTOR);
			
			__allowInstantiation = false;
		}
		
		//---------------------------------------------------------------------
		//  Stage
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStage():void {
			this.stageReference.scaleMode = StageScaleMode.NO_SCALE;
			this.stageReference.quality = StageQuality.HIGH;
			this.stageReference.align = StageAlign.TOP_LEFT;
		}
		
		//---------------------------------------------------------------------
		//  RenderEngine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupRenderEngine():void {
			if (!_renderEngine) {
				_renderEngine = RenderEngine.getInstance();
				_renderEngine.setup(this.contextView);
				_renderEngine.addEventListener(RenderEngineEvent.ON_RENDER, handleRenderEngine, false, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyRenderEngine():void {
			if (_renderEngine) {
				_renderEngine.removeEventListener(RenderEngineEvent.ON_RENDER, handleRenderEngine);
				_renderEngine.destroy();
				_renderEngine = null;
			}
		}
		
		/**
		 * @private
		 */
		private function handleRenderEngine(e:RenderEngineEvent):void {
			switch (e.type) {
				case(RenderEngineEvent.ON_RENDER):
					this.render();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Shore
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupShore():void {
			_shore = Shore.getInstance();
		}
		
		/**
		 * @private
		 */
		private function destroyShore():void {
			if (_shore) {
				_shore.destroy();
				_shore = null;
			}
		}
		
		/**
		 * Get Debug version of Player.
		 * 
		 * @return
		 */
		public function infos():String {
			var t:String = '';
			
			t += '[[ DEBUG PLAYER ]]';
			t += '\n';
			t += 'Runtime : ' + this.runtime;
			t += '\n';
			t += 'Flash Version : ' + this.flashVersion;
			t += '\n';
			t += 'Framerate : ' + this.framerate;
			t += '\n';
			t += 'Operating system : ' + this.operatingSystem;
			t += '\n';
			t += 'Bits processes supported : ' + this.bitsProcessesSupported;
			t += '\n';
			t += 'CPU : ' + this.cpuArchitecture;
			t += '\n';
			
			return t;
		}
		
		
		/**
		 * Called by RenderEngine during rendering.
		 */
		protected function render():void {
			
		}
		
		
		/**
		 * Setup the context. Must be overrided and called at first.
		 */
		override public function setup():void {
			if (_isContextSetup) throw new FrameworkError(FrameworkError.E_CONTEXT_SETUP_TRUE);
			if (!this.contextView) throw new FrameworkError(FrameworkError.E_CONTEXT_SETUP);
			
			setupStage();
			setupShore();
			setupRenderEngine();
			
			super.setup();
			
			_isContextSetup = true;
			__currentContext = this;
			
			this.instance = this;
			this.dispatchEvent(new ContextEvent(ContextEvent.CONTEXT_SETUP, true, false, this.name, this.contextWidth, this.contextHeight, this.contextView.stage.stageWidth, this.contextView.stage.stageHeight));
		}
		
		/**
		 * Destroy the context. Must be overrided and called at end.
		 */
		override public function destroy():void {
			if (!_isContextSetup) throw new FrameworkError(FrameworkError.E_CONTEXT_SETUP_FALSE);
			if (!this.contextView) throw new FrameworkError(FrameworkError.E_CONTEXT_DESTROY);
			
			destroyRenderEngine();
			destroyShore();
			
			this.dispatchEvent(new ContextEvent(ContextEvent.CONTEXT_DESTROY, true, false, this.name, this.contextWidth, this.contextHeight, this.contextView.stage.stageWidth, this.contextView.stage.stageHeight));
			
			super.destroy();
			
			_isContextSetup = false;
			__allowInstantiation = false;
			__currentContext = null;
		}
		
		/**
		 * Reset the context. Must be overrided.
		 */
		public function reset():void {
			if (!_isContextSetup) throw new FrameworkError(FrameworkError.E_CONTEXT_SETUP_FALSE);
			if (!this.contextView) throw new FrameworkError(FrameworkError.E_CONTEXT_RESET);
			
			this.dispatchEvent(new ContextEvent(ContextEvent.CONTEXT_RESET, true, false, this.name, this.contextWidth, this.contextHeight, this.contextView.stage.stageWidth, this.contextView.stage.stageHeight));
		}
		
		
		/**
		 * Throw an Error.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function throwError(message:* = "", id:* = 0):void {
			throw new Error(message, id);
		}
		
		/**
		 * Throw a custom Error.
		 * 
		 * @param	error
		 * @param	message
		 * @param	id
		 */
		public function throwCustomError(error:Class, message:* = "", id:* = 0):void {
			if (error) throw new error(message, id);
		}
		
		
		/**
		 * @private
		 */
		protected function get isContextSetup():Boolean {
			return _isContextSetup;
		}
		
		/**
		 * @private
		 */
		public function get renderEngine():RenderEngine {
			return _renderEngine;
		}
		
		/**
		 * @private
		 */
		public function get shore():Shore {
			return _shore;
		}
		
		
		/**
		 * Get current Context.
		 * 
		 * @private
		 */
		public static function get currentContext():IContext {
			return __currentContext;
		}
		
		/**
		 * Test if Context is available.
		 * 
		 * @private
		 */
		public static function get allowInstantiation():Boolean {
			return __allowInstantiation;
		}
	}
}