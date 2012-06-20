package mteb.view.scene.compass
{
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;


	public class CompassSprite extends Sprite implements ITimeDriven
	{
		protected const SIZE:uint = 1024;
		protected const _texture:BitmapData = new BitmapData(SIZE, SIZE, true);


		public function CompassSprite()
		{
			super();
		}

		public function animate(secondsElapsed:Number):void
		{
			const rgb:uint = ((Math.random() * 255) << 16) | ((Math.random() * 255) << 8) | (Math.random() * 255);
			graphics.beginFill(rgb);
			graphics.drawRect(0, 0, SIZE, SIZE);
			graphics.endFill();
		}

		public function get texture():BitmapData
		{
			_texture.draw(this);

			return _texture;
		}
	}
}
