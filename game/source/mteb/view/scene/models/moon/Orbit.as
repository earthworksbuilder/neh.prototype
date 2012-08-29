package mteb.view.scene.models.moon
{
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;

	import mteb.control.SignalBus;
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.control.gamestate.MCP;
	import mteb.control.signals.RiseStarted;
	import mteb.control.signals.SetStarted;
	import mteb.data.DataLocator;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.orbit.Ephemeris;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;
	import mteb.util.slerp;
	import mteb.view.scene.models.compass.CompassLightEnum;


	public class Orbit extends ObjectContainer3D implements ITimeDriven
	{
		/** How many degrees per second the subject moves */
		public var degreesPerSecond:Number = 360 / (24.88 * 60 * 60); // 24.88hrs for one revolution; see http://www.astronomycafe.net/qadir/q1038.html

		protected const TO_DEGREES:Number = Math.PI / 180.0;
		protected const TO_RADIANS:Number = 180 / Math.PI;

		protected const RISE_ANGLE:Number = 10;
		protected const SET_ANGLE:Number = 160;

		protected const riseStarted:RiseStarted = new RiseStarted();
		protected const setStarted:SetStarted = new SetStarted();

		protected var isMax:Boolean = false;
		protected var isMoving:Boolean = false;
		protected var rise:Vector3D;
		protected var transit:Vector3D;
		protected var set:Vector3D;
		protected var underTransit:Vector3D;

		protected var subject:ObjectContainer3D;
		protected var orbitalRadius:Number;

		protected var a:Number = 0;
		protected var d:uint = 0;
		protected var dInc:int = 1;


		public function Orbit()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(riseStarted as ISignal);
			signalBus.addSignal(setStarted as ISignal);
		}

		public function get day():uint  { return d; }

		public function set day(value:uint):void
		{
			if (value > Ephemeris.NUM_DAYS - 1)
				throw new ArgumentError("index '" + value + "' out of range (" + (Ephemeris.NUM_DAYS - 1) + ")");

			d = value;

			rise = isMax ? Ephemeris.getMaxRisePosition(d, orbitalRadius) : Ephemeris.getMinRisePosition(d, orbitalRadius);
			transit = isMax ? Ephemeris.getMaxTransitPosition(d, false, orbitalRadius) : Ephemeris.getMinTransitPosition(d, false, orbitalRadius);
			set = isMax ? Ephemeris.getMaxSetPosition(d, orbitalRadius) : Ephemeris.getMinSetPosition(d, orbitalRadius);
			underTransit = isMax ? Ephemeris.getMaxTransitPosition(d, true, orbitalRadius) : Ephemeris.getMinTransitPosition(d, true, orbitalRadius);
		}

		public function gotoFirstPosition():void
		{
			day = Ephemeris.NUM_DAYS - 1;
			dInc = -1;
			a = RISE_ANGLE;
			announceRise(d);
			setPosition();
		}

		public function get moving():Boolean  { return isMoving; }

		public function set moving(value:Boolean):void  { isMoving = value; }

		public function onTimeElapsed(time:ITime):void
		{
			if (!isMoving)
				return;

			const aInc:Number = degreesPerSecond * time.secondsElapsedScaled;

			if ((a < SET_ANGLE) && (a + aInc >= SET_ANGLE))
			{
				announceTravelCompleted();
				announceSet(d);
			}
			else if ((a < RISE_ANGLE) && (a + aInc >= RISE_ANGLE))
			{
				announceTravelCompleted();
				announceRise(d + dInc);
			}

			a += aInc;
			if (a >= 360)
			{
				a %= 360;
				d += dInc;
				if (d == Ephemeris.NUM_DAYS - 1)
					dInc = -1;
				else if (d == 0)
					dInc = 1;
				day = d;
			}

			setPosition();
		}

		public function setSubject(value:ObjectContainer3D, distance:Number, scale:Number = 1):void
		{
			subject = value;
			addChild(subject);
			orbitalRadius = distance;
		}

		public function get subjectPosition():Vector3D
		{
			return position;
		}

		protected function announceRise(index:uint):void
		{
			isMoving = false;

			riseStarted.pointIndex = index;
			riseStarted.pointState = CompassLightEnum.ACTIVATED;
			debug(this, "announceRise() - day: {0}, state: {1}", riseStarted.pointIndex, riseStarted.pointState);

			const announcement:IProtectedSignal = riseStarted as IProtectedSignal;
			const authority:ICompassLightStateProvider = riseStarted as ICompassLightStateProvider;
			announcement.send(authority);
		}

		protected function announceSet(index:uint):void
		{
			isMoving = false;

			setStarted.pointIndex = index;
			setStarted.pointState = CompassLightEnum.ACTIVATED;
			debug(this, "announceSet() - day: {0}, state: {1}", setStarted.pointIndex, setStarted.pointState);

			const announcement:IProtectedSignal = setStarted as IProtectedSignal;
			const authority:ICompassLightStateProvider = setStarted as ICompassLightStateProvider;
			announcement.send(authority);
		}

		protected function announceTravelCompleted():void
		{
			const mcp:IGameStateMachine = DataLocator.getInstance().mcp;
			mcp.onMoonTravelCompleted();
		}

		protected function setPosition():void
		{
			const t:Number = a / 360;

			if (t < .5)
				position = slerp(slerp(rise, transit, t), slerp(transit, set, t + .5), t * 2);
			else
				position = slerp(slerp(set, underTransit, t - .5), slerp(underTransit, rise, t), (t - .5) * 2);
		}
	}
}
