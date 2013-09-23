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
	import artcustomer.framework.engines.component.*;
	import artcustomer.framework.data.IViewData;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.events.ModelEvent;
	
	[Event(name = "notifyUpdate", type = "artcustomer.framework.events.ModelEvent")]
	
	
	/**
	 * AbstractModel
	 * 
	 * @author David Massenot
	 */
	public class AbstractModel {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.core::AbstractModel';
		
		private var _component:IComponent;
		private var _context:IContext;
		
		private var _models:Dictionary;
		
		private var _numModels:int;
		
		private var _allowSetComponent:Boolean;
		private var _allowSetContext:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function AbstractModel() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_MODEL_CONSTRUCTOR);
			
			_numModels = 0;
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
		}
		
		/**
		 * Reset data in model. Can be overrided.
		 */
		public function reset():void {
			
		}
		
		/**
		 * Destroy data in model. Must be overrided and called at last in child !
		 */
		public function destroy():void {
			clearModelsStack();
			destroyModelsStack();
			
			_numModels = 0;
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
			
		}
		
		/**
		 * Call this method after update data in order to update views in Component. Can be overrided.
		 * 
		 * @param	updateType : Type of the update, a string id.
		 * @param	data : ViewData object that store the data
		 * @param	viewID : Id of the view, if null, all views wiil be updated
		 * @param	isViewSetup : Specified if the views would be setuped before update
		 */
		public function update(updateType:String, data:IViewData, viewID:String = null, isViewSetup:Boolean = true):void {
			_component.dispatchEvent(new ModelEvent(ModelEvent.NOTIFY_UPDATE, false, false, updateType, data, viewID, isViewSetup));
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
			
			_models[modelID] = model;
			_numModels++;
			
			model.setup();
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
					delete _models[id];
					
					_numModels--;
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
			
			return _models[id] as IMacroModel;
		}
		
		
		/**
		 * @private
		 */
		public function set component(value:IComponent):void {
			if (_allowSetComponent) {
				_component = value;
				
				_allowSetComponent = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get component():IComponent {
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
		
		/**
		 * @private
		 */
		public function get numModels():int {
			return _numModels;
		}
	}
}