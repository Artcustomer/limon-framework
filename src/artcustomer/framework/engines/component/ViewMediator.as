/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.component {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.core.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.data.IViewData;
	import artcustomer.framework.events.ModelEvent;
	
	
	/**
	 * ViewMediator
	 * 
	 * @author David Massenot
	 */
	public class ViewMediator extends CommandBroadcaster implements IComponent {
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
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			this.addEventListener(ModelEvent.NOTIFY_UPDATE, handleModel, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			this.removeEventListener(ModelEvent.NOTIFY_UPDATE, handleModel);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleModel(e:ModelEvent):void {
			switch (e.type) {
				case(ModelEvent.NOTIFY_UPDATE):
					if (e.viewID) {
						this.updateView(e.viewID, e.isViewSetup, e.updateType, e.data);
					} else {
						this.updateAllViews(e.isViewSetup, e.updateType, e.data);
					}
					break;
					
				default:
					break;
			}
			
			e.stopPropagation();
			e.preventDefault();
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
			var view:IView;
			
			for (id in _views) {
				view = this.getViewByID(id);
				if (view && view.isSetup) view.resize();
			}
		}
		
		
		/**
		 * Update all Views.
		 * 
		 * @param	isViewSetup
		 * @param	updateType
		 * @param	data
		 */
		protected function updateAllViews(isViewSetup:Boolean, updateType:String, data:IViewData):void {
			if (this.numViews == 0) return;
			
			var i:int = 0;
			var length:int = this.numViews;
			var view:IView;
			
			for (i = 0 ; i < length ; i++) {
				view = this.getViewByIndex(i);
				
				if (view) {
					if (isViewSetup) {
						if (view.isSetup) view.update(updateType, data);
					} else {
						view.update(updateType, data);
					}
				}
			}
		}
		
		/**
		 * Update View in Component.
		 * 
		 * @param	viewID
		 * @param	isViewSetup
		 * @param	updateType
		 * @param	data
		 */
		protected function updateView(viewID:String, isViewSetup:Boolean, updateType:String, data:IViewData):void {
			if (!viewID || this.numViews == 0) return;
			
			var view:IView = this.getViewByID(viewID);
			
			if (view) {
				if (isViewSetup) {
					if (view.isSetup) view.update(updateType, data);
				} else {
					view.update(updateType, data);
				}
			}
		}
		
		/**
		 * Called by Mediator when a view is registered. Override it !
		 * Inject Object Parent here !
		 * 
		 * @param	view
		 */
		protected function onViewRegistered(view:IView):void {
			
		}
		
		/**
		 * Build Mediator.
		 */
		override public function build():void {
			listenEvents();
			setupViewStack();
			
			super.build();
		}
		
		/**
		 * Called when Context is resized . Don't call it !
		 */
		public final function contextResize():void {
			resizeViews();
		}
		
		/**
		 * Destroy Mediator.
		 */
		override public function destroy():void {
			disposeViewStack();
			destroyViewStack();
			unlistenEvents();
			
			_views = null;
			_numViews = 0;
			
			super.destroy();
		}
		
		/**
		 * Register View
		 * 
		 * @param	view : IView
		 * @param	id : ID of the View
		 * @param	setup : Auto Setup View
		 */
		public final function registerView(view:Class, id:String, setup:Boolean = false, add:Boolean = false):void {
			if (!view || !id) throw new FrameworkError(FrameworkError.E_VIEW_REGISTER);
			if (hasViewByID(id)) throw new FrameworkError(FrameworkError.E_VIEW_ALREADY_EXIST + id);
			
			var objectView:IView = new view();
			
			try {
				objectView.id = id;
				objectView.index = _numViews;
				objectView.component = this;
				
				_views[id] = objectView;
				_numViews++;
				
				onViewRegistered(objectView);
				
				if (setup) objectView.setup();
				if (add) objectView.add();
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
			
			try {
				if (_views[id] != undefined) {
					(_views[id] as IView).destroy();
					
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
				var view:IView = this.getViewByID(id);
				
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
				var view:IView = this.getViewByID(id);
				
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
				var view:IView = this.getViewByID(id);
				
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
		public final function getViewByID(id:String):IView {
			if (!id) throw new FrameworkError(FrameworkError.E_VIEW_GET);
			
			var view:IView = null;
			
			if (_views[id] != undefined) view = (_views[id] as IView);
			
			return view;
		}
		
		/**
		 * Get View by index.
		 * 
		 * @param	index
		 * @return
		 */
		public final function getViewByIndex(index:int):IView {
			if (index < 0 || index >= _numViews) throw new FrameworkError(FrameworkError.E_VIEW_GET_OUT_OF_RANGE);
			
			var view:IView = null;
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
			
			var view:IView = null;
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
		 * @param	view1	The index position of the first IView.
		 * @param	view2	The index position of the second IView.
		 */
		public function swapViews(view1:IView, view2:IView):void {
			if (!view1 || !view2) return;
			
			var index1:int = view1.index;
			var index2:int = view2.index;
			
			view1.index = index2;
			view2.index = index1;
		}
		
		
		/**
		 * @private
		 */
		public function get numViews():int {
			return _numViews;
		}
	}
}