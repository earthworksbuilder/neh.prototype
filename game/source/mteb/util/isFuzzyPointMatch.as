package mteb.util
{
	import flash.geom.Point;


	public function isFuzzyPointMatch(a:Point, b:Point, fuzz:uint = 6):Boolean
	{
		const d:Number = Point.distance(a, b);

		return (d <= fuzz);
	}
}
