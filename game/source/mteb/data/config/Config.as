package mteb.data.config
{


	public class Config implements IConfig
	{
		protected var _showHotspots:Boolean = false;

		protected var _moveRate:Number = 250;

		protected var _spinRate:Number = 45;

		protected var _showStars:Boolean = true;

		/** @inheritDoc */
		public function get moveRate():Number  { return _moveRate; }

		/** @inheritDoc */
		public function set moveRate(value:Number):void  { _moveRate = value; }

		/** @inheritDoc */
		public function get showHotspots():Boolean  { return _showHotspots; }

		/** @inheritDoc */
		public function set showHotspots(value:Boolean):void  { _showHotspots = value; }

		/** @inheritDoc */
		public function get showStars():Boolean  { return _showStars; }

		/** @inheritDoc */
		public function set showStars(value:Boolean):void  { _showStars = value; }

		/** @inheritDoc */
		public function get spinRate():Number  { return _spinRate; }

		/** @inheritDoc */
		public function set spinRate(value:Number):void  { _spinRate = value; }

		public function toString():String
		{
			const a:Array = [];
			a.push("moveRate: " + moveRate);
			a.push("showHotspots: " + showHotspots);
			a.push("showStars: " + showStars);
			a.push("spinRate: " + spinRate);

			return a.join("\n");
		}
	}
}
