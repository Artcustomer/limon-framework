/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.component {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.context.*;
	import artcustomer.framework.core.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	
	[Event(name = "componentBuild", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentInit", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentDestroy", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentAdd", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentRemove", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	
	
	/**
	 * Component
	 * 
	 * @author David Massenot
	 */
	public class Component extends ViewMediator {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.component::Component';
		
		private var _id:String;
		private var _index:int;
		private var _context:IContext;
		private var _model:IModel;
		private var _command:ICommand;
		
		private var _viewPort:Sprite;
		
		private var _isActivate:Boolean;
		
		private var _allowSetID:Boolean;
		private var _allowSetContext:Boolean;
		private var _allowSetModel:Boolean;
		private var _allowSetCommand:Boolean;
		
		
		/**
		 * Constructor : Create a Component.
		 * 
		 * @param	id
		 * @param	context
		 * @param	model
		 * @param	command
		 */
		public function Component(id:String, context:IContext = null, model:IModel = null, command:ICommand = null) {
			_allowSetID = true;
			_allowSetContext = true;
			_allowSetModel = true;
			_allowSetCommand = true;
			
			if (id) this.id = id;
			if (context) this.context = context;
			if (model) this.model = model;
			if (command) this.command = command;
			
			this.component = this;
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_COMPONENT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  ViewPort
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPort():void {
			_viewPort = new Sprite();
		}
		
		/**
		 * @private
		 */
		private function destroyViewPort():void {
			if (_viewPort) _viewPort = null;
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			if (_context) {
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_SETUP, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_RESET, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_DESTROY, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_INIT, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_UPDATE, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_UPDATE_ALL_VIEWS, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkModelEvent.MODEL_UPDATE_VIEW, handleFrameworkModel, false, 0, true);
				_context.instance.addEventListener(FrameworkCommandEvent.SEND_COMMAND, handleCommands, false, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			if (_context) {
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_SETUP, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_RESET, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_DESTROY, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_INIT, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_UPDATE, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_UPDATE_ALL_VIEWS, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkModelEvent.MODEL_UPDATE_VIEW, handleFrameworkModel);
				_context.instance.removeEventListener(FrameworkCommandEvent.SEND_COMMAND, handleCommands);
			}
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleFrameworkModel(e:FrameworkModelEvent):void {
			if (e.model != this.model) return;
			
			switch (e.type) {	
				case('modelInit'):
					
					break;
					
				case('modelUpdate'):
					update();
					break;
					
				case('modelUpdateAllViews'):
					updateAllViews();
					break;
					
				case('modelUpdateView'):
					updateView(e.viewID);
					break;
					
				default:
					break;
			}
			
			e.stopPropagation();
			e.preventDefault();
		}
		
		/**
		 * @private
		 */
		private function handleCommands(e:FrameworkCommandEvent):void {
			if (e.component != this) return;
			
			switch (e.type) {
				case('sendCommand'):
					this.command.execute(e);
					break;
					
				default:
					break;
			}
			
			e.stopPropagation();
			e.preventDefault();
		}
		
		//---------------------------------------------------------------------
		//  Model
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupModel():void {
			if (_model) _model.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyModel():void {
			if (_model) {
				_model.destroy();
				_model = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Command
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupCommand():void {
			if (_command) _command.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyCommand():void {
			if (_command) {
				_command.destroy();
				_command = null;
			}
		}
		
		/**
		 * Update Component.
		 */
		protected function update():void {
			
		}
		
		/**
		 * Update all Views.
		 */
		protected function updateAllViews():void {
			if (this.numViews == 0) return;
			
			var i:int = 0;
			var length:int = this.numViews;
			var view:AbstractView;
			
			for (i = 0 ; i < length ; i++) {
				view = this.getViewByIndex(i);
				if (view) view.update();
			}
		}
		
		/**
		 * Update View in Component.
		 * 
		 * @param	viewID
		 */
		protected function updateView(viewID:String):void {
			if (!viewID || this.numViews == 0) return;
			
			var view:AbstractView = this.getViewByID(viewID);
			
			if (view) view.update();
		}
		
		
		/**
		 * Entry point of the Component. Must be overrided and called at first in child.
		 */
		override public function build():void {
			listenEvents();
			setupViewPort();
			setupModel();
			setupCommand();
			
			super.build();
			
			this.dispatchEvent(new FrameworkComponentEvent(FrameworkComponentEvent.COMPONENT_BUILD, false, false, this));
		}
		
		/**
		 * Init Component. Must be overrided and called at last in child.
		 */
		override public function init():void {
			super.init();
			
			this.context.instance.dispatchEvent(new FrameworkComponentEvent(FrameworkComponentEvent.COMPONENT_INIT, false, false, this));
		}
		
		/**
		 * Destroy Component. Must be overrided and called at last in child.
		 */
		override public function destroy():void {
			remove();
			destroyCommand();
			destroyModel();
			destroyViewPort();
			unlistenEvents();
			
			this.dispatchEvent(new FrameworkComponentEvent(FrameworkComponentEvent.COMPONENT_DESTROY, false, false, this));
			
			super.destroy();
			
			_id = null;
			_index = 0;
			_context = null;
			_model = null;
			_command = null;
			_viewPort = null;
			_isActivate = false;
			_allowSetID = false;
			_allowSetContext = false;
			_allowSetModel = false;
			_allowSetCommand = false;
		}
		
		/**
		 * Add Viewport on ContextView.
		 */
		public function add():void {
			if (!_context.instance.viewPortContainer.contains(_viewPort)) {
				_context.instance.viewPortContainer.addChild(_viewPort);
				
				this.context.instance.dispatchEvent(new FrameworkComponentEvent(FrameworkComponentEvent.COMPONENT_ADD, false, false, this));
			}
		}
		
		/**
		 * Remove Viewport from ContextView.
		 */
		public function remove():void {
			if (_context.instance.viewPortContainer.contains(_viewPort)) {
				_context.instance.viewPortContainer.removeChild(_viewPort);
				
				this.context.instance.dispatchEvent(new FrameworkComponentEvent(FrameworkComponentEvent.COMPONENT_REMOVE, false, false, this));
			}
		}
		
		/**
		 * Activate Component, useful for adding event listeners here. Must be overrided and called at first.
		 */
		public function activate():void {
			if (!_isActivate) {
				_isActivate = true;
			} else {
				return;
			}
		}
		
		/**
		 * Deactivate Component, useful for removed event listeners here. Must be overrided and called at first.
		 */
		public function deactivate():void {
			if (_isActivate) {
				_isActivate = false;
			} else {
				return;
			}
		}
		
		/**
		 * Map an Event. Useful for Component events, can be called before build.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public final function mapEvent(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			this.context.instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Unmap an Event. Useful for Component events, can be called before build.
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public final function unMapEvent(type:String, listener:Function, useCapture:Boolean = false):void {
			this.context.instance.removeEventListener(type, listener, useCapture)
		}
		
		/**
		 * Broadcast an event. Useful for Component events, can be called before build.
		 * 
		 * @param	e
		 * @return
		 */
		public final function broadcastEvent(e:Event):Boolean {
 		    if (this.context.instance.hasEventListener(e.type)) return this.context.instance.dispatchEvent(e);
			
 		 	return false;
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
		
		/**
		 * @private
		 */
		public function set index(value:int):void {
			_index = value;
		}
		
		/**
		 * @private
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * @private
		 */
		public function set context(value:IContext):void {
			if (_allowSetContext) {
				_context = value;
				
				_allowSetContext = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get context():IContext {
			return _context;
		}
		
		/**
		 * @private
		 */
		public function set model(value:IModel):void {
			if (_allowSetModel) {
				_model = value;
				
				_allowSetModel = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get model():IModel {
			return _model;
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
		public function get viewPort():Sprite {
			return _viewPort;
		}
		
		/**
		 * @private
		 */
		public function get isActivate():Boolean {
			return _isActivate;
		}
	}
}