package mteb.util
{
	import flash.geom.Vector3D;


	/**
	 * Geometric Spherical Linear Interpolation between two 3d points
	 *
	 * @param p0 Start point. This value is returned when t = 0
	 * @param p1 End point. This value is returned when t = 1
	 * @param t Interpolator value, in range [0,1].
	 *
	 * @see http://en.wikipedia.org/wiki/Slerp
	 */
	public function slerp(p0:Vector3D, p1:Vector3D, t:Number):Vector3D
	{
		// http://www.mathworks.com/matlabcentral/newsreader/view_thread/151925
		const Y:Number = p0.crossProduct(p1).length;
		const X:Number = p0.dotProduct(p1);
		const omega:Number = Math.atan2(Y, X);
		const sinOmega:Number = Math.sin(omega);

		const p0t:Vector3D = p0.clone();
		const p1t:Vector3D = p1.clone();
		p0t.scaleBy(Math.sin((1 - t) * omega) / sinOmega);
		p1t.scaleBy(Math.sin(t * omega) / sinOmega);

		return p0t.add(p1t);

	/*
		// http://en.wikipedia.org/wiki/Slerp
		const p0n:Vector3D = p0.clone();
		const p1n:Vector3D = p1.clone();
		p0n.normalize();
		p1n.normalize();

		const omega:Number = Math.acos(p0n.dotProduct(p1n));
		const sinOmega:Number = Math.sin(omega);

		const p0t:Vector3D = p0.clone();
		const p1t:Vector3D = p1.clone();
		p0t.scaleBy(Math.sin((1 - t) * omega) / sinOmega);
		p1t.scaleBy(Math.sin(t * omega) / sinOmega);

		return p0t.add(p1t);
	*/
	}
}
