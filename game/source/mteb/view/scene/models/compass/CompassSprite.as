package mteb.view.scene.models.compass
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	import mteb.assets.Textures;
	import mteb.data.orbit.Ephemeris;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;


	public class CompassSprite extends Sprite implements ITimeDriven
	{
		protected const EMPTY:uint = 0x00ffffff;
		protected const RADIUS:uint = 512;
		protected const DIAMETER:uint = RADIUS + RADIUS;
		protected const center:Point = new Point(RADIUS, RADIUS);
		protected const _texture:BitmapData = new BitmapData(DIAMETER, DIAMETER, true, EMPTY);

		protected const groundPlane:Shape = new Shape();
		protected const northArrow:Shape = new Shape();
		protected const risePoints:Vector.<MoonPoint> = new <MoonPoint>[];
		protected const setPoints:Vector.<MoonPoint> = new <MoonPoint>[];
		protected const artifactPoints:Vector.<ArtifactPoint> = new <ArtifactPoint>[];


		public function CompassSprite()
		{
			super();
			initialize()
		}

		public function changeArtifactPointState(which:uint, value:CompassLightEnum):void
		{
			artifactPoints[which].state = value;
		}

		public function changeRisePointState(which:uint, value:CompassLightEnum):void
		{
			risePoints[which].state = value;
		}

		public function changeSetPointState(which:uint, value:CompassLightEnum):void
		{
			setPoints[which].state = value;
		}

		public function getRisePointState(which:uint):CompassLightEnum
		{
			return risePoints[which].state;
		}

		public function getSetPointState(which:uint):CompassLightEnum
		{
			return setPoints[which].state;
		}

		public function onTimeElapsed(time:ITime):void
		{
			var n:uint, i:uint;

			n = Ephemeris.MOON_MIN_RISES.length;
			for (i = 0; i < n; i++)
				risePoints[i].onTimeElapsed(time);

			n = Ephemeris.MOON_MIN_SETS.length;
			for (i = 0; i < n; i++)
				setPoints[i].onTimeElapsed(time);

			n = artifactPoints.length;
			for (i = 0; i < n; i++)
				artifactPoints[i].onTimeElapsed(time);
		}

		public function get texture():BitmapData
		{
			_texture.fillRect(_texture.rect, EMPTY);
			_texture.draw(this);

			return _texture;
		}

		protected function initialize():void
		{
			var g:Graphics;
			var r:Number;

			g = groundPlane.graphics;
			r = RADIUS * .75;
			g.beginFill(0xffffff, .2);
			g.drawCircle(0, 0, r);
			g.endFill();

			addChild(groundPlane);
			groundPlane.x = center.x;
			groundPlane.y = center.y;

			const gr:Number = groundPlane.height / 2;

			g = northArrow.graphics;
			r = RADIUS * .2;
			g.beginFill(0xffffff, .6);
			g.moveTo(0, 0);
			g.lineTo(-r / 2, r);
			g.lineTo(r / 2, r);
			g.lineTo(0, 0);
			g.endFill();

			addChild(northArrow);
			setAzimuthPosition(Ephemeris.NORTH, gr, northArrow);

			var m:MoonPoint;
			var n:uint, i:uint;

			n = Ephemeris.MOON_MIN_RISES.length;
			for (i = 0; i < n; i++)
			{
				m = new MoonPoint();
				risePoints.push(m);
				addChild(m);
				setAzimuthPosition(Ephemeris.MOON_MIN_RISES[i], gr - m.width, m);
			}

			n = Ephemeris.MOON_MIN_SETS.length;
			for (i = 0; i < n; i++)
			{
				m = new MoonPoint();
				setPoints.push(m);
				addChild(m);
				setAzimuthPosition(Ephemeris.MOON_MIN_SETS[i], gr - m.width, m);
			}

			var a:ArtifactPoint;

			a = new ArtifactPoint();
			a.icon = Textures.artifact1PointBitmap.bitmapData;
			artifactPoints.push(a);
			addChild(a);
			setAzimuthPosition(Ephemeris.southMinRise, gr + a.width * .5, a);

			a = new ArtifactPoint();
			a.icon = Textures.artifact2PointBitmap.bitmapData;
			artifactPoints.push(a);
			addChild(a);
			setAzimuthPosition(Ephemeris.southMinSet, gr + a.width * .5, a);

			a = new ArtifactPoint();
			a.icon = Textures.artifact3PointBitmap.bitmapData;
			artifactPoints.push(a);
			addChild(a);
			setAzimuthPosition(Ephemeris.northMinRise, gr + a.width * .5, a);

			a = new ArtifactPoint();
			a.icon = Textures.artifact4PointBitmap.bitmapData;
			artifactPoints.push(a);
			addChild(a);
			setAzimuthPosition(Ephemeris.northMinSet, gr + a.width * .5, a);
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
