package mteb.view.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
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

		protected function initialize(r:Number = 20):void
		{
			var geometry:CubeGeometry = new CubeGeometry(r, r / 2, r);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(Textures.boxTextureBitmap.bitmapData));

			var mesh:Mesh = new Mesh(geometry, material);
			mesh.name = "Artifact-" + which;
			mesh.mouseEnabled = true;
			mesh.mouseHitMethod = MouseHitMethod.MESH_ANY_HIT;
			addChild(mesh);
		}
	}
}
