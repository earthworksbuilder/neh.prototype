package mteb.data.map
{


	public class Node
	{

		public var azimuth:Number;
		private var _id:String;


		public function Node()
		{
		}

		public function get hotspotNegX():String  { return hotspotUrl("negX"); }

		public function get hotspotNegY():String  { return hotspotUrl("negY"); }

		public function get hotspotNegZ():String  { return hotspotUrl("negZ"); }

		public function get hotspotPosX():String  { return hotspotUrl("posX"); }

		public function get hotspotPosY():String  { return hotspotUrl("posY"); }

		public function get hotspotPosZ():String  { return hotspotUrl("posZ"); }

		public function get id():String  { return _id; }

		public function setId(value:String):void  { _id = value; }

		public function get textureNegX():String  { return textureUrl("negX"); }

		public function get textureNegY():String  { return textureUrl("negY"); }

		public function get textureNegZ():String  { return textureUrl("negZ"); }

		public function get texturePosX():String  { return textureUrl("posX"); }

		public function get texturePosY():String  { return textureUrl("posY"); }

		public function get texturePosZ():String  { return textureUrl("posZ"); }

		public function toString():String
		{
			var s:String = "[Node id: " + _id + "]";
			return s;
		}

		protected function hotspotUrl(face:String):String  { return "nodes/hotspots/" + face + "/" + face + "." + _id + ".png"; }

		protected function textureUrl(face:String):String  { return "nodes/textures/" + face + "/" + face + "." + _id + ".png"; }
	}
}
