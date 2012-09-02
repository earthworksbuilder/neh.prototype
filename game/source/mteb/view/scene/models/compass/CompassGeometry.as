package mteb.view.scene.models.compass
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;

	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;
	import mteb.view.scene.models.GeometryFactory;


	public class CompassGeometry extends ObjectContainer3D
	{
		protected const meshTexture:BitmapTexture = new BitmapTexture(Textures.compassTextureBitmap.bitmapData);


		public function CompassGeometry()
		{
			super();
			initialize();
		}

		public function get texture():BitmapData
		{
			return meshTexture.bitmapData;
		}

		public function set texture(value:BitmapData):void
		{
			meshTexture.bitmapData = value.clone();
		}

		protected function initialize(r:Number = 200):void
		{
			const mesh:Mesh = GeometryFactory.createPlane(meshTexture, r, r, 10, true, false, true, PickingColliderType.AS3_FIRST_ENCOUNTERED);
			mesh.name = "Compass";
			mesh.material.blendMode = BlendMode.ADD;
			addChild(mesh);
		}
	}
}
