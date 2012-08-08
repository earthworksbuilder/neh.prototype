package mteb.view.scene.models.moon
{
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;
	import mteb.view.scene.models.GeometryFactory;


	public class MoonGeometry extends Mesh
	{
		private var _radius:Number = 64;
		private var _material:TextureMaterial;


		public function MoonGeometry()
		{
			const texture:BitmapTexture = new BitmapTexture(Textures.moonTextureBitmap.bitmapData);
			const geometry:SphereGeometry = new SphereGeometry(_radius);
			const material:TextureMaterial = GeometryFactory.createTextureMaterial(texture, false, true);

			super(geometry, material);
			_material = material;

			name = "MeshMoon";
			mouseEnabled = true;
			pickingCollider = PickingColliderType.BOUNDS_ONLY;
		}

		public function get alpha():Number  { return _material.alpha; }

		public function set alpha(value:Number):void  { _material.alpha = value; }

		public function get radius():Number  { return _radius; }
	}
}
