package mteb.data.input
{
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.FrameEntered;
	import mteb.data.time.ITime;


	public class UserOrientationTransform implements IOrientationTransform, ISignalReceiver
	{
		protected var _initialValue:Matrix3D = new Matrix3D();
		protected var _spinRate:Number = 45; // degrees / sec

		protected const keysDown:Vector.<Boolean> = new <Boolean>[false, false, false, false];
		protected const pitch:Matrix3D = new Matrix3D(); // looking up / down
		protected var updatesMade:Boolean = false;
		protected const xform:Matrix3D = new Matrix3D(); // composite result
		protected const yaw:Matrix3D = new Matrix3D(); // looking left / right


		public function UserOrientationTransform()
		{
			yaw.identity();
			pitch.identity();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(FrameEntered, this);
		}

		public function get initialValue():Matrix3D  { return _initialValue.clone(); }

		public function set initialValue(value:Matrix3D):void
		{
			_initialValue = value.clone();
			updatesMade = true;
		}

		public function onKeyDown(e:KeyboardEvent):void  { setKey(e.keyCode, true); }

		public function onKeyUp(e:KeyboardEvent):void  { setKey(e.keyCode, false); }

		public function receive(signal:ISignal, authority:* = null):void
		{
			if (signal is FrameEntered)
			{
				const time:ITime = authority as ITime;
				update(time.secondsElapsed);
			}
		}

		public function get spinRate():Number  { return _spinRate; }

		public function set spinRate(value:Number):void  { _spinRate = value; }

		public function get value():Matrix3D
		{
			if (updatesMade)
			{
				xform.identity();
				xform.prepend(_initialValue);
				xform.prepend(pitch);
				xform.append(yaw);

				updatesMade = false;
			}

			return xform.clone();
		}

		protected function adjustPitch(value:Number):void
		{
			pitch.prependRotation(value, Vector3D.X_AXIS);
			updatesMade = true;
		}

		protected function adjustYaw(value:Number):void
		{
			yaw.prependRotation(value, Vector3D.Y_AXIS);
			updatesMade = true;
		}

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

		protected function update(secondsElapsed:Number):void
		{
			const degrees:Number = spinRate * secondsElapsed;

			if (keysDown[0])
				adjustPitch(-degrees);
			if (keysDown[1])
				adjustPitch(+degrees);
			if (keysDown[2])
				adjustYaw(-degrees);
			if (keysDown[3])
				adjustYaw(+degrees);
		}
	}
}
