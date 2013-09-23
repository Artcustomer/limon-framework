/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.errors {
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * IllegalError
	 * 
	 * @author David Massenot
	 */
	public class IllegalError extends IllegalOperationError {
		public static const ERROR_ID:int = 20000;
		
		public static const E_ABSTRACT_CLASS:String = "Abstract class ! Don't instantiate it directly !";
		public static const E_SINGLETON_CLASS:String = "Singleton ! Use static method !";
		
		public static const E_CONTEXT_INSTANTIATION:String = "Context is already instantiated !";
		public static const E_CONTEXT_CONSTRUCTOR:String = "Context is an abstract class ! Don't instantiate it directly !";
		public static const E_BASECONTEXT_CONSTRUCTOR:String = "BaseContext is an abstract class ! Don't instantiate it directly !";
		public static const E_SERVICECONTEXT_CONSTRUCTOR:String = "ServiceContext is an abstract class ! Don't instantiate it directly !";
		public static const E_CROSSPLATFORMINPUTSCONTEXT_CONSTRUCTOR:String = "CrossPlatformInputsContext is an abstract class ! Don't instantiate it directly !";
		public static const E_INTERACTIVECONTEXT_CONSTRUCTOR:String = "InteractiveContext is an abstract class ! Don't instantiate it directly !";
		public static const E_EVENTCONTEXT_CONSTRUCTOR:String = "EventContext is an abstract class ! Don't instantiate it directly !";
		
		public static const E_COMPONENT_CONSTRUCTOR:String = "Component is an abstract class ! Don't instantiate it directly !";
		public static const E_VIEWMEDIATOR_CONSTRUCTOR:String = "ViewMediator is an abstract class ! Don't instantiate it directly !";
		public static const E_COMMANDBORADCASTER_CONSTRUCTOR:String = "CommandBroadcaster is an abstract class ! Don't instantiate it directly !";
		public static const E_INTERACTIVECOMPONENT_CONSTRUCTOR:String = "AbstractInteractiveComponent is an abstract class ! Don't instantiate it directly !";
		
		public static const E_MODEL_CONSTRUCTOR:String = "AbstractModel is an abstract class ! Don't instantiate it directly !";
		
		public static const E_MACROMODEL_CONSTRUCTOR:String = "AbstractMacroModel is an abstract class ! Don't instantiate it directly !";
		
		public static const E_COMMAND_CONSTRUCTOR:String = "AbstractCommand is an abstract class ! Don't instantiate it directly !";
		public static const E_COMMAND_EXECUTE:String = "execute() in an abstract method ! Override it !";
		
		public static const E_MACROCOMMAND_CONSTRUCTOR:String = "AbstractMacroCommand is an abstract class ! Don't instantiate it directly !";
		public static const E_MACROCOMMAND_EXECUTE:String = "execute() in an abstract method ! Override it !";
		
		public static const E_ABSTRACTVIEW_CONSTRUCTOR:String = "AbstractFlashView is an abstract class ! Don't instantiate it directly !";
		public static const E_ABSTRACTVIEW_METHOD:String = "Abstract Class ! Override this method !";
		
		public static const E_VALUEOBJECT_CONSTRUCTOR:String = "AbstractValueObject is an abstract class ! Don't instantiate it directly !";
		
		public static const E_LAYERVIDEO_CONSTRUCTOR:String = "LayerVideo is an abstract class ! Don't instantiate it directly !";
		public static const E_LAYER3D_CONSTRUCTOR:String = "Layer3D is an abstract class ! Don't instantiate it directly !";
		public static const E_SCENE3D_CONSTRUCTOR:String = "AbstractEngineTemplate is an abstract class ! Don't instantiate it directly !";
		public static const E_ENGINETEMPLATE_CONSTRUCTOR:String = "AbstractEngineTemplate is an abstract class ! Don't instantiate it directly !";
		
		public static const E_TASK_ADD:String = "Class must extends AbstractTask and be not null !";
		public static const E_TASKPROCESOR_EMPTY:String = "TaskProcesor contains no tasks !";
		
		
		/**
		 * Throw an IllegalError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function IllegalError(message:String = "", id:int = 0) {
			super(message, ERROR_ID + id);
		}
	}
}