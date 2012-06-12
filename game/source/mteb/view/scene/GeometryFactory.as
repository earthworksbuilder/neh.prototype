package mteb.view.scene
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;


	public final class GeometryFactory
	{


		public static function createBox(texture:BitmapTexture, width:Number = 256, height:Number = 256, depth:Number = 256, bothSides:Boolean = false, alphaBlending:Boolean = false, hitMethod:int = -1):Mesh
		{
			const geometry:CubeGeometry = new CubeGeometry(width, height, depth);
			const material:TextureMaterial = createTextureMaterial(texture, bothSides, alphaBlending);

			return createMesh(geometry, material, hitMethod);
		}

		public static function createMesh(geometry:Geometry, material:MaterialBase, hitMethod:int = -1):Mesh
		{
			const mesh:Mesh = new Mesh(geometry, material);

			if (hitMethod > -1)
			{
				mesh.mouseEnabled = true;
				mesh.mouseHitMethod = hitMethod;
			}

			return mesh;
		}

		public static function createPlane(texture:BitmapTexture, width:Number = 256, height:Number = 256, segments:uint = 1, horizontal:Boolean = false, bothSides:Boolean = false, alphaBlending:Boolean = false, hitMethod:int = -1):Mesh
		{
			const geometry:PlaneGeometry = new PlaneGeometry(width, height, segments, segments, horizontal);
			const material:TextureMaterial = createTextureMaterial(texture, bothSides, alphaBlending);

			return createMesh(geometry, material, hitMethod);
		}

		public static function createSphere(texture:BitmapTexture, radius:Number = 256, bothSides:Boolean = false, alphaBlending:Boolean = false, hitMethod:int = -1):Mesh
		{
			const geometry:SphereGeometry = new SphereGeometry(radius);
			const material:TextureMaterial = createTextureMaterial(texture, bothSides, alphaBlending);

			return createMesh(geometry, material, hitMethod);
		}

		public static function createTextureMaterial(texture:BitmapTexture, bothSides:Boolean = false, alphaBlending:Boolean = false):TextureMaterial
		{
			const material:TextureMaterial = new TextureMaterial(texture);
			material.bothSides = bothSides;
			material.alphaBlending = alphaBlending;

			return material;
		}
	}
}
