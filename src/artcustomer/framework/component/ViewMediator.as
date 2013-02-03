/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.component {
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.core.*;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * ViewMediator
	 * 
	 * @author David Massenot
	 */
	public class ViewMediator extends EventBroadcaster {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.component::ViewMediator';
		
		private var _views:Dictionary;
		
		private var _numViews:int;
		
		
		/**
		 * Constructor
		 */
		public function ViewMediator() {
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_VIEWMEDIATOR_CONSTRUCTOR);
			
			_numViews = 0;
		}
		
		//---------------------------------------------------------------------
		//  ViewStack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewStack():void {
			_views = new Dictionary(true);
		}
		
		/**
		 * @private
		 */
		private function destroyViewStack():void {
			if (_views) _views = null;
		}
		
		/**
		 * @private
		 */
		private function disposeViewStack():void {
			unregisterAllViews();
		}
		
		/**
		 * @private
		 */
		private function resizeViews():void {
			if (!_views) return;
			
			var id:String;
			var view:AbstractView;
			
			for (id in _views) {
				view = this.getViewByID(id);
				if (view && view.isSetup) view.resize();
			}
		}
		
		
		/**
		 * Build Mediator.
		 */
		override public function build():void {
			setupViewStack();
			
			super.build();
		}
		
		/**
		 * Init Mediator.
		 */
		public function init():void {
			
		}
		
		/**
		 * Called when Context isresized . Don't call it !
		 */
		public final function contextResize():void {
			resizeViews();
			
			this.resize();
		}
		
		/**
		 * Resize Mediator.
		 */
		public function resize():void {
			
		}
		
		/**
		 * Destroy Mediator.
		 */
		override public function destroy():void {
			disposeViewStack();
			destroyViewStack();
			
			_views = null;
			_numViews = 0;
			
			super.destroy();
		}
		
		/**
		 * Register View
		 * 
		 * @param	view : AbstractView
		 * @param	id : ID of the View
		 * @param	setup : Auto Setup View
		 */
		public final function registerView(view:Class, id:String, setup:Boolean = false, add:Boolean = false):void {
			if (!view || !id) throw new FrameworkError(FrameworkError.E_VIEW_REGISTER);
			
			var subview:AbstractView = new view();
			
			try {
				subview.id = id;
				subview.index = _numViews;
				subview.component = this.component;
				subview.objectParent = this.component.viewPort;
				
				_views[id] = subview;
				
				_numViews++;
				
				if (setup) subview.setup();
				if (add) subview.add();
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Unregister View.
		 * 
		 * @param	view
		 */
		public final function unregisterView(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_UNREGISTER);
			
			var view:AbstractView = getViewByID(id);
			
			try {
				if (_views[id] != undefined) {
					view = (_views[id] as AbstractView);
					view.remove();
					view.destroy();
					view = null;
					
					_views[id] = undefined;
					delete _views[id];
					
					_numViews--;
				}
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Add registered View.
		 * 
		 * @param	view
		 */
		public final function addRegisteredView(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_ADD);
			
			try {
				var view:AbstractView = this.getViewByID(id);
				
				if (view) view.add();
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Setup registered View.
		 * 
		 * @param	view
		 */
		public final function setupRegisteredView(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_SETUP);
			
			try {
				var view:AbstractView = this.getViewByID(id);
				
				if (view) view.setup();
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Reset registered View.
		 * 
		 * @param	view
		 */
		public final function resetRegisteredView(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_RESET);
			
			try {
				var view:AbstractView = this.getViewByID(id);
				
				if (view) view.reset();
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Get View by ID.
		 * 
		 * @param	id
		 * @return
		 */
		public final function getViewByID(id:String):AbstractView {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_GET);
			
			var view:AbstractView = null;
			
			if (_views[id] != undefined) view = (_views[id] as AbstractView);
			
			return view;
		}
		
		/**
		 * Get View by index.
		 * 
		 * @param	index
		 * @return
		 */
		public final function getViewByIndex(index:int):AbstractView {
			if (index < 0 || index >= _numViews) throw new FrameworkError(FrameworkError.E_VIEW_GET_OUT_OF_RANGE);
			
			var view:AbstractView = null;
			var id:String;
			
			for (id in _views) {
				view = getViewByID(id);
				
				if (view && view.index == index) break;
			}
			
			return view;
		}
		
		/**
		 * Test if View exists by ID.
		 * 
		 * @param	id : ID of the View.
		 * @return
		 */
		public final function hasViewByID(id:String):Boolean {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_HAS);
			
			return _views[id] != undefined;
		}
		
		/**
		 * Test if View exists by index.
		 * 
		 * @param	index : Index of the View.
		 * @return
		 */
		public final function hasViewByIndex(index:int):Boolean {
			if (index < 0 || index >= _numViews) throw new FrameworkError(FrameworkError.E_VIEW_GET_OUT_OF_RANGE);
			
			var view:AbstractView = null;
			var id:String;
			
			for (id in _views) {
				view = getViewByID(id);
				
				if (view && view.index == index) break;
			}
			
			return view != null;
		}
		
		/**
		 * Unregister all Views.
		 */
		public final function unregisterAllViews():void {
			if (!_views) return;
			
			var id:String;
			
			for (id in _views) {
				this.unregisterView(id);
			}
		}
		
		/**
		 * Swap Views (z-order in stack).
		 * 
		 * @param	view1	The index position of the first AbstractView.
		 * @param	view2	The index position of the second AbstractView.
		 */
		public final function swapViews(view1:AbstractView, view2:AbstractView):void {
			if (!view1 || !view2) return;
			
			var index1:int = view1.index;
			var index2:int = view2.index;
			
			view1.index = index2;
			view2.index = index1;
			
			view1.objectParent.swapChildren(view1.viewContainer, view2.viewContainer);
		}
		
		
		/**
		 * @private
		 */
		public function get views():Dictionary {
			return _views;
		}
		
		/**
		 * @private
		 */
		public function get numViews():int {
			return _numViews;
		}
	}
}