package mteb.view.scene.models.sky
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.textures.BitmapTexture;

	import mteb.assets.Textures;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;
	import mteb.view.scene.models.GeometryFactory;

	use namespace arcane;


	public class SkyGeometry extends ObjectContainer3D implements ITimeDriven
	{

		/** How many degrees per second the sky spins */
		public var speed:Number = 360 / (23.9345 * 60 * 60); // sidereal period of the Earth; see http://answers.yahoo.com/question/index?qid=20090923082900AAKT8ZK

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

		public function onTimeElapsed(time:ITime):void
		{
			//spin += speed * time.secondsElapsedScaled;
			spin += speed * time.secondsElapsedScaled / 10; // Hack: it was spinning to fast for people's stomachs.  This slows it down a bit. -- Chad Joan
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
			const texture:BitmapTexture = new BitmapTexture(Textures.skyTextureBitmap.bitmapData);
			const mesh:Mesh = GeometryFactory.createSphere(texture, r, true);
			mesh.name = "MeshSky";
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
