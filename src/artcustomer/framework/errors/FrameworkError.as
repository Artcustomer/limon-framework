/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.errors {
	
	
	/**
	 * FrameworkError
	 * 
	 * @author David Massenot
	 */
	public class FrameworkError extends Error {
		public static const ERROR_ID:int = 10000;
		
		public static const E_CONTEXT_SETUP_FALSE:String = "Call setup method first !";
		public static const E_CONTEXT_SETUP_TRUE:String = "Context is already Setup !";
		public static const E_CONTEXT_SETUP:String = "Root Container isn't defined to setup Context !";
		public static const E_CONTEXT_RESET:String = "Root Container isn't defined to reset Context !";
		public static const E_CONTEXT_DESTROY:String = "Root Container isn't defined to destroy Context !";
		
		public static const E_DISPLAYCONTAINER_SETUP:String = "Component is required to setup DisplayContainer !";
		public static const E_DISPLAYCONTAINER_DESTROY:String = "Component is required to destroy DisplayContainer !";
		
		public static const E_COMPONENT_ADD:String = "Can't add Component with null param !";
		public static const E_COMPONENT_REMOVE:String = "Can't remove Component without ID !";
		public static const E_COMPONENT_GET:String = "Can't get Component without ID !";
		public static const E_COMPONENT_HAS:String = "Can't test Component without ID !";
		
		public static const E_STARLINGCOMPONENT_ADD:String = "Can't add StarlingComponent with null param !";
		public static const E_STARLINGCOMPONENT_REMOVE:String = "Can't remove StarlingComponent without ID !";
		public static const E_STARLINGCOMPONENT_GET:String = "Can't get StarlingComponent without ID !";
		public static const E_STARLINGCOMPONENT_HAS:String = "Can't test StarlingComponent without ID !";
		
		public static const E_MANAGER_ADD:String = "Can't add Manager with null param !";
		public static const E_MANAGER_REMOVE:String = "Can't remove Manager without ID !";
		public static const E_MANAGER_GET:String = "Can't get Manager without ID !";
		
		public static const E_LAYER3D_ADD:String = "Can't add Layer3D with null param !";
		public static const E_LAYER3D_REMOVE:String = "Can't remove Layer3D ! Index is out of the range !";
		public static const E_LAYER3D_GET:String = "Can't get Layer3D ! Index is out of range !";
		public static const E_LAYER3D_OVERFLOW:String = "Layer3D overflow ! Limit of layers is reached !";
		public static const E_LAYER3D_ATTACH_TEMPLATE:String = "Can't attach EngineTemplate without valid class !";
		public static const E_LAYER3D_PARSE_DRIVER:String = "Error while parsing DriverInfo, make sur you have FlashPlayer 11.4 !";
		
		public static const E_LAYERVIDEO_ADD:String = "Can't add LayerVideo with null param !";
		public static const E_LAYERVIDEO_REMOVE:String = "Can't remove LayerVideo ! Index is out of range !";
		public static const E_LAYERVIDEO_GET:String = "Can't get LayerVideo ! Index is out of range !";
		public static const E_LAYERVIDEO_OVERFLOW:String = "LayerVideo overflow ! Limit of layers is reached !";
		
		public static const E_SCENE3D_ADD:String = "Can't add AbstractScene3D with null param !";
		public static const E_SCENE3D_REMOVE:String = "Can't remove AbstractScene3D ! Index is out of the range !";
		public static const E_SCENE3D_GET:String = "Can't get AbstractScene3D ! Index is out of range !";
		
		public static const E_COMMAND_EXECUTEMACRO:String = "Can't execute macro without ID !";
		
		public static const E_MACRO_REGISTER:String = "Can't register macro with null params !";
		public static const E_MACRO_UNREGISTER:String = "Can't unregister macro without id !";
		public static const E_MACRO_HASREGISTER:String = "Can't test macro without id !";
		public static const E_MACRO_GET:String = "Can't get macro without id !";
		
		public static const E_MODEL_REGISTER:String = "Can't register model with null params !";
		public static const E_MODEL_UNREGISTER:String = "Can't unregister model without id !";
		public static const E_MODEL_HASREGISTER:String = "Can't test model without id !";
		public static const E_MODEL_GET:String = "Can't get model without id !";
		
		public static const E_VIEW_REGISTER:String = "Can't register view with null param !";
		public static const E_VIEW_UNREGISTER:String = "Can't unregister view without view !";
		public static const E_VIEW_ADD:String = "Can't add view without id !";
		public static const E_VIEW_REMOVE:String = "Can't add view without id !";
		public static const E_VIEW_SETUP:String = "Can't setup view without id !";
		public static const E_VIEW_RESET:String = "Can't reset view without id !";
		public static const E_VIEW_GET:String = "Can't get view without id !";
		public static const E_VIEW_HAS:String = "Can't test view without id !";
		public static const E_VIEW_GET_OUT_OF_RANGE:String = "Index is out of range !";
		public static const E_VIEW_ALREADY_EXIST:String = "View already exist with this id : ";
		
		public static const E_RENDERENGINE_CREATE:String = "RenderEngine is singleton ! Use static method to get it !";
		
		public static const E_ASSETS_PATH_DONT_EXIST:String = "Can't resolve assets path !";
		
		
		/**
		 * Throw a FrameworkError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function FrameworkError(message:String = "", id:int = 0) {
			super(message, ERROR_ID + id);
		}
	}
}