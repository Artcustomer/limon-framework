/**
	 * Artcustomer - Limon Framework
	 * 06 / 01 / 2012
	 * 
     * @langversion 3.0
     * @playerversion Flash 11.3
     * @author David Massenot (http://artcustomer.fr)
	 * @version 2.7.3.1
**/
package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * Main Class
	 * 
	 * @author David Massenot
	 */
	public class Main extends Sprite {
		
		
		/**
		 * Constructor
		 */
		public function Main() {
			this.addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function added(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		/**
		 * @private
		 */
		private function removed(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
	}
}