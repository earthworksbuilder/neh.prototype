package mteb.view.scene
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.raycast.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;


	use namespace arcane;


	public class SkyGeometry extends ObjectContainer3D
	{
		[Embed(source="/../embeds/starfield-2048x1024-marked.png")]
		protected const SkyTexture:Class;

		protected const SPIN:Matrix3D = new Matrix3D();
		protected const TILT:Matrix3D = new Matrix3D();
		protected const SHIFT:Matrix3D = new Matrix3D();

		protected var _spin:Number = 0;
		protected var _tilt:Number = 0;
		protected var _shift:Number = 0;


		public function SkyGeometry()
		{
			super();
			initialize();
		}

		public function get shift():Number
		{
			return _shift;
		}

		public function set shift(value:Number):void
		{
			_shift = value;
			SHIFT.identity();
			SHIFT.appendRotation(_shift, Vector3D.Y_AXIS);

			super.arcane::invalidateTransform();
		}

		public function get spin():Number
		{
			return _spin;
		}

		public function set spin(value:Number):void
		{
			_spin = value;
			SPIN.identity();
			SPIN.appendRotation(_spin, Vector3D.Y_AXIS);

			super.arcane::invalidateTransform();
		}

		public function get tilt():Number
		{
			return _tilt;
		}

		public function set tilt(value:Number):void
		{
			_tilt = value;
			TILT.identity();
			TILT.appendRotation(_tilt, Vector3D.X_AXIS);

			super.arcane::invalidateTransform();
		}

		protected function initialize(r:Number = 2048):void
		{
			var geometry:SphereGeometry = new SphereGeometry(r);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(new SkyTexture().bitmapData));
			material.bothSides = true;

			var mesh:Mesh = new Mesh(geometry, material);
			mesh.name = "MeshSky";
			mesh.mouseEnabled = true;
			mesh.mouseHitMethod = MouseHitMethod.MESH_ANY_HIT;
			addChild(mesh);
		}

		override protected function updateTransform():void
		{
			super.updateTransform();
			transform.append(SPIN);
			transform.append(TILT);
			transform.append(SHIFT);
		}
	}
}
