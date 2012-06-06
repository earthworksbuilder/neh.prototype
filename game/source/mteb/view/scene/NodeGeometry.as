package mteb.view.scene
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;


	public class NodeGeometry extends ObjectContainer3D
	{
		protected const posXTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected const negXTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected const posYTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected const negYTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected const posZTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected const negZTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));


		public function NodeGeometry()
		{
			super();
			initialize();
		}

		public function setTextureData(bitmapData:BitmapData, index:uint):void
		{
			switch (index)
			{
				case SkyBoxFaceEnum.POSX.index:
					posXTexture.bitmapData = bitmapData;
					break;

				case SkyBoxFaceEnum.NEGX.index:
					negXTexture.bitmapData = bitmapData;
					break;

				case SkyBoxFaceEnum.POSY.index:
					posYTexture.bitmapData = bitmapData;
					break;

				case SkyBoxFaceEnum.NEGY.index:
					negYTexture.bitmapData = bitmapData;
					break;

				case SkyBoxFaceEnum.POSZ.index:
					posZTexture.bitmapData = bitmapData;
					break;

				case SkyBoxFaceEnum.NEGZ.index:
					negZTexture.bitmapData = bitmapData;
					break;
			}
		}

		protected function initialize(r:Number = 1024):void
		{
			const d:Number = r + r;

			const posZMesh:Mesh = GeometryFactory.createPlane(posZTexture, d, d, 1, false, false, true, MouseHitMethod.MESH_CLOSEST_HIT);
			posZMesh.name = SkyBoxFaceEnum.POSZ.toString();
			posZMesh.translate(Vector3D.Z_AXIS, r);

			const negZMesh:Mesh = GeometryFactory.createPlane(negZTexture, d, d, 1, false, false, true, MouseHitMethod.MESH_CLOSEST_HIT);
			negZMesh.name = SkyBoxFaceEnum.NEGZ.toString();
			negZMesh.rotationY = 180;
			negZMesh.translate(Vector3D.Z_AXIS, -r);

			const posXMesh:Mesh = GeometryFactory.createPlane(posXTexture, d, d, 1, false, false, true, MouseHitMethod.MESH_CLOSEST_HIT);
			posXMesh.name = SkyBoxFaceEnum.POSX.toString();
			posXMesh.rotationY = 90;
			posXMesh.translate(Vector3D.X_AXIS, r);

			const negXMesh:Mesh = GeometryFactory.createPlane(negXTexture, d, d, 1, false, false, true, MouseHitMethod.MESH_CLOSEST_HIT);
			negXMesh.name = SkyBoxFaceEnum.NEGX.toString();
			negXMesh.rotationY = -90;
			negXMesh.translate(Vector3D.X_AXIS, -r);

			const negYMesh:Mesh = GeometryFactory.createPlane(negYTexture, d, d, 1, false, false, true, MouseHitMethod.MESH_CLOSEST_HIT);
			negYMesh.name = SkyBoxFaceEnum.NEGY.toString();
			negYMesh.rotationX = 90;
			negYMesh.translate(Vector3D.Y_AXIS, -r);

			addChildren(posZMesh, negZMesh, posXMesh, negXMesh, negYMesh);
		}
	}
}
