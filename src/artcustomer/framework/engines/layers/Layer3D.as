/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.layers {
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.context.IContext;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.engines.layers.data.Driver3DInfo;
	import artcustomer.framework.engines.layers.tools.scene.AbstractScene3D;
	import artcustomer.framework.engines.layers.tools.template.AbstractEngineTemplate;
	import artcustomer.framework.utils.consts.LayerErrorType;
	
	[Event(name = "layer3dSetup", type = "artcustomer.framework.events.Layer3DEvent")]
	[Event(name = "layer3dDestroy", type = "artcustomer.framework.events.Layer3DEvent")]
	[Event(name = "layer3dError", type = "artcustomer.framework.events.Layer3DEvent")]
	[Event(name = "layer3dCreate", type = "artcustomer.framework.events.Layer3DEvent")]
	
	
	/**
	 * Layer3D : Stage3D Layer
	 * 
	 * @author David Massenot
	 */
	public class Layer3D extends Object implements ILayer {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.layers::Layer3D';
		
		private var _context:IContext;
		private var _id:String;
		private var _index:int;
		
		private var _scenes:Dictionary;
		private var _numScenes:int;
		private var _stackID:int;
		
		private var _template:AbstractEngineTemplate;
		
		private var _driver3DInfo:Driver3DInfo;
		
		private var _viewPort:Sprite;
		private var _stage:Stage;
		private var _stage3D:Stage3D;
		private var _context3D:Context3D;
		
		private var _enableErrorChecking:Boolean;
		private var _isSoftwareMode:Boolean;
		private var _driverInfo:String;
		
		private var _allowSetID:Boolean;
		private var _isCreate:Boolean;
		private var _autoResize:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function Layer3D() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_LAYER3D_CONSTRUCTOR);
			
			_allowSetID = true;
		}
		
		//---------------------------------------------------------------------
		//  ViewPort
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPort():void {
			_viewPort = new Sprite();
			
			_context.instance.viewPortContainer.addChild(_viewPort);
		}
		
		/**
		 * @private
		 */
		private function destroyViewPort():void {
			if (_viewPort) {
				_context.instance.viewPortContainer.removeChild(_viewPort);
				
				_viewPort = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Stage3D
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStage3D():Boolean {
			_stage3D = _context.instance.stageReference.stage3Ds[_index];
			
			if (_stage3D) {
				_stage3D.addEventListener(Event.CONTEXT3D_CREATE, handleStage3D, false, 0, true);
				_stage3D.addEventListener(ErrorEvent.ERROR, handleErrorStage3D, false, 0, true);
				_stage3D.requestContext3D();
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		private function destroyStage3D():void {
			if (_stage3D) {
				_stage3D.removeEventListener(ErrorEvent.ERROR, handleErrorStage3D);
				
				_stage3D = null;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStage3D(e:Event):void {
			switch (e.type) {
				case(Event.CONTEXT3D_CREATE):
					_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, handleStage3D);
					_context3D = _stage3D.context3D;
					
					if (_context3D) {
						setupContext3D();
						
						_driverInfo = _context3D.driverInfo;
						
						if ((_driverInfo == Context3DRenderMode.SOFTWARE) || (_driverInfo.indexOf('oftware') > -1)) {
							_isSoftwareMode = true;
							
							_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_ERROR, false, false, _index, LayerErrorType.SOFTWARE_MODE_DETECTED));
						}
						
						_isCreate = true;
						
						setupDriver3DInfo();
						
						this.create();
						
						_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_CREATE, false, false, _index));
					} else {
						_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_ERROR, false, false, _index, LayerErrorType.CONTEXT3D_UNDEFINED));
					}
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleErrorStage3D(e:ErrorEvent):void {
			switch (e.type) {
				case('error'):
					_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_ERROR, false, false, _index, e.text));
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Context3D
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupContext3D():void {
			if (_context3D) _context3D.configureBackBuffer(this.context.contextWidth, this.context.contextHeight, 0, false);
		}
		
		/**
		 * @private
		 */
		private function resizeContext3D():void {
			if (_autoResize && _context3D) _context3D.configureBackBuffer(this.context.contextWidth, this.context.contextHeight, 0, false);
		}
		
		/**
		 * @private
		 */
		private function clearContext3D():void {
			if (_context3D) _context3D.clear();
		}
		
		/**
		 * @private
		 */
		private function destroyContext3D():void {
			if (_context3D) {
				_context3D.dispose();
				_context3D = null;
			}
		}
		
		
		//---------------------------------------------------------------------
		//  Template
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function renderTemplate():void {
			if (_template) _template.render();
		}
		
		/**
		 * @private
		 */
		private function resizeTemplate():void {
			if (_template) _template.resize();
		}
		
		//---------------------------------------------------------------------
		//  Scene3Ds Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupScene3DStack():void {
			if (!_scenes) _scenes = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyScene3DStack():void {
			if (_scenes) _scenes = null;
		}
		
		/**
		 * @private
		 */
		private function disposeScene3DStack():void {
			if (!_scenes) return;
			
			var id:String;
			var scene3d:AbstractScene3D;
			
			for (id in _scenes) {
				scene3d = _scenes[id] as AbstractScene3D;
				
				this.removeScene(scene3d);
			}
		}
		
		/**
		 * @private
		 */
		private function reorderScene3DStack():void {
			if (!_scenes) return;
			
			var i:int;
			var id:String;
			var scene:AbstractScene3D;
			
			for (id in _scenes) {
				scene = _scenes[id];
				
				if (scene) {
					scene.index = i;
					
					i++;
				}
			}
		}
		
		//---------------------------------------------------------------------
		//  Scene3D
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function renderAllScenes():void {
			if (!_scenes) return;
			
			var id:String;
			var scene3d:AbstractScene3D;
			
			for (id in _scenes) {
				scene3d = this._scenes[id] as AbstractScene3D;
				
				if (scene3d) scene3d.render();
			}
		}
		
		//---------------------------------------------------------------------
		//  Driver3DInfo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDriver3DInfo():void {
			_driver3DInfo = new Driver3DInfo(_driverInfo);
		}
		
		/**
		 * @private
		 */
		private function destroyDriver3DInfo():void {
			if (_driver3DInfo) {
				_driver3DInfo.destroy();
				
				_driver3DInfo = null;
			}
		}
		
		
		/**
		 * Setup Layer3D. Must be overrided and called at first in child.
		 */
		public function setup():void {
			if (setupStage3D()) {
				_isCreate = false;
				_autoResize = true;
				_stage = _context.instance.stageReference;
				
				setupViewPort();
				setupScene3DStack();
				
				_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_SETUP, false, false, _index));
			} else {
				_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_ERROR, false, false, _index, LayerErrorType.STAGE3D_UNDEFINED));
			}
		}
		
		/**
		 * Destroy Layer3D. Must be overrided and call at last in child.
		 */
		public function destroy():void {
			destroyStage3D();
			destroyContext3D();
			destroyViewPort();
			disposeScene3DStack();
			destroyScene3DStack();
			destroyDriver3DInfo();
			
			this.removeTemplate();
			
			_context.instance.dispatchEvent(new Layer3DEvent(Layer3DEvent.LAYER3D_DESTROY, false, false, _index));
			
			_context = null;
			_id = null;
			_index = 0;
			_viewPort = null;
			_stage = null;
			_scenes = null;
			_numScenes = 0;
			_stackID = 0;
			_enableErrorChecking = false;
			_isSoftwareMode = false;
			_isSoftwareMode = false;
			_driverInfo = null;
			_allowSetID = false;
			_isCreate = false;
			_autoResize = false;
		}
		
		/**
		 * Called when player window is resized. Don't call it !
		 */
		public final function onResize():void {
			resizeContext3D();
			resizeTemplate();
			resize();
		}
		
		/**
		 * Called when RenderEngine is on. Don't call it !
		 */
		public final function onRender():void {
			clearContext3D();
			renderTemplate();
			renderAllScenes();
			render();
		}
		
		/**
		 * Update Layer3D. Must be overrided and call at last in child.
		 */
		public function update():void {
			
		}
		
		/**
		 * Attach an engine template to layer.
		 * 
		 * @param	templateClass
		 */
		public final function attachTemplate(templateClass:Class):void {
			if (!templateClass) throw new FrameworkError(FrameworkError.E_LAYER3D_ATTACH_TEMPLATE);
			
			if (_template) {
				_template.destroy();
				_template = null;
			}
			
			_template = new templateClass();
			_template.layer3D = this;
			_template.setup();
		}
		
		/**
		 * Get template.
		 * 
		 * @return
		 */
		public final function getTemplate():AbstractEngineTemplate {
			return _template;
		}
		
		/**
		 * Remove template if attached.
		 */
		public final function removeTemplate():void {
			if (_template) {
				_template.destroy();
				_template = null;
			}
		}
		
		/**
		 * Add new AbstractScene3D.
		 * 
		 * @param	sceneClass : Class of the instance of AbstractScene3D.
		 * @return ths instance created.
		 */
		public final function addScene(sceneClass:Class):AbstractScene3D {
			if (!sceneClass) throw new FrameworkError(FrameworkError.E_SCENE3D_ADD);
			
			var scene3d:AbstractScene3D = null;
			
			try {
				scene3d = new sceneClass();
				scene3d.layer3D = this;
				scene3d.id = _stackID.toString();
				scene3d.index = _numScenes;
				
				scene3d.setup();
				
				_scenes[scene3d.id] = scene3d;
				
				_numScenes++;
				_stackID++;
			} catch (er:Error) {
				throw er;
			}
			
			return scene3d;
		}
		
		/**
		 * Remove instance of AbstractScene3D at index.
		 * 
		 * @param	index : Index of the AbstractScene3D in order to find it in the stack
		 */
		public final function removeSceneAt(index:int):void {
			if (index < 0 || index >= _numScenes) throw new FrameworkError(FrameworkError.E_SCENE3D_REMOVE);
			
			var scene3d:AbstractScene3D = this.getSceneAt(index);
			
			try {
				this.removeScene(scene3d);
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Remove instance of AbstractScene3D
		 * 
		 * @param	scene3d : Instance of AbstractScene3D
		 */
		public final function removeScene(scene3d:AbstractScene3D):void {
			if (!scene3d) return;
			
			var id:String = scene3d.id;
			
			scene3d.destroy();
			scene3d = null;
			
			_scenes[id] = undefined;
			
			_numScenes--;
			
			if (_numScenes > 0) reorderScene3DStack();
		}
		
		/**
		 * Get AbstractScene3D at index
		 * 
		 * @param	index : Index of the AbstractScene3D in order to find it in the stack
		 * @return	the AbstractScene3D corresponding to the index or null if index ins't exist in the stack
		 */
		public final function getSceneAt(index:int):AbstractScene3D {
			if (!index < 0 || index >= _numScenes) throw new FrameworkError(FrameworkError.E_SCENE3D_GET);
			
			var id:String;
			var scene3d:AbstractScene3D;
			
			for (id in _scenes) {
				scene3d = _scenes[id] as AbstractScene3D;
				
				if (scene3d && scene3d.index == index) return scene3d;
			}
			
			return null;
		}
		
		/**
		 * Test if Scene3D exist in the stack
		 * 
		 * @param	index : Index of the AbstractScene3D in order to find it in the stack
		 * @return	True if Scene3D exist, False is not exist
		 */
		public final function hasSceneAt(index:int):Boolean {
			if (!index < 0 || index >= _numScenes) return false;
			if (this.getSceneAt(index)) return true;
			
			return false;
		}
		
		/**
		 * Called when Context3D is created. Override it !
		 */
		protected function create():void {
			
		}
		
		/**
		 * Called when RenderEngine is on. Override it !
		 */
		protected function render():void {
			
		}
		
		/**
		 * Called when Stage is resized. Override it !
		 */
		protected function resize():void {
			
		}
		
		
		/**
		 * @private
		 */
		public function set context(value:IContext):void {
			_context = value;
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
		public function get viewPort():Sprite {
			return _viewPort;
		}
		
		/**
		 * @private
		 */
		public function get stage():Stage {
			return _stage;
		}
		
		/**
		 * @private
		 */
		public function get stage3D():Stage3D {
			return _stage3D;
		}
		
		/**
		 * @private
		 */
		public function get context3D():Context3D {
			return _context3D;
		}
		
		/**
		 * @private
		 */
		public function set enableErrorChecking(value:Boolean):void {
			if (_stage3D) {
				_stage3D.context3D.enableErrorChecking = value;
			} else {
				value = false;
			}
			
			_enableErrorChecking = value;
		}
		
		/**
		 * @private
		 */
		public function get enableErrorChecking():Boolean {
			return _enableErrorChecking;
		}
		
		/**
		 * @private
		 */
		public function set autoResize(value:Boolean):void {
			_autoResize = value;
		}
		
		/**
		 * @private
		 */
		public function get autoResize():Boolean {
			return _autoResize;
		}
		
		/**
		 * @private
		 */
		public function get scenes():Dictionary {
			return _scenes;
		}
		
		/**
		 * @private
		 */
		public function get numScenes():int {
			return _numScenes;
		}
		
		/**
		 * @private
		 */
		public function get driver3DInfo():Driver3DInfo {
			return _driver3DInfo;
		}
		
		/**
		 * @private
		 */
		public function get isSoftwareMode():Boolean {
			return _isSoftwareMode;
		}
		
		/**
		 * @private
		 */
		public function get isCreate():Boolean {
			return _isCreate;
		}
	}
}