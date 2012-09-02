package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.assets.UiElements;
	import mteb.control.SignalBus;
	import mteb.control.signals.ActionTriggered;
	import mteb.control.signals.AzimuthChanged;
	import mteb.control.signals.NodeChanged;
	import mteb.data.map.ActionTrigger;
	import mteb.data.map.ActionTypeEnum;
	import mteb.data.map.IAzimuthProvider;
	import mteb.data.map.IMap;


	public class MapControl extends Sprite implements ISignalReceiver
	{
		protected const actionTrigger:ActionTrigger = new ActionTrigger();
		protected const actionTriggered:IProtectedSignal = new ActionTriggered();
		protected const container:Sprite = new Sprite();
		protected const mapOffset:Point = new Point();
		protected var mapImage:Sprite;
		protected var viewAngle:Sprite;


		public function MapControl()
		{
			super();
			initialize();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(actionTriggered as ISignal);
			signalBus.addReceiver(AzimuthChanged, this);
			signalBus.addReceiver(NodeChanged, this);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is AzimuthChanged):
					onAzimuthChanged(authority as IAzimuthProvider);
					break;

				case (signal is NodeChanged):
					onNodeChanged(authority as IMap);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function initialize():void
		{
			mapImage = UiElements.nodeMap;
			mapOffset.x = mapImage.getChildAt(0).x;
			mapOffset.y = mapImage.getChildAt(0).y;
			container.addChild(mapImage);
			mapImage.addEventListener(MouseEvent.CLICK, onMapClicked);

			viewAngle = UiElements.mapViewAngle;
			container.addChild(viewAngle);

			addChild(container);
		}

		protected function onAzimuthChanged(compass:IAzimuthProvider):void
		{
			const correctedAzimuth:Number = compass.currentAzimuth - 51.5;
			container.rotation = -1 * correctedAzimuth;
			viewAngle.rotation = correctedAzimuth;
		}

		protected function onMapClicked(event:MouseEvent):void
		{
			const mapPoint:Point = new Point(event.localX, event.localY);
			mapPoint.offset(-mapOffset.x, -mapOffset.y);

			actionTrigger.type = ActionTypeEnum.MAP_PICK_NODE;
			actionTrigger.nodeId = null;
			actionTrigger.mapPoint = mapPoint;

			debug(this, "onMapClicked() - got click at {0}, {1}, map point is: {2}", event.localX, event.localY, mapPoint);
			actionTriggered.send(actionTrigger);
		}

		protected function onNodeChanged(map:IMap):void
		{
			const mapPoint:Point = map.currentNode.mapPoint;
			mapPoint.offset(mapOffset.x, mapOffset.y);
			viewAngle.x = mapPoint.x;
			viewAngle.y = mapPoint.y;
		}
	}
}
