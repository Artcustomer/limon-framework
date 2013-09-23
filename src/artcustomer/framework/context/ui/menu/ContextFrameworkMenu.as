/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context.ui.menu {
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import artcustomer.framework.Limon;
	import artcustomer.framework.context.BaseContext;
	import artcustomer.framework.base.IDestroyable;
	
	
	/**
	 * ContextFrameworkMenu
	 * 
	 * @author David Massenot
	 */
	public class ContextFrameworkMenu extends Object implements IDestroyable {
		private var _container:DisplayObjectContainer;
		
		private var _contextMenu:ContextMenu;
		
		private var _contextMenuItemTitle:ContextMenuItem;
		private var _contextMenuItemFramework:ContextMenuItem;
		
		private var _urlRequest:URLRequest;
		
		private var _titleCaption:String;
		private var _frameworkCaption:String;
		
		
		/**
		 * Constructor
		 */
		public function ContextFrameworkMenu() {
			
		}
		
		//---------------------------------------------------------------------
		//  ContextMenu
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupContextMenu():void {
			_titleCaption = BaseContext.currentContext.instance.name;
			_frameworkCaption = Limon.CODE + ' ' + Limon.VERSION;
			
			_urlRequest = new URLRequest(Limon.ONLINE_DOCUMENTATION);
			
			_contextMenuItemTitle = new ContextMenuItem(_titleCaption, false, false);
			_contextMenuItemFramework = new ContextMenuItem(_frameworkCaption, false, true);
			_contextMenuItemFramework.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextMenuItem, false, 0, true);
			
			_contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			_contextMenu.customItems.push(_contextMenuItemTitle);
			_contextMenu.customItems.push(_contextMenuItemFramework);
			
			_container.contextMenu = _contextMenu;
		}
		
		/**
		 * @private
		 */
		private function destroyContextMenu():void {
			_contextMenuItemTitle = null;
			_contextMenuItemFramework.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextMenuItem);
			_contextMenuItemFramework = null;
			_urlRequest = null;
			_titleCaption = null;
			_frameworkCaption = null;
			
			if (_contextMenu) {
				_contextMenu = null;
				_container.contextMenu = null;
			}
		}
		
		/**
		 * @private
		 */
		private function handleContextMenuItem(e:ContextMenuEvent):void {
			switch (e.type) {
				case(ContextMenuEvent.MENU_ITEM_SELECT):
					if ((e.target as ContextMenuItem).caption == _frameworkCaption) navigateToURL(_urlRequest, '_blank');
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Setup ContextFrameworkMenu.
		 */
		public function setup():void {
			_container = BaseContext.currentContext.contextView;
			
			setupContextMenu();
		}
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			destroyContextMenu();
			
			_container = null;
		}
	}
}