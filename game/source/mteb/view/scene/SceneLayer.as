package mteb.view.scene
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.command.SignalBus;
	import mteb.command.signals.FrameEntered;
	import mteb.command.signals.NodeChanged;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.IMap;
	import mteb.data.map.Node;
	import mteb.data.time.ITime;


	public class SceneLayer extends Sprite implements ISignalReceiver
	{
		protected const STARTING_AZIMUTH:Number = 51.5; // azimuth of initial node view
		protected const TO_DEGREES:Number = 180 / Math.PI;

		protected const dataLocator:IDataLocator = DataLocator.getInstance();
		protected const bitmapCubeLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const hotSpotLoader:BitmapCubeLoader = new BitmapCubeLoader();
		protected const actionTrigger:ActionTrigger = new ActionTrigger();
		protected const groundGeo:NodeGeometry = new NodeGeometry();
		protected const skyGeo:ObjectContainer3D = new SkyGeometry();
		protected const view:View3D = new View3D();

		protected var currentNode:String;


		public function SceneLayer()
		{
			super();

			initScene();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(NodeChanged, this);
		}

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

		protected function get currentAzimuth():Number
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
			addChild(view);

			// set camera at origin
			view.camera.position = new Vector3D(0, 0, 0);
			view.camera.lookAt(new Vector3D(0, 0, 50));
			dataLocator.look.initialValue = view.camera.transform;

			// add geometry to the scene
			const sceneGeo:ObjectContainer3D = new ObjectContainer3D();
			//skyGeo.addEventListener(MouseEvent3D.CLICK, onSkyClicked); // not getting any hits
			groundGeo.addEventListener(MouseEvent3D.CLICK, onGroundClicked);
			sceneGeo.addChildren(skyGeo, groundGeo);
			view.scene.addChild(sceneGeo);
		}

		protected function onFrameEntered(time:ITime):void
		{
			if (!bitmapCubeLoader.isLoaded || !hotSpotLoader.isLoaded)
				return;

			// apply current user rotations
			view.camera.transform = dataLocator.look.value;

			// spin the sky
			skyGeo.rotationY += .25 * time.secondsElapsed;

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
			actionTrigger.nodeId = node.id;
			actionTrigger.hotspotColor = hotSpotLoader.getPixelAt(index, uv);

			debug(this, "onGroundClicked() - azimuth: {0}, N{1}.{2} ({3}, {4}, {5})", currentAzimuth.toFixed(2), node.id, object3d.name, uv.x.toFixed(3), uv.y.toFixed(3), actionTrigger.hotspotColor);
			map.triggerAction(actionTrigger);
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

			debug(this, "onNodeChanged() - currentNode is {0}; loading textures and hotspots...", currentNode);
		}

		protected function onNodeTraveled():void
		{
			debug(this, "onNodeTraveled() - currentNode textures are loaded.");
			if (bitmapCubeLoader.isLoaded && hotSpotLoader.isLoaded)
				updateTextures();
		}

		protected function onSkyClicked(event:MouseEvent3D):void
		{
			debug(this, "onSkyClicked()");
		}

		protected function updateTextures():void
		{
			debug(this, "updateTextures() - currentNode textures and hotspots are loaded; updating bitmapdata...");
			var bd:BitmapData;
			for (var i:uint = 0; i < 6; i++)
			{
				bd = bitmapCubeLoader.getBitmapDataAt(i);
				bd.copyPixels(hotSpotLoader.getBitmapDataAt(i), bd.rect, (new Point(0, 0)), null, null, true);
				groundGeo.setTextureData(bd, i);

					//groundGeo.setTextureData(bitmapCubeLoader.getBitmapDataAt(i), i);
			}
		}
	}
}
