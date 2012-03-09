package
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;


	public class UserTransform
	{
		protected var _spinRate:Number;
		protected var keysDown:Vector.<Boolean> = new <Boolean>[false, false, false, false];
		protected var pitch:Matrix3D = new Matrix3D(); // looking up / down
		protected var start:Matrix3D; // initial value
		protected var xform:Matrix3D = new Matrix3D(); // composite result
		protected var yaw:Matrix3D = new Matrix3D(); // looking left / right


		public function UserTransform(stage:Stage, initialValue:Matrix3D = null, spinRate:Number = .942)
		{
			start = initialValue ? initialValue.clone() : new Matrix3D();
			_spinRate = spinRate;

			yaw.identity();
			pitch.identity();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public function get spinRate():Number  { return _spinRate; }

		public function set spinRate(value:Number):void  { _spinRate = value; }

		public function update():void
		{
			if (keysDown[0])
				adjustPitch(-spinRate);
			if (keysDown[1])
				adjustPitch(+spinRate);
			if (keysDown[2])
				adjustYaw(-spinRate);
			if (keysDown[3])
				adjustYaw(+spinRate);
		}

		public function get value():Matrix3D
		{
			xform.identity();
			xform.prepend(start);
			xform.prepend(pitch);
			xform.append(yaw);
			return xform;
		}

		protected function adjustPitch(value:Number):void  { pitch.prependRotation(value, Vector3D.X_AXIS); }

		protected function adjustYaw(value:Number):void  { yaw.prependRotation(value, Vector3D.Y_AXIS); }

		protected function onKeyDown(e:KeyboardEvent):void  { setKey(e.keyCode, true); }

		protected function onKeyUp(e:KeyboardEvent):void  { setKey(e.keyCode, false); }

		protected function setKey(keyCode:uint, value:Boolean):void
		{
			switch (keyCode)
			{
				case Keyboard.UP:
					keysDown[0] = value;
					break;
				case Keyboard.DOWN:
					keysDown[1] = value;
					break;
				case Keyboard.LEFT:
					keysDown[2] = value;
					break;
				case Keyboard.RIGHT:
					keysDown[3] = value;
					break;
			}
		}
	}
}
