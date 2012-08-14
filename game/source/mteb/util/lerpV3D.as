package mteb.util
{
	import flash.geom.Vector3D;


	/**
	 * Component-wise linear interpolation between two Vector3D values
	 *
	 * @param a Start Vector3D. This value is returned when t = 0
	 * @param b End Vector3D. This value is returned when t = 1
	 * @param t Interpolator value, in range [0,1].
	 */
	public function lerpV3D(a:Vector3D, b:Vector3D, t:Number):Vector3D
	{
		const v:Vector3D = new Vector3D();

		v.x = a.x + ((b.x - a.x) * t);
		v.y = a.y + ((b.y - a.y) * t);
		v.z = a.z + ((b.z - a.z) * t);

		return v;
	}
}
