package mteb.view.scene
{
	import flash.geom.Vector3D;

	import away3d.arcane;
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	import away3d.primitives.data.Segment;


	public class MoonTrail extends SegmentSet
	{
		public var maxThickness:Number = 30;
		public var minThickness:Number = 3;

		protected const lastPoint:Vector3D = new Vector3D();
		protected var trailLength:uint;


		public function MoonTrail(trailLength:uint = 400)
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
				if (numSegments < trailLength)
					addSegment(new LineSegment(lastPoint.clone(), newPoint, color, color));

				var i:uint = 0;
				var s:Segment, s1:Segment;
				while (i < numSegments)
				{
					s = _segments[i];
					s.thickness = getThickness(i / numSegments);

					if (i + 1 < numSegments)
					{
						s1 = _segments[i + 1];
						s.start.setTo(s1.start.x, s1.start.y, s1.start.z);
						s.end.setTo(s1.end.x, s1.end.y, s1.end.z);
					}
					else
					{
						s.start.setTo(lastPoint.x, lastPoint.y, lastPoint.z);
						s.end.setTo(newPoint.x, newPoint.y, newPoint.z);
					}

					arcane::updateSegment(s);
					i++;
				}

			}

			lastPoint.setTo(newPoint.x, newPoint.y, newPoint.z);
		}

		protected function getThickness(t:Number):Number
		{
			return minThickness + ((maxThickness - minThickness) * t);
		}
	}
}
