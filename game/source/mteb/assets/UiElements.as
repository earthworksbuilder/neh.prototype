package mteb.assets
{
	import flash.display.Bitmap;
	import flash.display.Sprite;


	public final class UiElements
	{

		[Embed(source="/../assets/ui/map/nodemap-256x256.png", mimeType="image/png")]
		private static const MapTexture:Class;

		[Embed(source="/../assets/ui/map/view-angle.png", mimeType="image/png")]
		private static const MapViewAngle:Class;

		[Embed(source="/../assets/ui/title.jpg", mimeType="image/jpeg")]
		private static const TitleScreen:Class;

		public static function get mapViewAngle():Sprite  { return AssetUtils.createOffsetParent(new MapViewAngle(), -.50, -.76); }

		public static function get nodeMap():Sprite  { return AssetUtils.createOffsetParent(new MapTexture()); }

		public static function get titleScreen():Bitmap  { return new TitleScreen(); }
	}
}
