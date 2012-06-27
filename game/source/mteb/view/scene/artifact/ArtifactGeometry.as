package mteb.view.scene.artifact
{
	import flash.display.BitmapData;

	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;
	import mteb.data.map.IArtifact;
	import mteb.view.scene.GeometryFactory;


	public class ArtifactGeometry extends Mesh implements IArtifact
	{

		protected const namePrefix:String = "Artifact ";
		protected var _id:uint = 0;
		protected var texture:BitmapTexture;


		public function ArtifactGeometry(which:uint)
		{
			_id = which;

			texture = new BitmapTexture(artifactBitmapData);
			const r:Number = 32;
			const geometry:PlaneGeometry = new PlaneGeometry(r, r, 1, 1, false);
			const material:TextureMaterial = GeometryFactory.createTextureMaterial(texture, false, true);

			super(geometry, material);

			name = namePrefix + _id;
			mouseEnabled = true;
			mouseHitMethod = MouseHitMethod.MESH_ANY_HIT;
		}

		public function changeId(value:uint):void
		{
			_id = value;
			name = namePrefix + _id;
			texture.bitmapData = artifactBitmapData;
		}

		public function get id():uint  { return _id; }

		public function get index():uint  { return _id - 1; }

		protected function get artifactBitmapData():BitmapData
		{
			var bitmapData:BitmapData;

			switch (_id)
			{
				case 1:
					bitmapData = Textures.artifact1TextureBitmap.bitmapData;
					break;

				case 2:
					bitmapData = Textures.artifact2TextureBitmap.bitmapData;
					break;

				case 3:
					bitmapData = Textures.artifact3TextureBitmap.bitmapData;
					break;

				case 4:
					bitmapData = Textures.artifact4TextureBitmap.bitmapData;
					break;

				default:
					throw new ArgumentError("artifact must be constructed with 1,2,3 or 4 (got " + _id + ")");
			}

			return bitmapData;
		}
	}
}
