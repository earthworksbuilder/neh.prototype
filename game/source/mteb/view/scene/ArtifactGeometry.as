package mteb.view.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;


	public class ArtifactGeometry extends ObjectContainer3D
	{


		public function ArtifactGeometry(which:uint)
		{
			super();

			initialize(which);
		}

		protected function initialize(which:uint, r:Number = 32):void
		{
			var texture:BitmapTexture;
			switch (which)
			{
				case 1:
					texture = new BitmapTexture(Textures.artifact1TextureBitmap.bitmapData);
					break;

				case 2:
					texture = new BitmapTexture(Textures.artifact2TextureBitmap.bitmapData);
					break;

				case 3:
					texture = new BitmapTexture(Textures.artifact3TextureBitmap.bitmapData);
					break;

				case 4:
					texture = new BitmapTexture(Textures.artifact4TextureBitmap.bitmapData);
					break;

				default:
					throw new ArgumentError("artifact must be constructed with 1,2,3 or 4 (got " + which + ")");
			}

			const plane:Mesh = GeometryFactory.createPlane(texture, r, r, 1, false, false, true, MouseHitMethod.MESH_ANY_HIT);
			plane.name = "Artifact " + which;
			addChild(plane);
		}
		// TODO: add method to update texture by id
	}
}
