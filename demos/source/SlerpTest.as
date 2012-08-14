package
{
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	import pixeldroid.away3d.SimpleView3D;

	import mteb.data.orbit.Ephemeris;
	import mteb.util.paletteColor;
	import mteb.util.slerp;


	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW")]
	public class SlerpTest extends SimpleView3D
	{


		public function SlerpTest()
		{
			super();
		}

		override protected function createGeo():ObjectContainer3D
		{
			const geoContainer:ObjectContainer3D = new ObjectContainer3D();

			geoContainer.addChild(new Trident(100));
			/*
			geoContainer.addChild(new WireframeAxesGrid(20, 500));

			var trident:Trident = new Trident(100);
			trident.moveRight(250);
			trident.moveDown(250);
			trident.moveForward(250);
			geoContainer.addChild(trident);
			*/

			for (var i:uint = 0; i < Ephemeris.NUM_DAYS; i += 1)
				createOrbit(i, geoContainer);


			return geoContainer;
		}

		private function createOrbit(which:uint, geoContainer:ObjectContainer3D):void
		{
			const material:ColorMaterial = new ColorMaterial(paletteColor(which, 180, 255 - 180));

			const d:uint = 300;
			const pr:Vector3D = Ephemeris.getMaxRisePosition(which, d);
			const prt:Vector3D = Ephemeris.getMaxTransitPosition(which, false, d);
			const ps:Vector3D = Ephemeris.getMaxSetPosition(which, d);
			const pst:Vector3D = Ephemeris.getMaxTransitPosition(which, true, d);

			var mesh:Mesh;
			var geometry:CubeGeometry;
			var i:uint, t:Number;
			const n:uint = 15;
			const c:uint = 8;

			// rise
			for (i = 0; i <= n; i++)
			{
				geometry = new CubeGeometry(c, c, c);
				mesh = new Mesh(geometry, material);
				t = i / n;
				mesh.position = slerp(slerp(pr, prt, t / 2), slerp(prt, ps, t / 2 + .5), t);

				geoContainer.addChild(mesh);
			}

			// set
			for (i = 0; i <= n; i++)
			{
				geometry = new CubeGeometry(c, c, c);
				mesh = new Mesh(geometry, material);
				t = i / n;
				mesh.position = slerp(slerp(ps, pst, t / 2), slerp(pst, pr, t / 2 + .5), t);

				geoContainer.addChild(mesh);
			}
		}
	}
}
