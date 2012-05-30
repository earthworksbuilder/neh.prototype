package mteb.view.scene
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.ActionTriggered;
	import mteb.control.signals.AzimuthChanged;
	import mteb.control.signals.FrameEntered;
	import mteb.control.signals.NodeChanged;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.ActionTypeEnum;
	import mteb.data.map.ICompass;
	import mteb.data.map.IMap;
	import mteb.data.map.Node;
	import mteb.data.time.ITime;


	public class SceneLayer extends Sprite implements ISceneLayer, ISignalReceiver, ICompass
	{
		protected const STARTING_AZIMUTH:Number = 51.5; // azimuth of initial node view
		protected const TO_DEGREES:Number = 180 / Math.PI;

		protected const dataLocator:IDataLocator = DataLocator.getInstance();
		protected const bitmapCubeLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const hotSpotLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const actionTrigger:ActionTrigger = new ActionTrigger();
		protected const groundGeo:NodeGeometry = new NodeGeometry();
		protected const skyGeo:SkyGeometry = new SkyGeometry();
		protected const moonOrbit:Orbit = new Orbit();
		protected const moonGeo:ObjectContainer3D = new MoonGeometry() as ObjectContainer3D;
		protected const moonTrail:MoonTrail = new MoonTrail();
		protected const moonTrailFrameSkip:uint = 4;
		protected const view:View3D = new View3D();

		protected const azimuthChanged:IProtectedSignal = new AzimuthChanged();
		protected const actionTriggered:IProtectedSignal = new ActionTriggered();

		protected var currentNode:String;
		protected var moonTrailFrame:uint = moonTrailFrameSkip;

		protected const testArtifact:ObjectContainer3D = new ArtifactGeometry();


		public function SceneLayer()
		{
			super();

			initScene();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(azimuthChanged as ISignal);
			signalBus.addSignal(actionTriggered as ISignal);
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(NodeChanged, this);
		}

		public function get currentAzimuth():Number
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

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		public function get view3D():View3D  { return view; }

		protected function initScene():void
		{
			debug(this, "initScene()");

			// configure viewport and add it to the stage
			view.backgroundColor = 0x333333;
			addChild(view);

			// set camera at origin
			view.camera.position = new Vector3D(0, 0, 0);
			view.camera.lookAt(new Vector3D(0, 0, 50));
			view.camera.rotationX = -19;
			dataLocator.look.initialValue = view.camera.transform;

			// add geometry to the scene
			const sceneGeo:ObjectContainer3D = new ObjectContainer3D();
			skyGeo.tilt = -55; // align polaris for our north america position
			skyGeo.shift = -227;

			groundGeo.addEventListener(MouseEvent3D.CLICK, onGroundClicked);

			moonOrbit.setSubject(moonGeo, 1024);

			testArtifact.position = new Vector3D(0, 0, 100);
			testArtifact.addEventListener(MouseEvent3D.CLICK, onArtifactClicked);

			sceneGeo.addChildren(skyGeo, testArtifact);
			//sceneGeo.addChildren(skyGeo, groundGeo, moonOrbit, moonTrail, testArtifact);
			view.scene.addChild(sceneGeo);
		}

		protected function onArtifactClicked(event:MouseEvent3D):void
		{
			const object3d:Object3D = event.object;
			debug(this, "onartifactClicked() - {0}", object3d.name);
		}

		protected function onFrameEntered(time:ITime):void
		{
			if (!bitmapCubeLoader.isLoaded || !hotSpotLoader.isLoaded)
				return;

			// apply current user rotations
			view.camera.transform = dataLocator.look.value;

			// spin the sky
			skyGeo.travel(time.secondsElapsedScaled);

			// revolve the moon
			moonOrbit.travel(time.secondsElapsedScaled);
			if (--moonTrailFrame == 0)
			{
				moonTrail.setNextPoint(moonGeo.scenePosition);
				moonTrailFrame = moonTrailFrameSkip;
			}

			testArtifact.rotationX += .05;
			testArtifact.rotationY += .1;

			// render the view
			view.render();

			azimuthChanged.send(this);
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
			debug(this, "onHotspotsLoaded() - currentNode hotspots are loaded.");
			if (bitmapCubeLoader.isLoaded && hotSpotLoader.isLoaded)
				updateTextures();
		}

		protected function onNodeChanged(map:IMap):void
		{
			const node:Node = map.currentNode;
			hotSpotLoader.setUrls(node.hotspotPosX, node.hotspotNegX, node.hotspotPosY, node.hotspotNegY, node.hotspotPosZ, node.hotspotNegZ);
			hotSpotLoader.load(onHotspotsLoaded);
			bitmapCubeLoader.setUrls(node.texturePosX, node.textureNegX, node.texturePosY, node.textureNegY, node.texturePosZ, node.textureNegZ);
			bitmapCubeLoader.load(onNodeTraveled);

			debug(this, "onNodeChanged() - map.currentNode is {0}; loading textures and hotspots...", node);
		}

		protected function onNodeTraveled():void
		{
			debug(this, "onNodeTraveled() - currentNode textures are loaded.");
			if (bitmapCubeLoader.isLoaded && hotSpotLoader.isLoaded)
				updateTextures();
		}

		protected function updateTextures():void
		{
			debug(this, "updateTextures() - currentNode textures and hotspots are loaded; updating bitmapdata...");
			var showHotspots:Boolean = dataLocator.config.showHotspots;
			var bd:BitmapData;
			for (var i:uint = 0; i < 6; i++)
			{
				bd = bitmapCubeLoader.getBitmapDataAt(i);
				if (showHotspots)
					bd.copyPixels(hotSpotLoader.getBitmapDataAt(i), bd.rect, (new Point(0, 0)), null, null, true);
				groundGeo.setTextureData(bd, i);
			}
		}
	}
}
