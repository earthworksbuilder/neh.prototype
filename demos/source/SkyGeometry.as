package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	
	public class SkyGeometry extends ObjectContainer3D
	{
		[Embed(source="/../embeds/milky-way.jpg")]
		protected const SkyTexture:Class;
		
		public function SkyGeometry()
		{
			super();
			initialize();
		}
		
		protected function initialize(r:Number=999):void
		{
			var geometry:SphereGeometry = new SphereGeometry(r);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(new SkyTexture().bitmapData));
			material.bothSides = true;
			
			var mesh:Mesh = new Mesh(geometry, material);
			addChild(mesh);
		}
	}
}