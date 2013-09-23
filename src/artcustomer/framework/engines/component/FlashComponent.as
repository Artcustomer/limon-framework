/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.component {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.core.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	
	
	/**
	 * FlashComponent
	 * 
	 * @author David Massenot
	 */
	public class FlashComponent extends ViewMediator {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.component::FlashComponent';
		
		private var _viewPort:Sprite;
		
		
		/**
		 * Constructor : Create a FlashComponent (called by FlashContext)
		 */
		public function FlashComponent() {
			super();
			
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
		
		
		/**
		 * Called by Mediator when a view is registered.
		 * 
		 * @param	view
		 */
		override protected function onViewRegistered(view:IView):void {
			(view as AbstractFlashView).objectParent = _viewPort;
		}
		
		
		/**
		 * Entry point of the Component. Must be overrided and called at first in child.
		 */
		override public function build():void {
			setupViewPort();
			
			super.build();
		}
		
		/**
		 * Destroy Component. Must be overrided and called at last in child.
		 */
		override public function destroy():void {
			remove();
			destroyViewPort();
			
			super.destroy();
		}
		
		/**
		 * Add Viewport on ContextView.
		 */
		public function add():void {
			if (!this.context.instance.viewPortContainer.contains(_viewPort)) this.context.instance.viewPortContainer.addChild(_viewPort);
		}
		
		/**
		 * Remove Viewport from ContextView.
		 */
		public function remove():void {
			if (this.context.instance.viewPortContainer.contains(_viewPort)) this.context.instance.viewPortContainer.removeChild(_viewPort);
		}
		
		/**
		 * Swap Views (z-order in stack).
		 * 
		 * @param	view1	The index position of the first IView.
		 * @param	view2	The index position of the second IView.
		 */
		override public function swapViews(view1:IView, view2:IView):void {
			super.swapViews(view1, view2);
			
			_viewPort.swapChildren((view1 as AbstractFlashView).viewContainer, (view1 as AbstractFlashView).viewContainer);
		}
		
		
		/**
		 * @private
		 */
		public function get viewPort():Sprite {
			return _viewPort;
		}
	}
}