/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.process.states {
	import flash.utils.Dictionary;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.process.states.state.State;
	
	
	/**
	 * StateMachine
	 * 
	 * @author David Massenot
	 */
	public class StateMachine implements IDestroyable {
		private var _states:Dictionary;
		private var _currentState:State;
		
		private var _numStates:int;
		
		
		/**
		 * Constructor
		 */
		public function StateMachine() {
			setupStates();
		}
		
		//---------------------------------------------------------------------
		//  States
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStates():void {
			_states = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyStates():void {
			_states = null;
		}
		
		/**
		 * @private
		 */
		private function disposeStates():void {
			var id:String;
			
			for (id in _states) {
				disposeState(id);
			}
		}
		
		/**
		 * @private
		 */
		private function createState(id:String, entry:Function, exit:Function):State {
			return new State(id, entry, exit);
		}
		
		/**
		 * @private
		 */
		private function disposeState(id:String):void {
			(_states[id] as State).destroy();
			_states[id] = undefined;
			delete _states[id];
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			disposeStates();
			destroyStates();
			
			_currentState = null;
			_numStates = 0;
		}
		
		/**
		 * Add State in machine.
		 * 
		 * @param	id
		 * @param	entry
		 * @param	exit
		 * @return
		 */
		public final function addState(id:String, entry:Function, exit:Function):Boolean {
			if (!_states[id]) {
				_states[id] = createState(id, entry, exit);
				_numStates++;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Remove State from machine.
		 * 
		 * @param	id
		 * @return
		 */
		public final function removeState(id:String):Boolean {
			if (_states[id]) {
				disposeState(id);
				
				_numStates--;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Test if State exist in machine.
		 * 
		 * @param	id
		 * @return
		 */
		public final function hasState(id:String):Boolean {
			return _states[id] != null;
		}
		
		/**
		 * Set State in machine.
		 * 
		 * @param	id
		 * @return
		 */
		public final function setState(id:String):Boolean {
			var state:State = _states[id] as State;
			
			if (!state || state == _currentState) return false;
			if (_currentState) _currentState.exit();
			
			_currentState = state;
			_currentState.entry();
			
			return true;
		}
		
		
		/**
		 * @private
		 */
		public function get numStates():int {
			return _numStates;
		}
		
		/**
		 * @private
		 */
		public function get currentState():State {
			return _currentState;
		}
	}
}