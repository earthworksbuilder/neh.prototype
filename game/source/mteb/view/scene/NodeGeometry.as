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
		public static const NEGX:uint = 1;
		public static const NEGY:uint = 3;
		public static const NEGZ:uint = 5;
		public static const POSX:uint = 0;
		public static const POSY:uint = 2;
		public static const POSZ:uint = 4;

		protected var negXTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected var negYTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected var negZTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected var posXTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected var posYTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));
		protected var posZTexture:BitmapTexture = new BitmapTexture(new BitmapData(16, 16));


		public function NodeGeometry()
		{
			super();
			initialize();
		}

		public function setTextureData(bitmapData:BitmapData, index:uint):void
		{
			switch (index)
			{
				case POSX:
					posXTexture.bitmapData = bitmapData;
					break;

				case NEGX:
					negXTexture.bitmapData = bitmapData;
					break;

				case POSY:
					posYTexture.bitmapData = bitmapData;
					break;

				case NEGY:
					negYTexture.bitmapData = bitmapData;
					break;

				case POSZ:
					posZTexture.bitmapData = bitmapData;
					break;

				case NEGZ:
					negZTexture.bitmapData = bitmapData;
					break;
			}
		}

		protected function createTexturedPlane(dim:Number, bitmapTexture:BitmapTexture, horizontal:Boolean):Mesh
		{
			var seg:uint = 1;

			var geo:PlaneGeometry = new PlaneGeometry(dim, dim, seg, seg, horizontal);
			var mat:TextureMaterial = new TextureMaterial(bitmapTexture);
			mat.alphaBlending = true;

			var mesh:Mesh = new Mesh(geo, mat);
			mesh.mouseEnabled = true;
			mesh.mouseHitMethod = MouseHitMethod.MESH_CLOSEST_HIT;
			return mesh;
		}

		protected function initialize(r:Number = 50):void
		{
			var posZMesh:Mesh = createTexturedPlane(r * 2, posZTexture, false);
			posZMesh.name = "POSZ";
			posZMesh.translate(Vector3D.Z_AXIS, r);

			var negZMesh:Mesh = createTexturedPlane(r * 2, negZTexture, false);
			negZMesh.name = "NEGZ";
			negZMesh.rotationY = 180;
			negZMesh.translate(Vector3D.Z_AXIS, -r);

			var posXMesh:Mesh = createTexturedPlane(r * 2, posXTexture, false);
			posXMesh.name = "POSX";
			posXMesh.rotationY = 90;
			posXMesh.translate(Vector3D.X_AXIS, r);

			var negXMesh:Mesh = createTexturedPlane(r * 2, negXTexture, false);
			negXMesh.name = "NEGX";
			negXMesh.rotationY = -90;
			negXMesh.translate(Vector3D.X_AXIS, -r);

			addChildren(posZMesh, negZMesh, posXMesh, negXMesh);
		}
	}
}
