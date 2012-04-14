package mteb.view.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;


	public class TimeControl extends Sprite
	{
		public function TimeControl()
		{
			super();
			initialize();
		}

		protected function initialize():void
		{
			const g:Graphics = graphics;
			g.beginFill(0x888888);
			g.drawRect(0, 0, 300, 30);
			g.endFill();
		}
	}
}
