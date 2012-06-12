package mteb.assets
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;


	public final class Textures
	{

		[Embed(source="/../assets/textures/artifacts/artifact-1.png")]
		private static const Artifact1Texture:Class;

		[Embed(source="/../assets/textures/artifacts/artifact-2.png")]
		private static const Artifact2Texture:Class;

		[Embed(source="/../assets/textures/artifacts/artifact-3.png")]
		private static const Artifact3Texture:Class;

		[Embed(source="/../assets/textures/artifacts/artifact-4.png")]
		private static const Artifact4Texture:Class;

		[Embed(source="/../assets/textures/compass-1024x1024.png")]
		private static const CompassTexture:Class;

		[Embed(source="/../assets/textures/moonmap-512x256.jpg")]
		private static const MoonTexture:Class;

		[Embed(source="/../assets/textures/starfield-2048x1024.png")]
		private static const SkyTexture:Class;

		public static function get artifact1TextureBitmap():Bitmap  { return new Artifact1Texture(); }

		public static function get artifact2TextureBitmap():Bitmap  { return new Artifact2Texture(); }

		public static function get artifact3TextureBitmap():Bitmap  { return new Artifact3Texture(); }

		public static function get artifact4TextureBitmap():Bitmap  { return new Artifact4Texture(); }

		public static function get compassTextureBitmap():Bitmap  { return new CompassTexture(); }

		public static function get moonTextureBitmap():Bitmap  { return new MoonTexture(); }

		public static function get skyTextureBitmap():Bitmap  { return new SkyTexture(); }
	}
}
