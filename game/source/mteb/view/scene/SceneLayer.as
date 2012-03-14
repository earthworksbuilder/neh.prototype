package mteb.view.scene
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;
	import mteb.command.SignalBus;
	import mteb.command.signals.FrameEntered;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;


	public class SceneLayer extends Sprite implements ISignalReceiver
	{
		protected const STARTING_AZIMUTH:Number = 51.5; // azimuth of initial node view
		protected const TO_DEGREES:Number = 180 / Math.PI;

		protected const bitmapCubeLoader:BitmapCubeLoader = new BitmapCubeLoader();

		protected var currentNode:String;
		protected const dataLocator:IDataLocator = DataLocator.getInstance();
		protected var groundGeo:NodeGeometry;
		protected var skyGeo:ObjectContainer3D;
		protected var view:View3D;


		public function SceneLayer()
		{
			super();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(FrameEntered, this);

			setNodeImages(nextNode());

			debug(this, "constructor - loading cube images...");
			bitmapCubeLoader.load(initScene);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			if (!view)
				return;

			const s:Number = authority as Number;

			// apply current user rotations
			view.camera.transform = dataLocator.look.value;

			// spin the sky
			skyGeo.rotationY += .25 * s;

			// render the view
			view.render();
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

		protected function getActionType(objectName:String, textureCoords:Point = null):String
		{
			return "NEXT_NODE";
		}

		protected function handleAction(action:String):void
		{
			switch (action)
			{
				case "NEXT_NODE":
					setNodeImages(nextNode());
					bitmapCubeLoader.load(onNodeTraveled);
					break;

				default:
					debug(this, "handleAction() - unknown action type {0}", action);
					break;
			}
		}

		protected function initScene():void
		{
			debug(this, "initScene()");

			// create a viewport and add it to the stage
			view = new View3D();
			view.backgroundColor = 0x333333;
			addChild(view);

			// set camera at origin
			view.camera.position = new Vector3D(0, 0, 0);
			view.camera.lookAt(new Vector3D(0, 0, 50));
			dataLocator.look.initialValue = view.camera.transform;

			// add geometry to the scene
			const sceneGeo:ObjectContainer3D = new ObjectContainer3D();
			skyGeo = new SkyGeometry();
			//skyGeo.addEventListener(MouseEvent3D.CLICK, onSkyClicked); // not getting any hits
			groundGeo = new NodeGeometry();
			groundGeo.addEventListener(MouseEvent3D.CLICK, onGroundClicked);
			sceneGeo.addChildren(skyGeo, groundGeo);
			view.scene.addChild(sceneGeo);

			onNodeTraveled();
		}

		protected function nextNode():String
		{
			var next:String;
			switch (currentNode)
			{
				case null:
					next = "001";
					break;
				case "001":
					next = "002";
					break;
				case "002":
					next = "003";
					break;
				case "003":
					next = "004";
					break;
				case "004":
					next = "005";
					break;
				case "005":
					next = "006";
					break;
				case "006":
					next = "007";
					break;
				case "007":
					next = "008";
					break;
				case "008":
					next = "009";
					break;
				case "009":
					next = "001";
					break;
			}

			debug(this, "nextNode() - {0} -> {1}", currentNode, next);
			currentNode = next;
			return currentNode;
		}

		protected function onGroundClicked(event:MouseEvent3D):void
		{
			const object3d:Object3D = event.object;
			const uv:Point = event.uv;
			const action:String = getActionType(object3d.name, uv);

			debug(this, "onViewClicked() - azimuth: {0}, N{1}.{2} ({3}, {4}), action: {5}", currentAzimuth.toFixed(2), currentNode, object3d.name, uv.x.toFixed(3), uv.y.toFixed(3), action);
			handleAction(action);
		}

		protected function onNodeTraveled():void
		{
			debug(this, "onNodeTraveled() - currentNode is {0}; updating bitmapdata", currentNode);
			for (var i:uint = 0; i < 6; i++)
				groundGeo.setTextureData(bitmapCubeLoader.getBitmapDataAt(i), i);
		}

		protected function onSkyClicked(event:MouseEvent3D):void
		{
			debug(this, "onSkyClicked()");
		}

		protected function setNodeImages(nodeName:String):void
		{
			bitmapCubeLoader.setUrls("nodes/posX/posX." + nodeName + ".png", "nodes/negX/negX." + nodeName + ".png", "nodes/posY/posY." + nodeName + ".png", "nodes/negY/negY." + nodeName + ".png", "nodes/posZ/posZ." + nodeName + ".png", "nodes/negZ/negZ." + nodeName + ".png");
		}
	}
}
