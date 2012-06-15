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
	import mteb.control.signals.PreferencesChanged;
	import mteb.data.config.IConfig;
	import mteb.data.time.ITime;


	public class UserOrientationTransform implements IOrientationTransform, ISignalReceiver
	{
		protected var _initialValue:Matrix3D = new Matrix3D();
		protected var _spinRate:Number = 45; // degrees / sec
		protected var _moveRate:Number = 300; // model units / sec

		protected const keysDown:Vector.<Boolean> = new <Boolean>[false, false, false, false, false];
		protected const yaw:Matrix3D = new Matrix3D(); // looking left / right
		protected const pitch:Matrix3D = new Matrix3D(); // looking up / down
		protected const offset:Matrix3D = new Matrix3D(); // dolly / pan
		protected const xform:Matrix3D = new Matrix3D(); // composite result
		protected var updatesMade:Boolean = false;


		public function UserOrientationTransform()
		{
			yaw.identity();
			pitch.identity();
			offset.identity();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(PreferencesChanged, this);
		}

		public function get initialValue():Matrix3D  { return _initialValue.clone(); }

		public function set initialValue(value:Matrix3D):void
		{
			_initialValue = value.clone();
			updatesMade = true;
		}

		public function get moveRate():Number  { return _moveRate; }

		public function set moveRate(value:Number):void
		{
			if (value != _moveRate)
			{
				debug(this, "set moveRate to {0}", value);
				_moveRate = value;
			}
		}

		public function onKeyDown(e:KeyboardEvent):void  { setKey(e.keyCode, true); }

		public function onKeyUp(e:KeyboardEvent):void  { setKey(e.keyCode, false); }

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is FrameEntered):
					const time:ITime = authority as ITime;
					update(time.secondsElapsed);
					break;

				case (signal is PreferencesChanged):
					onPreferencesChanged(authority as IConfig);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		public function get spinRate():Number  { return _spinRate; }

		public function set spinRate(value:Number):void
		{
			if (value != _spinRate)
			{
				debug(this, "set spinRate to {0}", value);
				_spinRate = value;
			}
		}

		public function get value():Matrix3D
		{
			if (updatesMade)
			{
				xform.identity();
				xform.append(_initialValue);
				xform.append(offset);
				xform.append(pitch);
				xform.append(yaw);

				updatesMade = false;
			}

			return xform.clone();
		}

		protected function adjustOffset(truck:Number, pedestal:Number, dolly:Number):void
		{
			offset.appendTranslation(truck, pedestal, dolly);
			updatesMade = true;
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

		protected function onPreferencesChanged(config:IConfig):void
		{
			moveRate = config.moveRate;
			spinRate = config.spinRate;
		}

		protected function setKey(keyCode:uint, value:Boolean):void
		{
			switch (keyCode)
			{
				case Keyboard.SHIFT:
					keysDown[4] = value;
					break;

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
			const moving:Boolean = keysDown[4];
			const delta:Number = (moving ? moveRate : spinRate) * secondsElapsed;

			if (keysDown[0])
				moving ? adjustOffset(0, 0, +delta) : adjustPitch(-delta);
			if (keysDown[1])
				moving ? adjustOffset(0, 0, -delta) : adjustPitch(+delta);
			if (keysDown[2])
				moving ? adjustOffset(-delta, 0, 0) : adjustYaw(-delta);
			if (keysDown[3])
				moving ? adjustOffset(+delta, 0, 0) : adjustYaw(+delta);
		}
	}
}
