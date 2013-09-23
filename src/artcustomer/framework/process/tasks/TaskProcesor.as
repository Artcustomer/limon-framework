/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.process.tasks {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.errors.IllegalError;
	import artcustomer.framework.process.tasks.events.*;
	import artcustomer.framework.process.tasks.task.AbstractTask;
	
	[Event(name = "onStartProcesing", type = "artcustomer.framework.tasks.events.TaskProcesorEvent")]
	[Event(name = "onProgressProcesing", type = "artcustomer.framework.tasks.events.TaskProcesorEvent")]
	[Event(name = "onEndProcesing", type = "artcustomer.framework.tasks.events.TaskProcesorEvent")]
	[Event(name = "onErrorProcesing", type = "artcustomer.framework.tasks.events.TaskProcesorEvent")]
	
	
	/**
	 * TaskProcesor
	 * 
	 * @author David Massenot
	 */
	public class TaskProcesor extends EventDispatcher implements IDestroyable {
		private var _stack:Vector.<AbstractTask>;
		
		private var _currentTaskIndex:int;
		private var _numTasks:int;
		
		private var _currentTask:AbstractTask;
		
		private var _isProcesing:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function TaskProcesor() {
			createStack();
			
			_currentTaskIndex = 0;
			_numTasks = 0;
			_isProcesing = false;
		}
		
		//---------------------------------------------------------------------
		//  Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createStack():void {
			_stack = new Vector.<AbstractTask>();
		}
		
		/**
		 * @private
		 */
		private function disposeStack():void {
			while (_stack.length > 0) {
				_stack.shift().destroy();
			}
		}
		
		/**
		 * @private
		 */
		private function destroyStack():void {
			_stack = null;
		}
		
		//---------------------------------------------------------------------
		//  Tasks
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function startCurrentTask():void {
			_currentTask = _stack[_currentTaskIndex];
			_currentTask.addEventListener(TaskEvent.ON_START_TASK, handleCurrentTask, false, 0, true);
			_currentTask.addEventListener(TaskEvent.ON_END_TASK, handleCurrentTask, false, 0, true);
			_currentTask.addEventListener(TaskEvent.ON_ERROR_TASK, handleCurrentTask, false, 0, true);
			_currentTask.start();
		}
		
		/**
		 * @private
		 */
		private function stopCurrentTask():void {
			if (_currentTask) _currentTask.stop();
		}
		
		/**
		 * @private
		 */
		private function releaseCurrentTask():void {
			if (_currentTask) {
				_currentTask.removeEventListener(TaskEvent.ON_START_TASK, handleCurrentTask);
				_currentTask.removeEventListener(TaskEvent.ON_END_TASK, handleCurrentTask);
				_currentTask.removeEventListener(TaskEvent.ON_ERROR_TASK, handleCurrentTask);
			}
		}
		
		/**
		 * @private
		 */
		private function checkTaskCount():void {
			if (_currentTaskIndex < _numTasks - 1) {
				_currentTaskIndex++;
				
				releaseCurrentTask();
				startCurrentTask();
				
				this.dispatchEvent(new TaskProcesorEvent(TaskProcesorEvent.ON_PROGRESS_PROCESING, false, false, _numTasks, _currentTaskIndex));
			} else {
				releaseCurrentTask();
				
				this.dispatchEvent(new TaskProcesorEvent(TaskProcesorEvent.ON_END_PROCESING, false, false, _numTasks, _currentTaskIndex));
			}
		}
		
		/**
		 * @private
		 */
		private function handleCurrentTask(e:TaskEvent):void {
			switch (e.type) {
				case(TaskEvent.ON_START_TASK):
					break;
					
				case(TaskEvent.ON_END_TASK):
					if (_isProcesing) checkTaskCount();
					break;
					
				case(TaskEvent.ON_ERROR_TASK):
					this.dispatchEvent(new TaskProcesorEvent(TaskProcesorEvent.ON_ERROR_PROCESING, false, false, _numTasks, e.index, e.error));
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Add Task in stack.
		 * 
		 * @param	taskClass : Must extends AbstractTask !
		 */
		public function addTask(taskClass:Class):void {
			if (!taskClass) throw new IllegalError(IllegalError.E_TASK_ADD);
			
			var task:AbstractTask;
			
			try {
				task = new taskClass();
				task.index = _stack.length;
				
				_stack.push(task);
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Get Task at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function getTaskAt(index:int):AbstractTask {
			var task:AbstractTask;
			
			if (index >= 0 && index < _numTasks) {
				task = _stack[index];
			}
			
			return task;
		}
		
		/**
		 * Test stack at index.
		 * 
		 * @param	index
		 * @return
		 */
		public function hasTaskAt(index:int):Boolean {
			if (index >= 0 && index < _numTasks) return true;
			
			return false;
		}
		
		/**
		 * Start procesing.
		 */
		public function startProcesing():void {
			if (_stack.length == 0) {
				throw new IllegalError(IllegalError.E_TASKPROCESOR_EMPTY);
				
				return;
			}
			
			if (!_isProcesing) {
				_isProcesing = true;
				
				_currentTaskIndex = 0;
				_numTasks = _stack.length;
				
				this.dispatchEvent(new TaskProcesorEvent(TaskProcesorEvent.ON_START_PROCESING, false, false, _numTasks, _currentTaskIndex));
				
				startCurrentTask();
			}
		}
		
		/**
		 * Stop procesing.
		 */
		public function stopProcesing():void {
			if (_isProcesing) {
				_isProcesing = false;
				
				stopCurrentTask();
				releaseCurrentTask();
			}
		}
		
		/**
		 * Dispose procesor. Clear task's stack.
		 */
		public function dispose():void {
			if (!_isProcesing) {
				disposeStack();
				
				_currentTaskIndex = 0;
				_numTasks = 0;
			}
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeStack();
			destroyStack();
			
			_currentTaskIndex = 0;
			_numTasks = 0;
			_currentTask = null;
			_isProcesing = false;
		}
		
		
		/**
		 * @private
		 */
		public function get numTasks():int {
			return _numTasks;
		}
	}
}