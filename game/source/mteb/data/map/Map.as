package mteb.data.map
{
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ProtectedSignal;

	import mteb.command.SignalBus;
	import mteb.command.signals.NodeChanged;


	public class Map implements IMap
	{
		protected const nodeChanged:ProtectedSignal = new NodeChanged();

		protected const _currentNode:Node = new Node();
		protected var xml:XML;


		public function Map()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(nodeChanged as ISignal);
		}

		public function get currentNode():Node  { return _currentNode; }

		public function load(file:String):void
		{
			onMapLoaded(); // TODO: actually load map, and set onMapLoaded as complete handler
		}

		public function triggerAction(trigger:ActionTrigger):void
		{
			const actionType:ActionTypeEnum = getActionType(trigger);
			debug(this, "triggerAction() - {0} : {1}", trigger, actionType);

			switch (actionType)
			{
				case ActionTypeEnum.NEXT_NODE:
					changeNode(nextNodeId(_currentNode.id));
					break;
			}
		}

		protected function changeNode(nodeId:String):void
		{
			_currentNode.setId(nodeId);
			//TODO: set azimuth, read from nodes.xml
			nodeChanged.send(this);
		}

		protected function getActionType(trigger:ActionTrigger):ActionTypeEnum
		{
			//TODO: switch based on values for node in xml
			var actionType:ActionTypeEnum;
			switch (trigger.hotSpotColor)
			{
				case 0x000000:
					actionType = ActionTypeEnum.NONE;
					break;
				default:
					actionType = ActionTypeEnum.NEXT_NODE;
					break;
			}
			return actionType;
		}

		protected function nextNodeId(currentId:String):String
		{
			var next:String;
			switch (currentId)
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

			debug(this, "nextNodeId() - {0} -> {1}", currentId, next);
			return next;
		}

		protected function onMapLoaded():void
		{
			changeNode(nextNodeId(_currentNode.id)); // TODO: change to respect start node and azimuth from nodes.xml
		}
	}
}
