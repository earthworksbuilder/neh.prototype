package mteb.view.scene.models.moon
{
	import flash.geom.Point;

	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.tools.helpers.LightsHelper;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.control.signals.ArtifactChanged;
	import mteb.control.signals.MoonClicked;
	import mteb.data.DataLocator;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.time.ITime;
	import mteb.view.scene.models.compass.CompassLightEnum;


	public class Moon implements IMoon, ISignalReceiver
	{

		protected static const _geo:MoonGeometry = new MoonGeometry();
		protected static const _lights:Vector.<LightBase> = createLights();

		protected static function createLights():Vector.<LightBase>
		{
			// simple two-point light setup: key, fill
			const key:DirectionalLight = new DirectionalLight(.5, -1, .75);
			key.color = 0xffffff;
			key.ambient = 0;
			key.ambientColor = 0xeeeeff;
			key.diffuse = .75;
			key.specular = .1;

			const fill:DirectionalLight = new DirectionalLight(-1, .5, .75);
			fill.color = 0xffffff;
			fill.ambient = 0;
			fill.diffuse = .25;
			fill.specular = 0;

			const lights:Vector.<LightBase> = new <LightBase>[key, fill];
			return lights;
		}

		protected const moonClicked:IProtectedSignal = new MoonClicked();

		protected var _state:MoonStateEnum = MoonStateEnum.WAITING;


		public function Moon()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(moonClicked as ISignal);
			signalBus.addReceiver(ArtifactChanged, this);

			// apply lighting to geometry
			LightsHelper.addStaticLightsToMaterials(_geo, _lights);
		}

		public function get geometry():Mesh
		{
			return _geo as Mesh;
		}

		public function get lights():Vector.<LightBase>
		{
			return _lights;
		}

		public function onClicked(screenCoords:Point):void
		{
			debug(this, "onClicked() - {0} moon clicked (screen coords: {1})", _state, screenCoords);
			moonClicked.send(screenCoords);

			const mcp:IGameStateMachine = DataLocator.getInstance().mcp;
			switch (_state)
			{
				case MoonStateEnum.ACTIVATED:
					debug(this, "onClicked() - moon captured! TODO: which rise or set is it? tell mcp");
					_state = MoonStateEnum.TRAVELING;
					break;
			}
		}

		public function onTimeElapsed(time:ITime):void
		{
			switch (_state)
			{
				case MoonStateEnum.ACTIVATED:
					_geo.scaleX = _geo.scaleY = _geo.scaleZ = 1.00 + (.03 * Math.sin(5 * time.secondsTotal));
					_geo.alpha = .90 + (.10 * Math.cos(7 * time.secondsTotal));
					break;
			}
		}

		public function get radius():Number
		{
			return _geo.radius;
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is ArtifactChanged):
					onArtifactChanged(authority as ICompassLightStateProvider);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		public function get state():MoonStateEnum
		{
			return _state;
		}

		protected function onArtifactChanged(authority:ICompassLightStateProvider):void
		{
			switch (authority.pointState)
			{
				case CompassLightEnum.ACTIVATED:
					debug(this, "onArtifactChanged() - activate moon!");
					_lights[0].ambient = 1;
					_state = MoonStateEnum.ACTIVATED;
					break;

				default:
					debug(this, "onArtifactChanged() - state: {0}", authority.pointState);
					_lights[0].ambient = 0;
					_state = MoonStateEnum.WAITING;
					break;
			}
		}
	}
}
