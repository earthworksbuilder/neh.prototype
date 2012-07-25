package mteb.view.scene.compass
{
	import flash.display.Shape;

	import mteb.data.time.ITimeDriven;


	public class MoonPoint extends Shape implements ITimeDriven
	{
		protected var _radius:Number = 10;
		protected var _state:CompassLightEnum = CompassLightEnum.LOCKED;
		protected var invalidated:Boolean = false;
		protected var timeDependent:Boolean = false;


		public function MoonPoint()
		{
			super();
			draw(0);
		}

		public function animate(secondsElapsed:Number, secondsTotal:Number):void
		{
			if (invalidated || timeDependent)
			{
				draw(secondsTotal);
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
			timeDependent = (_state == CompassLightEnum.ACTIVATED);
		}

		protected function draw(t:Number):void
		{
			var color:uint = 0xff0000;
			var opacity:Number = 1.0;
			switch (_state)
			{
				case CompassLightEnum.LOCKED:
					color = 0x333333;
					break;

				case CompassLightEnum.UNLOCKED:
					color = 0x666666;
					break;

				case CompassLightEnum.ACTIVATED:
					color = 0x999999;
					opacity = .85 + (.15 * Math.sin(3 * t));
					break;

				case CompassLightEnum.CAPTURED:
					color = 0xffffff;
					break;
			}

			graphics.clear();
			graphics.lineStyle(2, 0x555555);
			graphics.beginFill(color, opacity);
			graphics.drawCircle(0, 0, _radius);
			graphics.endFill();
		}
	}
}
