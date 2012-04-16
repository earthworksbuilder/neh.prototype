package mteb.view.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;


	public class MapControl extends Sprite
	{
		public function MapControl()
		{
			super();
			initialize();
		}

		protected function initialize():void
		{
			const g:Graphics = graphics;
			g.beginFill(0x6666ff);
			g.drawRect(0, 0, 256, 128);
			g.endFill();
		}
	}
}
