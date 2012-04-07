package mteb.view.scene
{
	import flash.geom.Vector3D;

	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;


	public class MoonTrail extends SegmentSet
	{
		protected const lastPoint:Vector3D = new Vector3D();
		protected var trailLength:uint;


		public function MoonTrail(trailLength:uint = 512)
		{
			super();
			this.trailLength = trailLength;
		}

		public function setNextPoint(value:Vector3D, color:uint = 0xAAffffff, thickness:Number = 3):void
		{
			const newPoint:Vector3D = value.clone();
			const numSegments:uint = _segments.length;

			if (lastPoint.lengthSquared > 0)
			{
				if (numSegments == trailLength)
				{
					removeSegment(getSegment(0));
					debug(this, "setNextPoint() - removed 1: {0} segments", _segments.length);
				}

				addSegment(new LineSegment(lastPoint.clone(), newPoint, color, color, thickness));
				debug(this, "setNextPoint() - added 1: {0} segments", _segments.length);
			}

			lastPoint.setTo(newPoint.x, newPoint.y, newPoint.z);
		}
	}
}
