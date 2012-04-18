package mteb.view.scene
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;


	public class Orbit extends ObjectContainer3D
	{
		/** How many degrees per second the subject moves */
		public var speed:Number = 360 / (24.88 * 60 * 60); // 24.88hrs for one revolution; see http://www.astronomycafe.net/qadir/q1038.html

		/** Offset from x=0 for center of oscillation */
		public var oscillateOffset:Number = 100.0; // arbitrary to match model scale

		/** How far the subject's orbital plane travels over the oscillate period */
		public var oscillateDistance:Number = 600.0; // this is arbitrary to match the scale of this 3d model so the rises and sets hit the correct azimuth values

		/** How many revolutions it takes to complete an oscillation */
		public var oscillatePeriod:Number = 27.321661; // sidereal month; see http://en.wikipedia.org/wiki/Month

		protected const S:Matrix3D = new Matrix3D();
		protected const T1:Matrix3D = new Matrix3D();
		protected const R:Matrix3D = new Matrix3D();
		protected const T2:Matrix3D = new Matrix3D();
		protected const orbit:Matrix3D = new Matrix3D();

		protected const TO_DEGREES:Number = Math.PI / 180.0;
		protected const TO_RADIANS:Number = 180 / Math.PI;

		protected var angle:Number = 0; // degrees
		protected var subject:ObjectContainer3D;


		public function Orbit()
		{
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

		public function travel(secondsElapsed:Number):void
		{
			R.identity();
			angle += speed * secondsElapsed;
			//angle = (angle + (speed * secondsElapsed)) % 360.0;
			R.appendRotation(-1 * angle, Vector3D.X_AXIS);

			const s:Number = Math.sin((angle / (oscillatePeriod * 3600)) * TO_RADIANS);
			const oscillationValue:Number = oscillateOffset + (oscillateDistance / 2) * s;
			debug(this, "travel() - angle: {0} ({1}r), s: {2}, oscillation tx: {3}", angle.toFixed(2), (angle / 360).toFixed(2), s.toFixed(2), oscillationValue.toFixed(2));
			T2.identity();
			T2.appendTranslation(oscillationValue, 0, 0);

			orbit.identity();
			orbit.append(S);
			orbit.append(T1);
			orbit.append(R);
			orbit.append(T2);

			transform = orbit;
		}
	}
}
