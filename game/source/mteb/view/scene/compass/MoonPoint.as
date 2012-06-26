package mteb.view.scene.compass
{
	import flash.display.Shape;

	import mteb.data.time.ITimeDriven;


	public class MoonPoint extends Shape implements ITimeDriven
	{
		protected var _radius:Number = 10;
		protected var _state:CompassLightEnum = CompassLightEnum.LOCKED;
		protected var invalidated:Boolean = false;


		public function MoonPoint()
		{
			super();
			draw();
		}

		public function animate(secondsElapsed:Number):void
		{
			if (invalidated)
			{
				draw();
				invalidated = false;
			}
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
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
				case CompassLightEnum.LOCKED:
					color = 0x333333;
					break;

				case CompassLightEnum.UNLOCKED:
					color = 0x999999;
					break;

				case CompassLightEnum.CAPTURED:
					color = 0xffffff;
					break;
			}

			graphics.clear();
			graphics.lineStyle(2, 0x555555);
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, _radius);
			graphics.endFill();
		}
	}
}
