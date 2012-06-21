package mteb.view.scene.compass
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	import pixeldroid.signals.ProtectedSignal;

	import mteb.data.map.AzimuthTable;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;


	public class CompassSprite extends Sprite implements ITimeDriven
	{
		protected const RADIUS:uint = 512;
		protected const DIAMETER:uint = RADIUS + RADIUS;
		protected const center:Point = new Point(RADIUS, RADIUS);
		protected const _texture:BitmapData = new BitmapData(DIAMETER, DIAMETER, true, 0x00ffffff);

		protected const groundPlane:Shape = new Shape();
		protected const northArrow:Shape = new Shape();
		protected const risePoints:Vector.<MoonPoint> = new <MoonPoint>[];
		protected const setPoints:Vector.<MoonPoint> = new <MoonPoint>[];


		public function CompassSprite()
		{
			super();
			initialize()
		}

		public function animate(secondsElapsed:Number):void
		{
			var n:uint, i:uint;

			n = AzimuthTable.MOON_RISES_MIN.length;
			for (i = 0; i < n; i++)
				risePoints[i].animate(secondsElapsed);

			n = AzimuthTable.MOON_SETS_MIN.length;
			for (i = 0; i < n; i++)
				setPoints[i].animate(secondsElapsed);
		}

		public function changeRisePointState(which:uint, value:CompassLightEnum):void
		{
			risePoints[which].state = value;
		}

		public function changeSetPointState(which:uint, value:CompassLightEnum):void
		{
			setPoints[which].state = value;
		}

		public function get texture():BitmapData
		{
			_texture.draw(this, null, null, BlendMode.NORMAL);

			return _texture;
		}

		protected function initialize():void
		{
			var g:Graphics;
			var r:Number;

			g = groundPlane.graphics;
			r = RADIUS * .9;
			g.beginFill(0x000000);
			g.drawCircle(0, 0, r);
			g.endFill();

			addChild(groundPlane);
			groundPlane.x = center.x;
			groundPlane.y = center.y;

			const gr:Number = groundPlane.height / 2;

			g = northArrow.graphics;
			r = RADIUS * .2;
			g.beginFill(0xffffff);
			g.moveTo(0, 0);
			g.lineTo(-r / 2, r);
			g.lineTo(r / 2, r);
			g.lineTo(0, 0);
			g.endFill();

			addChild(northArrow);
			setAzimuthPosition(AzimuthTable.NORTH, gr, northArrow);

			var m:MoonPoint;
			var n:uint, i:uint;

			n = AzimuthTable.MOON_RISES_MIN.length;
			for (i = 0; i < n; i++)
			{
				m = new MoonPoint();
				risePoints.push(m);
				addChild(m);
				setAzimuthPosition(AzimuthTable.MOON_RISES_MIN[i], gr - m.width, m);
			}

			n = AzimuthTable.MOON_SETS_MIN.length;
			for (i = 0; i < n; i++)
			{
				m = new MoonPoint();
				setPoints.push(m);
				addChild(m);
				setAzimuthPosition(AzimuthTable.MOON_SETS_MIN[i], gr - m.width, m);
			}
		}

		protected function setAzimuthPosition(azimuth:Number, radius:Number, object:DisplayObject):void
		{
			const toRadians:Number = Math.PI / 180;
			const angle:Number = (azimuth - 90) % 360;

			const coords:Point = Point.polar(radius, angle * toRadians);
			coords.offset(center.x, center.y);

			object.x = coords.x;
			object.y = coords.y;
		}
	}
}
