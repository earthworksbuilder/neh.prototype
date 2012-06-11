package mteb.assets
{
	import flash.display.Sprite;


	public final class UiElements
	{

		[Embed(source="/../assets/ui/map/nodemap-256x256.png")]
		private static const MapTexture:Class;

		[Embed(source="/../assets/ui/map/view-angle.png")]
		private static const MapViewAngle:Class;

		public static function get mapViewAngle():Sprite  { return AssetUtils.createOffsetParent(new MapViewAngle(), -.50, -.76); }

		public static function get nodeMap():Sprite  { return AssetUtils.createOffsetParent(new MapTexture()); }
	}
}
