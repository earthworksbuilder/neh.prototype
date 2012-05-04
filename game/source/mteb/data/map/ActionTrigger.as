package mteb.data.map
{
	import flash.geom.Point;


	public class ActionTrigger
	{
		public var type:ActionTypeEnum;
		public var nodeId:String;
		public var hotSpotColor:uint;


		public function ActionTrigger()
		{
		}

		public function toString():String
		{
			const s:String = "[ActionTrigger type: " + type + ", nodeId: " + nodeId + ", hotSpotColor: 0x" + hotSpotColor.toString(16) + "]";
			return s;
		}
	}
}
