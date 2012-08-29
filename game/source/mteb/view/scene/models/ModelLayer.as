package mteb.view.scene.models
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;
	import away3d.lights.LightBase;
	import away3d.tools.utils.Ray;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.control.signals.ActionTriggered;
	import mteb.control.signals.ArtifactCollected;
	import mteb.control.signals.AzimuthChanged;
	import mteb.control.signals.NodeChanged;
	import mteb.control.signals.PreferencesChanged;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.data.config.IConfig;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.ActionTypeEnum;
	import mteb.data.map.IArtifact;
	import mteb.data.map.IAzimuthProvider;
	import mteb.data.map.IMap;
	import mteb.data.map.Node;
	import mteb.data.orbit.Ephemeris;
	import mteb.data.player.IInventory;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;
	import mteb.util.uintToString;
	import mteb.view.scene.models.artifact.ArtifactGeometry;
	import mteb.view.scene.models.compass.CompassControl;
	import mteb.view.scene.models.ground.BitmapCubeLoader;
	import mteb.view.scene.models.ground.NodeGeometry;
	import mteb.view.scene.models.ground.SkyBoxFaceEnum;
	import mteb.view.scene.models.moon.IMoon;
	import mteb.view.scene.models.moon.Moon;
	import mteb.view.scene.models.moon.MoonTrail;
	import mteb.view.scene.models.moon.Orbit;
	import mteb.view.scene.models.sky.SkyGeometry;


	public class ModelLayer extends Sprite implements ISignalReceiver, IAzimuthProvider, ITimeDriven
	{
		protected var STARTING_AZIMUTH:Number; // azimuth of initial node view
		protected const TO_DEGREES:Number = 180 / Math.PI;
		protected const RAY:Ray = new Ray();

		protected const azimuthChanged:IProtectedSignal = new AzimuthChanged();
		protected const actionTriggered:IProtectedSignal = new ActionTriggered();
		protected const artifactCollected:IProtectedSignal = new ArtifactCollected();

		protected const dataLocator:IDataLocator = DataLocator.getInstance();
		protected const mcp:IGameStateMachine = dataLocator.mcp;
		protected const bitmapCubeLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const hotSpotLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const actionTrigger:ActionTrigger = new ActionTrigger();

		protected var artifactGeo:ArtifactGeometry;
		protected const groundGeo:NodeGeometry = new NodeGeometry();
		protected const skyGeo:SkyGeometry = new SkyGeometry();
		protected const moonOrbit:Orbit = new Orbit();
		protected const moon:IMoon = new Moon();
		protected const moonTrail:MoonTrail = new MoonTrail();
		protected const moonTrailFrameSkip:uint = 4;
		protected const compassControl:ObjectContainer3D = new CompassControl();
		protected const sceneGeo:ObjectContainer3D = new ObjectContainer3D();
		protected const view:View3D = new View3D();

		protected var moonTrailFrame:uint = moonTrailFrameSkip;
		protected var lastAzimuth:Number;


		public function ModelLayer()
		{
			super();
		}

		public function get currentAzimuth():Number
		{
			return lastAzimuth;
		}

		public function initialize():void
		{
			STARTING_AZIMUTH = Ephemeris.northMaxRise;
			initScene();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(azimuthChanged as ISignal);
			signalBus.addSignal(actionTriggered as ISignal);
			signalBus.addSignal(artifactCollected as ISignal);
			signalBus.addReceiver(NodeChanged, this);
			signalBus.addReceiver(PreferencesChanged, this);
		}

		public function onTimeElapsed(time:ITime):void
		{
			// bail if textures aren't ready
			if (!bitmapCubeLoader.isLoaded || !hotSpotLoader.isLoaded)
				return;

			// apply current user rotations
			view.camera.transform = dataLocator.look.value;

			// spin the sky
			skyGeo.onTimeElapsed(time);

			// revolve the moon
			moonOrbit.onTimeElapsed(time);
			if (--moonTrailFrame == 0)
			{
				moonTrail.setNextPoint(moon.geometry.scenePosition);
				moonTrailFrame = moonTrailFrameSkip;
			}
			moon.onTimeElapsed(time);

			// compute azimuth and send notification of any change
			setAzimuth(computeAzimuth());

			// render the view
			view.render();
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is NodeChanged):
					onNodeChanged(authority as IMap);
					break;

				case (signal is PreferencesChanged):
					onPreferencesChanged(authority as IConfig);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		public function get view3D():View3D  { return view; }

		protected function addArtifact():void
		{
			debug(this, "addArtifact() - setting position, adding child and event listener");
			// TODO: add tween to reveal by fade-in
			artifactGeo.position = new Vector3D(0, -32, 100);
			artifactGeo.addEventListener(MouseEvent3D.CLICK, onArtifactClicked);
			sceneGeo.addChild(artifactGeo);
		}

		protected function computeAzimuth():Number
		{
			var a:Number;
			const forward:Vector3D = view.camera.forwardVector;
			const ry:Number = view.camera.rotationY;

			if (forward.x >= 0)
			{
				if (forward.z >= 0)
					a = ry;
				else
					a = 180 - ry;
			}
			else
			{
				if (forward.z < 0)
					a = 180 - ry;
				else
					a = 360 + ry;
			}

			return (a + STARTING_AZIMUTH) % 360;
		}

		protected function initScene():void
		{
			debug(this, "initScene()");

			// configure viewport and add it to the stage
			view.backgroundColor = 0x333333;
			view.camera.lens.far = 1024 * 8;
			addChild(view);

			// set camera at origin
			view.camera.position = new Vector3D(0, 0, 0);
			view.camera.lookAt(new Vector3D(0, 0, 50));
			view.camera.rotationX = -19;
			dataLocator.look.initialValue = view.camera.transform;

			// add geometry to the scene
			skyGeo.tilt = -55; // align polaris for our north america position
			skyGeo.shift = -227;

			moonOrbit.setSubject(moon.geometry, 1024 + 512);
			moonOrbit.gotoFirstPosition();

			sceneGeo.addChildren(skyGeo, groundGeo, moonOrbit, moonTrail, compassControl);
			view.scene.addChild(sceneGeo);

			// add event handlers for interactive geo
			//moon.geometry.addEventListener(MouseEvent3D.CLICK, onMoonClicked);
			groundGeo.addEventListener(MouseEvent3D.CLICK, onGroundClicked);

			// add lights to the scene (assuming lights already associated to appropriate geo)
			const lights:Vector.<LightBase> = moon.lights;
			for (var i:uint = 0; i < lights.length; i++)
				view.scene.addChild(lights[i]);
		}

		protected function onArtifactClicked(event:MouseEvent3D):void
		{
			const artifactGeo:ArtifactGeometry = event.object as ArtifactGeometry;
			debug(this, "onArtifactClicked() - {0} (index {1}); removing from node and announcing collected", artifactGeo.name, artifactGeo.index);

			removeArtifact();

			const artifact:IArtifact = artifactGeo as IArtifact;
			mcp.onArtifactCollected(artifact);
		}

		protected function onGroundClicked(event:MouseEvent3D):void
		{
			const object3d:Object3D = event.object;
			const index:int = SkyBoxFaceEnum.fromString(object3d.name).index;
			const uv:Point = event.uv;

			var clickedPixel:uint = hotSpotLoader.getUvColorAt(index, uv, true);
			var clickedAlpha:uint = (clickedPixel >> 24) & 0xff;
			var clickedColor:uint = clickedPixel & 0x00ffffff;
			if (clickedAlpha > 0)
			{
				const map:IMap = dataLocator.map;
				const node:Node = map.currentNode;
				actionTrigger.type = ActionTypeEnum.JUMP_TO_NODE;
				actionTrigger.nodeId = null;
				actionTrigger.hotSpotColor = clickedColor;

				debug(this, "onGroundClicked() - N{0}.{1} ({2}, {3}) {4}", node.id, object3d.name, uv.x.toFixed(3), uv.y.toFixed(3), uintToString(clickedColor));
				actionTriggered.send(actionTrigger);
			}
			else
			{
				clickedPixel = bitmapCubeLoader.getUvColorAt(index, uv, true);
				clickedAlpha = (clickedPixel >> 24) & 0xff;
				if (clickedAlpha < 10)
				{
					debug(this, "onGroundClicked() - pass-thru to sky");
					onSkyClicked(event);
				}
				else
					debug(this, "onGroundClicked() - no-op. clickedAlpha = {0} ({1}%)", clickedAlpha, Math.round(clickedAlpha / 255 * 100));
			}
		}

		protected function onHotspotsLoaded():void
		{
			if (!hotSpotLoader.isLoaded)
				return error(this, "onHotspotsLoaded() - there was an error loading the hotspots");

			debug(this, "onHotspotsLoaded() - currentNode hotspots are loaded.");
			if (!bitmapCubeLoader.isLoaded)
				return debug(this, "onHotspotsLoaded() - still waiting for textures...");

			updateTextures();
		}

		protected function onMoonClicked(event:MouseEvent3D):void
		{
			debug(this, "onMoonClicked() - asking moon to move; view: {0}, {1}; screen: {2}, {3}", view.mouseX, view.mouseY, event.screenX, event.screenY);
			const screenCoords:Point = new Point(view.mouseX, view.mouseY);
			moon.onClicked(screenCoords);
			moonOrbit.moving = true;
		}

		protected function onNodeChanged(map:IMap):void
		{
			mcp.onNodeTravelStarted();

			const node:Node = map.currentNode;
			hotSpotLoader.setUrls(node.hotspotPosX, node.hotspotNegX, node.hotspotPosY, node.hotspotNegY, node.hotspotPosZ, node.hotspotNegZ);
			hotSpotLoader.load(onHotspotsLoaded);
			bitmapCubeLoader.setUrls(node.texturePosX, node.textureNegX, node.texturePosY, node.textureNegY, node.texturePosZ, node.textureNegZ);
			bitmapCubeLoader.load(onTexturesLoaded);

			debug(this, "onNodeChanged() - map.currentNode is {0}; loading textures and hotspots...", node);
		}

		protected function onNodeTraveled():void
		{
			// remove old artifact, if any, and add new, if map indicates one
			const map:IMap = dataLocator.map;
			const node:Node = map.currentNode;

			removeArtifact();
			const inventory:IInventory = DataLocator.getInstance().inventory;
			if (node.hasArtifact)
			{
				if (inventory.hasArtifact(node.artifact))
					debug(this, "onNodeTraveled() - currentNode ({0}) had artifact {1}; player has already collected it", node.id, node.artifact);
				else
				{
					debug(this, "onNodeTraveled() - currentNode ({0}) has an artifact! Revealing artifact {1}...", node.id, node.artifact);
					if (!artifactGeo)
						artifactGeo = new ArtifactGeometry(node.artifact);
					else
						artifactGeo.changeId(node.artifact);
					addArtifact();
				}
			}
			else
				debug(this, "onNodeTraveled() - no artifact for this node.");

			DataLocator.getInstance().mcp.onNodeTravelCompleted();
		}

		protected function onPreferencesChanged(config:IConfig):void
		{
			const starsShowing:Boolean = sceneGeo.contains(skyGeo);
			debug(this, "onPreferencesChanged() - show stars? {0}, stars showing? {1}", config.showStars, starsShowing);

			if (config.showStars && !starsShowing)
				sceneGeo.addChild(skyGeo);
			else if (!config.showStars && starsShowing)
				sceneGeo.removeChild(skyGeo);
		}

		protected function onSkyClicked(event:MouseEvent3D):void
		{
			const ray:Vector3D = view.getRay(view.mouseX, view.mouseY);
			const isMoonClick:Boolean = RAY.intersectsSphere(view.camera.position, ray, moonOrbit.subjectPosition, moon.radius);

			if (isMoonClick)
			{
				debug(this, "onSkyClicked() - clicked the moon!; view: {0}, {1}; screen: {2}, {3}", view.mouseX, view.mouseY, event.screenX, event.screenY);
				onMoonClicked(event);
			}
			else
				debug(this, "onSkyClicked() - no-op; view: {0}, {1}; screen: {2}, {3}", view.mouseX, view.mouseY, event.screenX, event.screenY);
		}

		protected function onTexturesLoaded():void
		{
			if (!bitmapCubeLoader.isLoaded)
				return error(this, "onTexturesLoaded() - there was an error loading the textures");

			debug(this, "onTexturesLoaded() - currentNode textures are loaded.");
			if (!hotSpotLoader.isLoaded)
				return debug(this, "onTexturesLoaded() - still waiting for hotspots...");

			updateTextures();
		}

		protected function removeArtifact():void
		{
			if (artifactGeo && sceneGeo.contains(artifactGeo))
			{
				debug(this, "removeArtifact() - removing child and event listener");
				sceneGeo.removeChild(artifactGeo);
				artifactGeo.removeEventListener(MouseEvent3D.CLICK, onArtifactClicked);
			}
			else
				debug(this, "removeArtifact() - no artifact geo yet");
		}

		protected function setAzimuth(value:Number):void
		{
			if (value != lastAzimuth)
			{
				lastAzimuth = value;
				azimuthChanged.send(this);
			}
		}

		protected function updateTextures():void
		{
			debug(this, "updateTextures() - currentNode textures and hotspots are loaded; updating bitmapdata and updating game state");

			const showHotspots:Boolean = dataLocator.config.showHotspots;
			var bd:BitmapData;
			for (var i:uint = 0; i < 6; i++)
			{
				bd = bitmapCubeLoader.getBitmapDataAt(i);
				if (showHotspots)
					bd.copyPixels(hotSpotLoader.getBitmapDataAt(i), bd.rect, (new Point(0, 0)), null, null, true);
				groundGeo.setTextureData(bd, i);
			}

			onNodeTraveled();
		}
	}
}
