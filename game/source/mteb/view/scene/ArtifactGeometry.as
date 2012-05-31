package mteb.view.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;


	public class ArtifactGeometry extends ObjectContainer3D
	{
		private static var which:uint = 0;


		public function ArtifactGeometry()
		{
			super();

			which++;
			initialize();
		}

		protected function initialize(r:Number = 32):void
		{
			const texture:BitmapTexture = new BitmapTexture(Textures.boxTextureBitmap.bitmapData);
			const mesh:Mesh = GeometryFactory.createBox(texture, r, r / 2, r, false, false, MouseHitMethod.MESH_ANY_HIT);
			mesh.name = "Artifact-" + which;
			addChild(mesh);
		}
	}
}
