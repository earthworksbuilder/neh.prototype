package mteb.util
{

	/**
	 * Linear interpolation between two numerical values
	 *
	 * @param a Start number. This value is returned when t = 0
	 * @param b End number. This value is returned when t = 1
	 * @param t Interpolator value, in range [0,1].
	 */
	public function lerp(a:Number, b:Number, t:Number):Number
	{
		return a + ((b - a) * t);
	}
}
