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
			return makeQuaternion(Vector3D.Z_AXIS, Ephemeris.MOON_MAX_TRANSITS[which]);
		}

		public static function getMaxUnderTransit(which:uint):Quaternion
		{
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
			return makeQuaternion(Vector3D.Z_AXIS, Ephemeris.MOON_MIN_TRANSITS[which]);
		}

		public static function getMinUnderTransit(which:uint):Quaternion
		{
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
	}
}
