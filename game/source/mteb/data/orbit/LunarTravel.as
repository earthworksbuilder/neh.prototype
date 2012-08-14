package mteb.data.orbit
{
	import flash.geom.Vector3D;

	import away3d.core.math.Quaternion;


	public class LunarTravel
	{
		private static const TO_RADIANS:Number = Math.PI / 180;

		public static function getMaxRise(which:uint):Quaternion
		{
			return makeQuaternion(Vector3D.Y_AXIS, Ephemeris.MOON_MAX_RISES[which]);
		}

		public static function getMaxSet(which:uint):Quaternion
		{
			return makeQuaternion(Vector3D.Y_AXIS, Ephemeris.MOON_MAX_SETS[which]);
		}

		public static function getMaxTransit(which:uint):Quaternion
		{
			const ry:Number = .5 * (Ephemeris.MOON_MAX_SETS[which] - Ephemeris.MOON_MAX_RISES[which]) - 180;
			const rz:Number = -Ephemeris.MOON_MAX_TRANSITS[which];
			return makeQuaternion2(0, ry, rz);

			return makeQuaternion(Vector3D.Z_AXIS, Ephemeris.MOON_MAX_TRANSITS[which]);
		}

		public static function getMaxUnderTransit(which:uint):Quaternion
		{
			const ry:Number = .5 * (Ephemeris.MOON_MAX_SETS[which] - Ephemeris.MOON_MAX_RISES[which]);
			const rz:Number = Ephemeris.MOON_MAX_TRANSITS[which] + 180;
			return makeQuaternion2(0, ry, rz);

			const invZ:Vector3D = Vector3D.Z_AXIS.clone();
			invZ.negate();
			return makeQuaternion(invZ, Ephemeris.MOON_MAX_TRANSITS[which]);
		}

		public static function getMinRise(which:uint):Quaternion
		{
			return makeQuaternion(Vector3D.Y_AXIS, Ephemeris.MOON_MIN_RISES[which]);
		}

		public static function getMinSet(which:uint):Quaternion
		{
			return makeQuaternion(Vector3D.Y_AXIS, Ephemeris.MOON_MIN_SETS[which]);
		}

		public static function getMinTransit(which:uint):Quaternion
		{
			const ry:Number = .5 * (Ephemeris.MOON_MIN_SETS[which] - Ephemeris.MOON_MIN_RISES[which]) - 180;
			const rz:Number = -Ephemeris.MOON_MIN_TRANSITS[which];
			return makeQuaternion2(0, ry, rz);

			return makeQuaternion(Vector3D.Z_AXIS, Ephemeris.MOON_MIN_TRANSITS[which]);
		}

		public static function getMinUnderTransit(which:uint):Quaternion
		{
			const ry:Number = .5 * (Ephemeris.MOON_MIN_SETS[which] - Ephemeris.MOON_MIN_RISES[which]);
			const rz:Number = Ephemeris.MOON_MIN_TRANSITS[which] + 180;
			return makeQuaternion2(0, ry, rz);

			const invZ:Vector3D = Vector3D.Z_AXIS.clone();
			invZ.negate();
			return makeQuaternion(invZ, Ephemeris.MOON_MIN_TRANSITS[which]);
		}

		private static function makeQuaternion(axis:Vector3D, degrees:Number):Quaternion
		{
			const q:Quaternion = new Quaternion();
			q.fromAxisAngle(axis, degrees * TO_RADIANS);
			return q;
		}

		private static function makeQuaternion2(degX:Number, degY:Number, degZ:Number):Quaternion
		{
			const q:Quaternion = new Quaternion();
			q.fromEulerAngles(degX * TO_RADIANS, degY * TO_RADIANS, degZ * TO_RADIANS);
			return q;
		}
	}
}
