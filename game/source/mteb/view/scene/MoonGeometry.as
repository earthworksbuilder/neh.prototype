package mteb.view.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;


	public class MoonGeometry extends ObjectContainer3D
	{

		public function MoonGeometry()
		{
			super();
			initialize();
		}

		protected function initialize(r:Number = 64):void
		{
			const texture:BitmapTexture = new BitmapTexture(Textures.moonTextureBitmap.bitmapData);
			const mesh:Mesh = GeometryFactory.createSphere(texture, r);
			mesh.name = "MeshMoon";
			addChild(mesh);
		}
	}
}
