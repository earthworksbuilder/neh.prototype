package mteb.view.scene
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
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

		protected function createTexturedPlane(dim:Number, bitmapTexture:BitmapTexture, horizontal:Boolean):Mesh
		{
			const seg:uint = 1;

			const geo:PlaneGeometry = new PlaneGeometry(dim, dim, seg, seg, horizontal);
			const mat:TextureMaterial = new TextureMaterial(bitmapTexture);
			mat.alphaBlending = true;

			const mesh:Mesh = new Mesh(geo, mat);
			mesh.mouseEnabled = true;
			mesh.mouseHitMethod = MouseHitMethod.MESH_CLOSEST_HIT;

			return mesh;
		}

		protected function initialize(r:Number = 50):void
		{
			const posZMesh:Mesh = createTexturedPlane(r * 2, posZTexture, false);
			posZMesh.name = SkyBoxFaceEnum.POSZ.toString();
			posZMesh.translate(Vector3D.Z_AXIS, r);

			const negZMesh:Mesh = createTexturedPlane(r * 2, negZTexture, false);
			negZMesh.name = SkyBoxFaceEnum.NEGZ.toString();
			negZMesh.rotationY = 180;
			negZMesh.translate(Vector3D.Z_AXIS, -r);

			const posXMesh:Mesh = createTexturedPlane(r * 2, posXTexture, false);
			posXMesh.name = SkyBoxFaceEnum.POSX.toString();
			posXMesh.rotationY = 90;
			posXMesh.translate(Vector3D.X_AXIS, r);

			const negXMesh:Mesh = createTexturedPlane(r * 2, negXTexture, false);
			negXMesh.name = SkyBoxFaceEnum.NEGX.toString();
			negXMesh.rotationY = -90;
			negXMesh.translate(Vector3D.X_AXIS, -r);

			addChildren(posZMesh, negZMesh, posXMesh, negXMesh);
		}
	}
}
