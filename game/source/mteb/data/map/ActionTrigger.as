package mteb.data.map
{
	import flash.geom.Point;


	public class ActionTrigger
	{
		public var nodeId:String;
		public var hotSpotColor:uint;


		public function ActionTrigger()
		{
		}

		public function toString():String
		{
			const s:String = "[ActionTrigger nodeId:" + nodeId + ", hotSpotColor: " + hotSpotColor.toString(16) + "]";
			return s;
		}
	}
}
