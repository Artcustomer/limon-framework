/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.core {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	
	import artcustomer.framework.context.*;
	import artcustomer.framework.component.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.events.FrameworkModelEvent;
	
	[Event(name = "modelSetup", type = "artcustomer.framework.events.FrameworkModelEvent")]
	[Event(name = "modelReset", type = "artcustomer.framework.events.FrameworkModelEvent")]
	[Event(name = "modelDestroy", type = "artcustomer.framework.events.FrameworkModelEvent")]
	[Event(name = "modelInit", type = "artcustomer.framework.events.FrameworkModelEvent")]
	[Event(name = "modelUpdate", type = "artcustomer.framework.events.FrameworkModelEvent")]
	[Event(name = "modelUpdateAllViews", type = "artcustomer.framework.events.FrameworkModelEvent")]
	[Event(name = "modelUpdateView", type = "artcustomer.framework.events.FrameworkModelEvent")]
	
	
	/**
	 * AbstractModel
	 * 
	 * @author David Massenot
	 */
	public class AbstractModel {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractModel';
		
		private var _component:Component;
		private var _context:IContext;
		
		private var _models:Dictionary;
		
		private var _allowSetComponent:Boolean;
		private var _allowSetContext:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractModel() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_MODEL_CONSTRUCTOR);
			
			_allowSetComponent = true;
			_allowSetContext = true;
		}
		
		//---------------------------------------------------------------------
		//  Macros Stacks
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupModelsStack():void {
			if (!_models) _models = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyModelsStack():void {
			_models = null;
		}
		
		/**
		 * @private
		 */
		private function clearModelsStack():void {
			if (_models) {
				for (var id:String in _models) {
					this.unregisterModel(id);
				}
			}
		}
		
		
		/**
		 * Setup data in model. Must be overrided and called at first in child !
		 */
		public function setup():void {
			setupModelsStack();
			
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_SETUP, true, false, (this as IModel)));
		}
		
		/**
		 * Reset data in model. Can be overrided.
		 */
		public function reset():void {
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_RESET, true, false, (this as IModel)));
		}
		
		/**
		 * Destroy data in model. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			clearModelsStack();
			destroyModelsStack();
			
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_DESTROY, true, false, (this as IModel)));
			
			_component = null;
			_context = null;
			_models = null;
			_allowSetComponent = false;
			_allowSetContext = false;
		}
		
		/**
		 * Initialize data in model. Can be overrided.
		 */
		public function init():void {
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_INIT, true, false, (this as IModel)));
		}
		
		/**
		 * Call this method after update data in order to update Component. Can be overrided.
		 */
		public function update():void {
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_UPDATE, true, false, (this as IModel)));
		}
		
		/**
		 * Call this method after update data in order to update all Views. Can be overrided.
		 */
		public function updateAllViews():void {
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_UPDATE_ALL_VIEWS, true, false, (this as IModel)));
		}
		
		/**
		 * Call this method after update data in order to update a View. Can be overrided.
		 * 
		 * @param	viewID
		 */
		public function updateView(viewID:String):void {
			this.context.instance.dispatchEvent(new FrameworkModelEvent(FrameworkModelEvent.MODEL_UPDATE_VIEW, true, false, (this as IModel), viewID));
		}
		
		/**
		 * Call this method after update data in order to update Component with custom event. Must be overrided.
		 */
		public function updateWithCustomEvent():void {
			
		}
		
		/**
		 * Register MacroModel. Never be overrided.
		 * 
		 * @param	modelClass
		 * @param	modelID
		 */
		public final function registerModel(modelClass:Class, modelID:String):void {
			if (!modelClass || !modelID) throw new FrameworkError(FrameworkError.E_MODEL_REGISTER);
			
			var model:AbstractMacroModel = new modelClass();
			model.model = (this as IModel);
			model.id = modelID;
			model.setup();
			
			_models[modelID] = model;
		}
		
		/**
		 * Unregister MacroModel. Never be overrided.
		 * 
		 * @param	id
		 */
		public final function unregisterModel(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_MODEL_UNREGISTER);
			
			var model:IMacroModel;
			
			try {
				if (_models[id] != undefined) {
					model = (_models[id] as IMacroModel);
					model.destroy();
					model = null;
					
					_models[id] = undefined;
				}
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Has Registered MacroModel. Never be overrided.
		 * 
		 * @param	id
		 * @return
		 */
		public final function hasregisterModel(id:String):Boolean {
			if (!id) throw new FrameworkError(FrameworkError.E_MODEL_HASREGISTER);
			
			if (_models[id] != undefined) return true;
			
			return false;
		}
		
		/**
		 * Get MacroModel. Never be overrided.
		 * 
		 * @param	id
		 * @return
		 */
		public final function getModel(id:String):IMacroModel {
			if (!id) throw new FrameworkError(FrameworkError.E_MODEL_GET);
			
			var model:IMacroModel = null;
			
			if (_models[id] != undefined) model = (_models[id] as IMacroModel);
			
			return model;
		}
		
		
		/**
		 * @private
		 */
		public function set component(value:Component):void {
			if (_allowSetComponent) {
				_component = value;
				
				_allowSetComponent = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get component():Component {
			return _component;
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
	}
}