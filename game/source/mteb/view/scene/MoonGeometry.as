package mteb.view.scene
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;


	public class MoonGeometry extends ObjectContainer3D
	{
		[Embed(source="/../embeds/moonmap-512x256.jpg")]
		protected const MoonTexture:Class;


		public function MoonGeometry()
		{
			super();
			initialize();
		}

		protected function initialize(r:Number = 8):void
		{
			var geometry:SphereGeometry = new SphereGeometry(r);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(new MoonTexture().bitmapData));
			var mesh:Mesh = new Mesh(geometry, material);
			mesh.name = "MeshMoon";
			addChild(mesh);
		}
	}
}
