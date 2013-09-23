/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context{
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.system.Security;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.consts.*;
	
	
	/**
	 * ServiceContext
	 * 
	 * @author David Massenot
	 */
	public class ServiceContext extends CrossPlatformInputsContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::ServiceContext';
		
		private var _name:String;
		private var _mode:String;
		private var _assetsPath:String;
		
		private var _runtime:String;
		private var _flashVersion:String;
		private var _operatingSystem:String;
		private var _bitsProcessesSupported:String;
		private var _cpuArchitecture:String;
		private var _defaultLanguage:String;
		private var _framerate:Number;
		private var _parameters:Object;
		
		private var _isPlayerPaused:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function ServiceContext() {
			_runtime = RuntimePlatform.FLASH_PLAYER;
			_flashVersion = Capabilities.version;
			_operatingSystem = Capabilities.os;
			_bitsProcessesSupported = BitProcesses.UNKNOWN_SUPPORT;
			_cpuArchitecture = Capabilities.cpuArchitecture;
			_defaultLanguage = Capabilities.language;
			_parameters = new Object();
			_name = ContextName.DEFAULT_NAME;
			_mode = ContextMode.RELEASE;
			_assetsPath = '';
			
			if (Capabilities.supports32BitProcesses) _bitsProcessesSupported = BitProcesses.SUPPORT_32_BIT;
			if (Capabilities.supports64BitProcesses) _bitsProcessesSupported = BitProcesses.SUPPORT_64_BIT;
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_SERVICECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Parameters
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupParameters():void {
			if (this.contextView.loaderInfo) _parameters = this.contextView.loaderInfo.parameters;
		}
		
		
		/**
		 * Setup ServiceContext.
		 */
		override public function setup():void {
			super.setup();
			
			setupParameters();
		}
		
		/**
		 * Destroy ServiceContext.
		 */
		override public function destroy():void {
			_name = null;
			_mode = null;
			_assetsPath = null;
			_flashVersion = null;
			_operatingSystem = null;
			_cpuArchitecture = null;
			_defaultLanguage = null
			_framerate = 0;
			_parameters = null;
			_isPlayerPaused = false;
			
			super.destroy();
		}
		
		/**
		 * Get Flash parameter by name.
		 * 
		 * @param	name
		 * @return
		 */
		public function getParameter(name:String):Object {
			if (!_parameters) return null;
			
			return _parameters[name];
		}
		
		/**
		 * Get properties and values of Flash parameters in String format.
		 * 
		 * @return
		 */
		public function dumpParameters():String {
			if (!_parameters) return '';
			
			var dump:String = '';
			var parameter:Object = null;
			var value:Object = null;
			
			for (var o:* in _parameters) {
				parameter = o;
				value = _parameters[o];
				
				dump += '{' + String(parameter) + ' : ' + String(value) + '}\n';
			}
			
			return dump;
		}
		
		/**
		 * Force the garbage collection process.
		 */
		public function releaseMemory():void {
			System.gc();
		}
		
		/**
		 * Exit Flash Player.
		 * 
		 * @param	code : A value to pass to the operating system.
		 */
		public function exitPlayer(code:uint = 0):void {
			System.exit(code);
		}
		
		/**
		 * Pause Flash Player
		 */
		public function pausePlayer():void {
			if (!_isPlayerPaused) {
				_isPlayerPaused = true;
				
				System.pause();
			}
		}
		
		/**
		 * Resume Flash Player
		 */
		public function resumePlayer():void {
			if (_isPlayerPaused) {
				_isPlayerPaused = false;
				
				System.resume();
			}
		}
		
		/**
		 * Allow a domain in application.
		 * 
		 * @param	rest
		 */
		public function allowDomain(...rest):void {
			if (rest && rest.length != 0) Security.allowDomain(rest);
		}
		
		/**
		 * Allow an insecure domain in application.
		 * 
		 * @param	rest
		 */
		public function allowInsecureDomain(...rest):void {
			if (rest && rest.length != 0) Security.allowInsecureDomain(rest);
		}
		
		/**
		 * Load policy file (XML Crossdomain).
		 * 
		 * @param	url
		 */
		public function loadPolicyFile(url:String):void {
			if (url) Security.loadPolicyFile(url);
		}
		
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set mode(value:String):void {
			_mode = value;
		}
		
		/**
		 * @private
		 */
		public function get mode():String {
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function set assetsPath(value:String):void {
			_assetsPath = value;
		}
		
		/**
		 * @private
		 */
		public function get assetsPath():String {
			return _assetsPath;
		}
		
		/**
		 * @private
		 */
		public function get applicationDomain():ApplicationDomain {
			return this.contextView.loaderInfo.applicationDomain;
		}
		
		/**
		 * @private
		 */
		public function get runtime():String {
			return _runtime;
		}
		
		/**
		 * @private
		 */
		public function get flashVersion():String {
			return _flashVersion;
		}
		
		/**
		 * @private
		 */
		public function get operatingSystem():String {
			return _operatingSystem;
		}
		
		/**
		 * @private
		 */
		public function get bitsProcessesSupported():String {
			return _bitsProcessesSupported;
		}
		
		/**
		 * @private
		 */
		public function get cpuArchitecture():String {
			return _cpuArchitecture;
		}
		
		/**
		 * @private
		 */
		public function get defaultLanguage():String {
			return _defaultLanguage;
		}
		
		/**
		 * @private
		 */
		public function get framerate():Number {
			_framerate = this.stageReference.frameRate;
			
			return _framerate;
		}
		
		/**
		 * @private
		 */
		public function get parameters():Object {
			return _parameters;
		}
		
		/**
		 * @private
		 */
		public function get isPlayerPaused():Boolean {
			return _isPlayerPaused;
		}
	}
}