/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.render.RenderEngine;
	
	
	/**
	 * FrameworkRenderEvent
	 * 
	 * @author David Massenot
	 */
	public class FrameworkRenderEvent extends Event {
		public static const ON_RENDER:String = 'onRender';
		public static const START_RENDER:String = 'startRender';
		public static const STOP_RENDER:String = 'stopRender';
		public static const HEARTBEAT:String = 'heartBeat';
		
		private var _engine:RenderEngine;
		private var _fps:Number;
		private var _memory:Number;
		private var _freeMemory:Number;
		private var _privateMemory:Number;
		private var _totalMemory:Number;
		
		
		public function FrameworkRenderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, engine:RenderEngine = null, fps:Number = 0, memory:Number = 0, freeMemory:Number = 0, privateMemory:Number = 0, totalMemory:Number = 0) {
			_engine = engine;
			_fps = fps;
			_memory = memory;
			_freeMemory = freeMemory;
			_privateMemory = privateMemory;
			_totalMemory = totalMemory;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone FrameworkRenderEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new FrameworkRenderEvent(type, bubbles, cancelable, this.engine, this.fps, this.memory, this.freeMemory, this.privateMemory, this.totalMemory);
		}
		
		/**
		 * Get String value of FrameworkRenderEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("FrameworkRenderEvent", "type", "bubbles", "cancelable", "eventPhase", "engine", "fps", "memory", "freeMemory", "privateMemory", "totalMemory"); 
		}
		
		
		/**
		 * @private
		 */
		public function get engine():RenderEngine {
			return _engine;
		}
		
		/**
		 * @private
		 */
		public function get fps():Number {
			return _fps;
		}
		
		/**
		 * @private
		 */
		public function get memory():Number {
			return _memory;
		}
		
		/**
		 * @private
		 */
		public function get freeMemory():Number {
			return _freeMemory;
		}
		
		/**
		 * @private
		 */
		public function get privateMemory():Number {
			return _privateMemory;
		}
		
		/**
		 * @private
		 */
		public function get totalMemory():Number {
			return _totalMemory;
		}
	}
}