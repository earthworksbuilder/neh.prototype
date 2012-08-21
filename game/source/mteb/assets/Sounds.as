package mteb.assets
{
	import flash.media.Sound;


	public final class Sounds
	{
		[Embed(source="/../assets/sounds/environment-background/countryNight.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const CountryNight:Class;

		[Embed(source="/../assets/sounds/win-music/drum-and-flute3.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const DrumAndFlute:Class;

		[Embed(source="/../assets/sounds/environment-background/nightCrickets.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const NightCrickets:Class;

		[Embed(source="/../assets/sounds/sound-effects/drum_1_beat.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const DrumOneBeat:Class;

		[Embed(source="/../assets/sounds/sound-effects/drum_2_beats.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const DrumTwoBeat:Class;

		[Embed(source="/../assets/sounds/sound-effects/drum_3_beats.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const DrumThreeBeat:Class;

		[Embed(source="/../assets/sounds/sound-effects/drum_5_beats.swf#wav", mimeType="application/x-shockwave-flash")]
		private static const DrumFiveBeat:Class;

		public static function get countryNight():Sound  { return new CountryNight() as Sound; }

		public static function get drumAndFlute():Sound  { return new DrumAndFlute() as Sound; }

		public static function get drumFiveBeat():Sound  { return new DrumFiveBeat() as Sound; }

		public static function get drumOneBeat():Sound  { return new DrumOneBeat() as Sound; }

		public static function get drumThreeBeat():Sound  { return new DrumThreeBeat() as Sound; }

		public static function get drumTwoBeat():Sound  { return new DrumTwoBeat() as Sound; }

		public static function get nightCrickets():Sound  { return new NightCrickets() as Sound; }
	}
}
