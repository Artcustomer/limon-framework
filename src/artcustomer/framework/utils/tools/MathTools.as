/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.geom.*;
	
	
	/**
	 * MathTools : Tools for maths operations.
	 * 
	 * @author David Massenot
	 */
	public class MathTools {
		
		
		public static const DEGREE1:Number = Math.PI / 180;
		public static const DEGREE5:Number = Math.PI / 36;
		public static const DEGREE10:Number = Math.PI / 18;
		public static const DEGREE30:Number = Math.PI / 6;
		public static const DEGREE45:Number = Math.PI / 4;
		public static const DEGREE60:Number = Math.PI / 3;
		public static const DEGREE90:Number = Math.PI / 2;
		public static const DEGREE180:Number = Math.PI;
		public static const DEGREE360:Number = Math.PI + Math.PI;
		
		
		/**
		 * Convert radian to degree.
		 * 
		 * @param	radian : Radian value
		 * @return
		 */
		public static function radianToDegree(radian:Number):Number {
			return radian * 180 / Math.PI;
		}
		
		/**
		 * Convert degree to radian.
		 * 
		 * @param	degree : Degree value.
		 * @return
		 */
		public static function degreeToRadian(degree:Number):Number {
			return degree * Math.PI / 180;
		}
		
		/**
		 * Difference between two vectors 3d
		 * 
		 * @param	pt1
		 * @param	pt2
		 * @return
		 */
		public static function vector3dDifference(pt1:Vector3D, pt2:Vector3D):Vector3D {
			return new Vector3D(pt1.x - pt2.x, pt1.y - pt2.y, pt1.z - pt2.z);
		}
		
		/**
		 * Compute two vectors dot.
		 * 
		 * @param	pt1
		 * @param	pt2
		 * @return
		 */
		public static function vectorDot(pt1:Point, pt2:Point):Number {
			return pt1.x * pt2.x + pt1.y * pt2.y;
        }
		
		/**
		 * Cross two vectors.
		 * 
		 * @param	pt1
		 * @param	pt2
		 * @return
		 */
		public static function vectorCross(pt1:Point, pt2:Point):Number {
			return pt1.x * pt2.y - pt1.y * pt2.x;
        }
		
		/**
		 * Compute two vectors angles.
		 * 
		 * @param	pt1
		 * @param	pt2
		 * @return
		 */
		public static function vectorAngle(pt1:Point, pt2:Point):Number {
			var squareLength:Number = pt1.length * pt2.length;
			var angle:Number = squareLength == 0 ? 1 : vectorDot(pt1, pt2) / squareLength;
			
			return Math.acos(angle);
        }
		
		/**
		 * Get a random number between two values.
		 * 
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function random(min:Number = 0, max:Number = 0):Number {
			if (arguments.length == 0) return Math.random();
			if (arguments.length == 1) return Math.random() * min;
			
			return Math.random() * (max - min) + min;
        }
		
		/**
		 * Get a random angle.
		 * 
		 * @return
		 */
		public static function randomAngle():Number {
			return Math.random() * DEGREE360;
        }
	}
}