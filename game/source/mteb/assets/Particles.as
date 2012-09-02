package mteb.assets
{
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;


	public final class Particles
	{
		[Embed(source="/../assets/particles/star.pex", mimeType="application/octet-stream")]
		private static const StarConfig:Class;

		[Embed(source="/../assets/particles/star.png", mimeType="image/png")]
		private static const StarTexture:Class;

		public static function get starParticleSystem():PDParticleSystem
		{
			const config:XML = XML(new StarConfig());
			const texture:Texture = Texture.fromBitmap(new StarTexture());
			return new PDParticleSystem(config, texture);
		}
	}
}
