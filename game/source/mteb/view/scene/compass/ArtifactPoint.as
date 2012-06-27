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

		protected var _state:CompassLightEnum = CompassLightEnum.LOCKED;
		protected var invalidated:Boolean = false;
		protected var timeDependent:Boolean = false;
		protected var time:Number = 0;


		public function ArtifactPoint()
		{
			super();

			addChild(_icon);
		}

		public function animate(secondsElapsed:Number):void
		{
			time += secondsElapsed;
			if (invalidated || timeDependent)
			{
				draw(time);
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
			timeDependent = (_state == CompassLightEnum.ACTIVATED);
		}

		protected function draw(t:Number):void
		{
			var stroke:uint = 0xffff00;
			var fill:uint = 0xff0000;
			switch (_state)
			{
				case CompassLightEnum.LOCKED:
					stroke = 0x555555;
					fill = 0x333333;
					_icon.alpha = .3;
					break;

				case CompassLightEnum.UNLOCKED:
					stroke = 0x333333;
					fill = 0xcccccc;
					_icon.alpha = .85;
					break;

				case CompassLightEnum.ACTIVATED:
					stroke = 0x444444;
					fill = 0xffffff;
					_icon.alpha = .5 + (.15 * Math.sin(5 * t));
					break;

				case CompassLightEnum.CAPTURED:
					stroke = 0x999999;
					fill = 0xffffff;
					_icon.alpha = .6;
					break;
			}

			graphics.clear();
			graphics.lineStyle(4, stroke);
			graphics.beginFill(fill);
			graphics.drawCircle(0, 0, (_icon.width * 1.125) * .5);
			graphics.endFill();
		}
	}
}
