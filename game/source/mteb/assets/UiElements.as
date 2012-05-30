package mteb.assets
{
	import flash.display.Sprite;


	public final class UiElements
	{

		[Embed(source="/../assets/ui/map/nodemap-256x256.png")]
		private static const MapTexture:Class;

		public static function get nodeMap():Sprite  { return AssetUtils.centeredParent(new MapTexture()); }
	}
}
