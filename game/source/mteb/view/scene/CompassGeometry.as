package mteb.view.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;


	public class CompassGeometry extends ObjectContainer3D
	{
		public function CompassGeometry()
		{
			super();
			initialize();
		}

		protected function initialize(r:Number = 128):void
		{
			const texture:BitmapTexture = new BitmapTexture(Textures.compassTextureBitmap.bitmapData);
			const mesh:Mesh = GeometryFactory.createPlane(texture, r, r, 10, true, false, true, MouseHitMethod.MESH_ANY_HIT);
			mesh.name = "Compass";
			addChild(mesh);
		}
	}
}
