package mteb.assets
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;


	public final class Textures
	{

		[Embed(source="/../assets/textures/moonmap-512x256.jpg")]
		private static const MoonTexture:Class;

		[Embed(source="/../assets/textures/starfield-2048x1024.png")]
		private static const SkyTexture:Class;

		[Embed(source="/../assets/textures/nodemap-256x256.png")]
		private static const MapTexture:Class;

		public static function get moonTextureBitmap():Bitmap  { return new MoonTexture(); }

		public static function get nodeMap():Sprite  { return centeredParent(new MapTexture()); }

		public static function get skyTextureBitmap():Bitmap  { return new SkyTexture(); }

		private static function centeredParent(value:DisplayObject):Sprite
		{
			const p:Sprite = new Sprite();
			const c:DisplayObject = p.addChild(value);
			c.x -= c.width / 2;
			c.y -= c.height / 2;
			return p;
		}
	}
}
