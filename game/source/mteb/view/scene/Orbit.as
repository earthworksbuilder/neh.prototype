package mteb.view.scene
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;


	public class Orbit extends ObjectContainer3D
	{
		public var speed:Number = 32;
		public var oscillateDistance:Number = 40;

		protected const S:Matrix3D = new Matrix3D();
		protected const T1:Matrix3D = new Matrix3D();
		protected const R:Matrix3D = new Matrix3D();
		protected const T2:Matrix3D = new Matrix3D();
		protected const orbit:Matrix3D = new Matrix3D();

		protected var angle:Number = 0;
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
			R.appendRotation(-1 * angle, Vector3D.X_AXIS);

			T2.identity();
			T2.appendTranslation(oscillateDistance * Math.cos((1 / 14) * (angle * Math.PI / 180)), 0, 0);

			orbit.identity();
			orbit.append(S);
			orbit.append(T1);
			orbit.append(R);
			orbit.append(T2);

			transform = orbit;
		}
	}
}
