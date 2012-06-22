package mteb.view.scene.compass
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;

	import mteb.data.time.ITimeDriven;


	public class ArtifactPoint extends Sprite implements ITimeDriven
	{
		protected const _icon:Bitmap = new Bitmap();

		protected var _state:CompassLightEnum = CompassLightEnum.DISABLED;
		protected var invalidated:Boolean = false;


		public function ArtifactPoint()
		{
			super();

			addChild(_icon);
		}

		public function animate(secondsElapsed:Number):void
		{
			if (invalidated)
			{
				draw();
				invalidated = false;
			}
		}

		public function get icon():BitmapData
		{
			return _icon.bitmapData;
		}

		public function set icon(value:BitmapData):void
		{
			_icon.bitmapData = value;
			_icon.x = _icon.width * -.5;
			_icon.y = _icon.height * -.5;
			invalidated = true;
		}

		public function get state():CompassLightEnum
		{
			return _state;
		}

		public function set state(value:CompassLightEnum):void
		{
			_state = value;
			invalidated = true;
		}

		protected function draw():void
		{
			var color:uint = 0xff0000;
			switch (_state)
			{
				case CompassLightEnum.DISABLED:
					color = 0x666666;
					_icon.alpha = .3;
					break;

				case CompassLightEnum.ENABLED:
					color = 0x999999;
					_icon.alpha = .6;
					break;

				case CompassLightEnum.ON:
					color = 0xffffff;
					_icon.alpha = 1;
					break;
			}

			graphics.clear();
			graphics.lineStyle(4, 0x555555);
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, (_icon.width * 1.125) * .5);
			graphics.endFill();
		}
	}
}
