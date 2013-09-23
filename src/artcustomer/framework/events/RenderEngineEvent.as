/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	
	/**
	 * RenderEngineEvent
	 * 
	 * @author David Massenot
	 */
	public class RenderEngineEvent extends Event {
		public static const ON_RENDER:String = 'onRender';
		public static const START_RENDER:String = 'startRender';
		public static const STOP_RENDER:String = 'stopRender';
		public static const HEARTBEAT:String = 'heartBeat';
		
		private var _fps:Number;
		private var _memory:Number;
		private var _freeMemory:Number;
		private var _privateMemory:Number;
		private var _totalMemory:Number;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	fps
		 * @param	memory
		 * @param	freeMemory
		 * @param	privateMemory
		 * @param	totalMemory
		 */
		public function RenderEngineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, fps:Number = 0, memory:Number = 0, freeMemory:Number = 0, privateMemory:Number = 0, totalMemory:Number = 0) {
			_fps = fps;
			_memory = memory;
			_freeMemory = freeMemory;
			_privateMemory = privateMemory;
			_totalMemory = totalMemory;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone RenderEngineEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new RenderEngineEvent(type, bubbles, cancelable, _fps, _memory, _freeMemory, _privateMemory, _totalMemory);
		}
		
		/**
		 * Get String value of RenderEngineEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("RenderEngineEvent", "type", "bubbles", "cancelable", "eventPhase", "fps", "memory", "freeMemory", "privateMemory", "totalMemory"); 
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