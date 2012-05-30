package mteb.assets
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;


	public final class Textures
	{

		[Embed(source="/../assets/textures/box-512x512.jpg")]
		private static const BoxTexture:Class;

		[Embed(source="/../assets/textures/moonmap-512x256.jpg")]
		private static const MoonTexture:Class;

		[Embed(source="/../assets/textures/starfield-2048x1024.png")]
		private static const SkyTexture:Class;

		public static function get boxTextureBitmap():Bitmap  { return new BoxTexture(); }

		public static function get moonTextureBitmap():Bitmap  { return new MoonTexture(); }

		public static function get skyTextureBitmap():Bitmap  { return new SkyTexture(); }
	}
}
