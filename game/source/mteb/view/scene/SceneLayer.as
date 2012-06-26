package mteb.view.scene
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import away3d.cameras.lenses.LensBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.GameStateEnum;
	import mteb.control.IGameStateMachine;
	import mteb.control.SignalBus;
	import mteb.control.signals.ActionTriggered;
	import mteb.control.signals.ArtifactChanged;
	import mteb.control.signals.ArtifactCollected;
	import mteb.control.signals.AzimuthChanged;
	import mteb.control.signals.FrameEntered;
	import mteb.control.signals.NodeChanged;
	import mteb.control.signals.PreferencesChanged;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.data.config.IConfig;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.ActionTypeEnum;
	import mteb.data.map.AzimuthTable;
	import mteb.data.map.ICompass;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.map.IMap;
	import mteb.data.map.Node;
	import mteb.data.time.ITime;
	import mteb.view.scene.artifact.ArtifactGeometry;
	import mteb.view.scene.compass.CompassControl;
	import mteb.view.scene.compass.CompassLightEnum;
	import mteb.view.scene.ground.BitmapCubeLoader;
	import mteb.view.scene.ground.NodeGeometry;
	import mteb.view.scene.ground.SkyBoxFaceEnum;
	import mteb.view.scene.moon.MoonGeometry;
	import mteb.view.scene.moon.MoonTrail;
	import mteb.view.scene.moon.Orbit;
	import mteb.view.scene.sky.SkyGeometry;


	public class SceneLayer extends Sprite implements ISceneLayer, ISignalReceiver, ICompass
	{
		protected var STARTING_AZIMUTH:Number; // azimuth of initial node view
		protected const TO_DEGREES:Number = 180 / Math.PI;

		protected const dataLocator:IDataLocator = DataLocator.getInstance();
		protected const mcp:IGameStateMachine = dataLocator.mcp;
		protected const bitmapCubeLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const hotSpotLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const actionTrigger:ActionTrigger = new ActionTrigger();
		protected var artifactGeo:ArtifactGeometry;
		protected const groundGeo:NodeGeometry = new NodeGeometry();
		protected const skyGeo:SkyGeometry = new SkyGeometry();
		protected const moonOrbit:Orbit = new Orbit();
		protected const moonGeo:ObjectContainer3D = new MoonGeometry() as ObjectContainer3D;
		protected const moonTrail:MoonTrail = new MoonTrail();
		protected const moonTrailFrameSkip:uint = 4;
		protected const compassControl:ObjectContainer3D = new CompassControl();
		protected const sceneGeo:ObjectContainer3D = new ObjectContainer3D();
		protected const view:View3D = new View3D();

		protected const azimuthChanged:IProtectedSignal = new AzimuthChanged();
		protected const actionTriggered:IProtectedSignal = new ActionTriggered();
		protected const artifactCollected:IProtectedSignal = new ArtifactCollected();

		protected var moonTrailFrame:uint = moonTrailFrameSkip;
		protected var lastAzimuth:Number;


		public function SceneLayer()
		{
			super();

			STARTING_AZIMUTH = AzimuthTable.northMaxRise;
			initScene();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(azimuthChanged as ISignal);
			signalBus.addSignal(actionTriggered as ISignal);
			signalBus.addSignal(artifactCollected as ISignal);
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(NodeChanged, this);
			signalBus.addReceiver(StageResized, this);
			signalBus.addReceiver(PreferencesChanged, this);
		}

		public function get currentAzimuth():Number
		{
			return lastAzimuth;
		}

		public function get displayObject():DisplayObject  { return this as DisplayObject; }

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is FrameEntered):
					onFrameEntered(authority as ITime);
					break;

				case (signal is NodeChanged):
					onNodeChanged(authority as IMap);
					break;

				case (signal is StageResized):
					onStageResized(authority as Stage);
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

			groundGeo.addEventListener(MouseEvent3D.CLICK, onGroundClicked);

			moonOrbit.setSubject(moonGeo, 1024 + 512);

			sceneGeo.addChildren(skyGeo, groundGeo, moonOrbit, moonTrail, compassControl);
			view.scene.addChild(sceneGeo);
		}

		protected function onArtifactClicked(event:MouseEvent3D):void
		{
			const artifact:ArtifactGeometry = event.object as ArtifactGeometry;
			debug(this, "onArtifactClicked() - {0} (index {1}); removing from node and announcing collected", artifact.name, artifact.index);

			removeArtifact();
			mcp.onArtifactCollected(artifact.index);
		}

		protected function onFrameEntered(time:ITime):void
		{
			// bail if textures aren't ready
			if (!bitmapCubeLoader.isLoaded || !hotSpotLoader.isLoaded)
				return;

			// apply current user rotations
			view.camera.transform = dataLocator.look.value;

			// spin the sky
			skyGeo.animate(time.secondsElapsedScaled);

			// revolve the moon
			moonOrbit.animate(time.secondsElapsedScaled);
			if (--moonTrailFrame == 0)
			{
				moonTrail.setNextPoint(moonGeo.scenePosition);
				moonTrailFrame = moonTrailFrameSkip;
			}

			// compute azimuth and send notification of any change
			setAzimuth(computeAzimuth());

			// render the view
			view.render();
		}

		protected function onGroundClicked(event:MouseEvent3D):void
		{
			const object3d:Object3D = event.object;
			const index:int = SkyBoxFaceEnum.fromString(object3d.name).index;
			const uv:Point = event.uv;

			const map:IMap = dataLocator.map;
			const node:Node = map.currentNode;
			actionTrigger.type = ActionTypeEnum.JUMP_TO_NODE;
			actionTrigger.nodeId = null;
			actionTrigger.hotSpotColor = hotSpotLoader.getUvColorAt(index, uv);

			debug(this, "onGroundClicked() - N{0}.{1} ({2}, {3})", node.id, object3d.name, uv.x.toFixed(3), uv.y.toFixed(3));
			actionTriggered.send(actionTrigger);
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
			if (node.hasArtifact)
			{
				debug(this, "onNodeTraveled() - currentNode ({0}) has an artifact! Revealing artifact {1}...", node.id, node.artifact);
				if (!artifactGeo)
					artifactGeo = new ArtifactGeometry(node.artifact);
				else
					artifactGeo.changeId(node.artifact);
				addArtifact();
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

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
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

			var showHotspots:Boolean = dataLocator.config.showHotspots;
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
