package mteb.data.map
{
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;
	import pixeldroid.signals.ProtectedSignal;

	import mteb.command.SignalBus;
	import mteb.command.signals.ActionTriggered;
	import mteb.command.signals.NodeChanged;


	public class Map implements IMap, ISignalReceiver
	{
		protected const nodeChanged:ProtectedSignal = new NodeChanged();

		protected const _currentNode:Node = new Node();
		protected var xml:XML;


		public function Map()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(nodeChanged as ISignal);
			signalBus.addReceiver(ActionTriggered, this);
		}

		public function get currentNode():Node  { return _currentNode; }

		public function load(file:String):void
		{
			xml = <map startNode="005" startAzimuth="51.5">
					<node id="001" color="0x369100" mapx="91" mapy="61"/>
					<node id="002" color="0x0000ff" mapx="122" mapy="51"/>
					<node id="003" color="0xff0000" mapx="168" mapy="97"/>
					<node id="004" color="0x00ff00" mapx="122" mapy="162"/>
					<node id="005" color="0xff4700" mapx="80" mapy="97"/>
					<node id="006" color="0xff00ff" mapx="86" mapy="135"/>
					<node id="007" color="0xffff00" mapx="172" mapy="124"/>
					<node id="008" color="0x6100ff" mapx="86" mapy="188"/>
					<node id="009" color="0xff006d" mapx="164" mapy="61"/>
					<node id="010" color="0x00ffff" mapx="122" mapy="141"/>
					<node id="011" color="0x9d00ff" mapx="122" mapy="188"/>
					<node id="012" color="0x00ff90" mapx="122" mapy="97"/>
					<node id="013" color="0xfd8d00" mapx="158" mapy="188"/>
					<node id="014" color="0x0079ff" mapx="159" mapy="133"/>
					<node id="015" color="0x9ffe00" mapx="80" mapy="97"/>
					<node id="016" color="0xff7e6d" mapx="170" mapy="26"/>
					<node id="017" color="0xffac6d" mapx="105" mapy="79"/>
					<node id="018" color="0x9db572" mapx="141" mapy="79"/>
					<node id="019" color="0xa48600" mapx="141" mapy="118"/>
					<node id="020" color="0xff003f" mapx="104" mapy="118"/>
					<node id="021" color="0x9aae3b" mapx="104" mapy="188"/>
					<node id="022" color="0xd69d3b" mapx="141" mapy="188"/>
				</map>;

			onMapLoaded(); // TODO: load map externally, and set onMapLoaded as complete handler
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is ActionTriggered):
					onActionTriggered(authority as ActionTrigger);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		protected function changeNode(nodeId:String, azimuth:Number = 51.5):void
		{
			_currentNode.setId(nodeId);
			_currentNode.azimuth = azimuth;

			debug(this, "changeNode() - updated current node to: {0}; sending NodeChanged signal..", _currentNode);
			nodeChanged.send(this);
		}

		protected function getNodeByColor(color:uint):String
		{
			var nodeId:String;

			if (color != 0x000000)
			{
				const nodeList:XMLList = xml.node;
				const n:uint = nodeList.length();
				for (var i:uint = 0; i < n; i++)
				{
					if (isApproximateMatch(color, parseInt(nodeList[i].@color)))
					{
						nodeId = nodeList[i].@id;
						break;
					}
				}
			}

			debug(this, "getNodeByColor() - {0} -> {1}", uintToString(color), nodeId);
			return nodeId;
		}

		protected function getStartAzimuth():Number
		{
			return parseFloat(xml.@startAzimuth);
		}

		protected function getStartNode():String
		{
			return xml.@startNode;
		}

		protected function isApproximateMatch(a:uint, b:uint, fuzz:uint = 3):Boolean
		{
			if (a == b)
				return true;

			const ra:int = (a >> 16) & 0xff;
			const rb:int = (b >> 16) & 0xff;
			if (Math.abs(ra - rb) > fuzz)
				return false;

			const ga:int = (a >> 8) & 0xff;
			const gb:int = (b >> 8) & 0xff;
			if (Math.abs(ga - gb) > fuzz)
				return false;

			const ba:int = a & 0xff;
			const bb:int = b & 0xff;
			if (Math.abs(ba - bb) > fuzz)
				return false;

			return true;
		}

		protected function onActionTriggered(trigger:ActionTrigger):void
		{
			const actionType:ActionTypeEnum = trigger.type;
			debug(this, "onActionTriggered() - processing action type '{0}'", actionType);

			switch (actionType)
			{
				case ActionTypeEnum.JUMP_TO_NODE:
					const jumpId:String = trigger.nodeId || getNodeByColor(trigger.hotSpotColor);
					if (jumpId)
						changeNode(jumpId);
					else
						debug(this, "onActionTriggered() - could not resolve target nodeId");
					break;
				default:
					debug(this, "onActionTriggered() - unknown action type '{0}'", actionType);
					break;
			}
		}

		protected function onMapLoaded():void
		{
			changeNode(getStartNode(), getStartAzimuth());
		}

		protected function uintToString(value:uint):String
		{
			const r:uint = (value >> 16) & 0xff;
			const g:uint = (value >> 8) & 0xff;
			const b:uint = value & 0xff;

			const rx:String = ((r < 16) ? "0" : "") + r.toString(16);
			const gx:String = ((g < 16) ? "0" : "") + g.toString(16);
			const bx:String = ((b < 16) ? "0" : "") + b.toString(16);

			return "0x" + rx + gx + bx;
		}
	}
}
