package mteb.view.scene.models.moon
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Quaternion;

	import mteb.assets.UiElements;
	import mteb.data.orbit.Ephemeris;
	import mteb.data.orbit.LunarTravel;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;


	public class Orbit extends ObjectContainer3D implements ITimeDriven
	{
		/** How many degrees per second the subject moves */
		public var degreesPerSecond:Number = 360 / (24.88 * 60 * 60); // 24.88hrs for one revolution; see http://www.astronomycafe.net/qadir/q1038.html

		protected const S:Matrix3D = new Matrix3D();
		protected const T1:Matrix3D = new Matrix3D();
		protected const R:Matrix3D = new Matrix3D();
		protected const orbit:Matrix3D = new Matrix3D();

		protected const TO_DEGREES:Number = Math.PI / 180.0;
		protected const TO_RADIANS:Number = 180 / Math.PI;

		protected const rise:Quaternion = new Quaternion();
		protected const set:Quaternion = new Quaternion();
		protected const transit:Quaternion = new Quaternion();
		protected const underTransit:Quaternion = new Quaternion();
		protected const q:Quaternion = new Quaternion();

		protected var subject:ObjectContainer3D;

		protected var a:Number;
		protected var t:Number;
		protected var d:uint;


		public function Orbit()
		{
			a = 0;
			t = 0;
			day = 0;
		}

		public function get day():uint  { return d; }

		public function set day(value:uint):void
		{
			if (value > Ephemeris.NUM_DAYS - 1)
				throw new ArgumentError("index '" + value + "' out of range (" + (Ephemeris.NUM_DAYS - 1) + ")");

			d = value;

			rise.copyFrom(LunarTravel.getMinRise(d));
			transit.copyFrom(LunarTravel.getMinTransit(d));
			set.copyFrom(LunarTravel.getMinSet(d));
			underTransit.copyFrom(LunarTravel.getMinUnderTransit(d));
		}

		public function onTimeElapsed(time:ITime):void
		{
			R.identity();

			a += degreesPerSecond * time.secondsElapsedScaled;
			if (a >= 360)
			{
				a %= 360;
				day = (d + 1) % Ephemeris.NUM_DAYS;
			}
			t = a / 360;
			//debug(this, "onTimeElapsed() - t: {0}, a: {1}", t, a);

			if (t <= .25)
				q.slerp(rise, transit, (t * 4));
			else if (t <= .50)
				q.slerp(transit, set, (t - .25) * 4);
			else if (t <= .75)
				q.slerp(set, underTransit, (t - .50) * 4);
			else
				q.slerp(underTransit, rise, (t - .75) * 4);

			q.toMatrix3D(R);

			orbit.identity();
			orbit.append(S);
			orbit.append(T1);
			orbit.append(R);

			transform = orbit;
		}

		public function setSubject(value:ObjectContainer3D, distance:Number, scale:Number = 1):void
		{
			subject = value;
			addChild(subject);

			T1.identity();
			T1.appendTranslation(0, 0, distance);

			S.identity();
			S.appendScale(scale, scale, scale);
		}

		public function get subjectPosition():Vector3D
		{
			return transform.transformVector(subject.position);
		}
	}
}
