/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.consts {
	
	
	/**
	 * LayerErrorType : Contains the description of the errors passed in the events of the Layers.
	 * 
	 * @author David Massenot
	 */
	public class LayerErrorType {
		
		
		public static const STAGE3D_UNDEFINED:String = 'Stage3D is undefined ! Adobe Flash Player 11 is required !';
		public static const CONTEXT3D_UNDEFINED:String = 'Context3D is undefined ! Probably a video driver problem !';
		public static const SOFTWARE_MODE_DETECTED:String = 'Software mode is detected ! Ensure that you are using a shader 2.0 compatible 3D card.';
		
		public static const STAGEVIDEO_UNDEFINED:String = 'StageVideo is undefined ! Adobe Flash Player 10.2 is required !';
		public static const STAGEVIDEO_UNAVAILABLE:String = 'StageVideo is not available ! Adobe Flash Player 10.2 is required !';
		public static const STAGEVIDEO_ASYNCHRONOUS_ERROR:String = 'Error from native asynchronous code.';
	}
}