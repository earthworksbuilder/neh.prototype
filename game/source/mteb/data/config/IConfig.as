package mteb.data.config
{


	public interface IConfig
	{


		/** World units per second */
		function get moveRate():Number;

		/** @private */
		function set moveRate(value:Number):void;


		/** true to reveal node hotspots for debugging */
		function get showHotspots():Boolean;

		/** @private */
		function set showHotspots(value:Boolean):void;


		/** false to hide sky geometry */
		function get showStars():Boolean;

		/** @private */
		function set showStars(value:Boolean):void;


		/** true to reveal time control bar */
		function get showTimeControl():Boolean;

		/** @private */
		function set showTimeControl(value:Boolean):void;


		/** Degrees per second */
		function get spinRate():Number;

		/** @private */
		function set spinRate(value:Number):void;
	}
}
