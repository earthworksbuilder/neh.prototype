package mteb.data.map
{
	import flash.geom.Point;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;
	import pixeldroid.signals.ProtectedSignal;

	import mteb.control.SignalBus;
	import mteb.control.gamestate.GameStateEnum;
	import mteb.control.gamestate.IGameStateMachine;
	import mteb.control.signals.ActionTriggered;
	import mteb.control.signals.NodeChanged;
	import mteb.data.DataLocator;


	public final class Map implements IMap, ISignalReceiver
	{
		protected const mcp:IGameStateMachine = DataLocator.getInstance().mcp;
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
			mcp.onMapLoadStarted();

			xml = <map startNode="005" startAzimuth="51.5">
					<node id="001" color="0x369100" mapx="90" mapy="60"/>
					<node id="002" color="0x0000ff" mapx="122" mapy="49" artifact="2"/>
					<node id="003" color="0xff0000" mapx="168" mapy="95"/>
					<node id="004" color="0x00ff00" mapx="122" mapy="159"/>
					<node id="005" color="0xff4700" mapx="122" mapy="217" artifact="1"/>
					<node id="006" color="0xff00ff" mapx="86" mapy="132"/>
					<node id="007" color="0xffff00" mapx="172" mapy="121"/>
					<node id="008" color="0x6100ff" mapx="86" mapy="186"/>
					<node id="009" color="0xff006d" mapx="162" mapy="58"/>
					<node id="010" color="0x00ffff" mapx="122" mapy="139" artifact="4"/>
					<node id="011" color="0x9d00ff" mapx="122" mapy="185"/>
					<node id="012" color="0x00ff90" mapx="122" mapy="95"/>
					<node id="013" color="0xfd8d00" mapx="159" mapy="185"/>
					<node id="014" color="0x0079ff" mapx="158" mapy="130"/>
					<node id="015" color="0x9ffe00" mapx="82" mapy="95"/>
					<node id="016" color="0xff7e6d" mapx="169" mapy="24"/>
					<node id="017" color="0xffac6d" mapx="103" mapy="76"/>
					<node id="018" color="0x9db572" mapx="140" mapy="76"/>
					<node id="019" color="0xa48600" mapx="140" mapy="115" artifact="3"/>
					<node id="020" color="0xff003f" mapx="103" mapy="115"/>
					<node id="021" color="0x9aae3b" mapx="103" mapy="185"/>
					<node id="022" color="0xd69d3b" mapx="141" mapy="185"/>
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
			if (nodeId == _currentNode.id)
			{
				debug(this, "changeNode() - already at node {0}; ignoring request to change", _currentNode);
				return;
			}

			_currentNode.setId(nodeId);
			_currentNode.azimuth = azimuth;
			_currentNode.mapPoint = getMapPoint(nodeId);
			_currentNode.artifact = getArtifactId(nodeId);

			debug(this, "changeNode() - updated current node to: {0}; sending NodeChanged signal..", _currentNode);
			nodeChanged.send(this);
		}

		protected function getArtifactId(nodeId:String):uint
		{
			var artifactId:uint;

			const nodeList:XMLList = xml.node;
			const n:uint = nodeList.length();
			var node:XML;
			for (var i:uint = 0; i < n; i++)
			{
				node = nodeList[i];
				if (node.@id == nodeId)
				{
					artifactId = parseInt(node.@artifact);
					break;
				}
			}

			debug(this, "getArtifactId() - {0} has {1}", nodeId, (artifactId ? "artifact " + artifactId : "no artifact"));
			return artifactId;
		}

		protected function getMapPoint(nodeId:String):Point
		{
			var position:Point = new Point();

			const nodeList:XMLList = xml.node;
			const n:uint = nodeList.length();
			var node:XML;
			for (var i:uint = 0; i < n; i++)
			{
				node = nodeList[i];
				if (node.@id == nodeId)
				{
					position.x = parseInt(node.@mapx);
					position.y = parseInt(node.@mapy);
					break;
				}
			}

			debug(this, "getMapPosition() - {0} -> {1}", nodeId, position);
			return position;
		}

		protected function getNodeByColor(color:uint):String
		{
			var nodeId:String;

			if (color != 0x000000)
			{
				const nodeList:XMLList = xml.node;
				const n:uint = nodeList.length();
				var node:XML;
				for (var i:uint = 0; i < n; i++)
				{
					node = nodeList[i];
					if (isApproximateColorMatch(color, parseInt(node.@color)))
					{
						nodeId = node.@id;
						break;
					}
				}
			}

			debug(this, "getNodeByColor() - {0} -> {1}", uintToString(color), nodeId);
			return nodeId;
		}

		protected function getNodeByMapPoint(point:Point):String
		{
			var nodeId:String;

			const nodeList:XMLList = xml.node;
			const n:uint = nodeList.length();
			var node:XML;
			const nodePoint:Point = new Point();
			for (var i:uint = 0; i < n; i++)
			{
				node = nodeList[i];
				nodePoint.setTo(parseInt(node.@mapx), parseInt(node.@mapy));
				if (isApproximatePointMatch(point, nodePoint))
				{
					nodeId = node.@id;
					break;
				}
			}

			debug(this, "getNodeByMapPoint() - {0} -> {1}", point, nodeId);
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

		protected function isApproximateColorMatch(a:uint, b:uint, fuzz:uint = 3):Boolean
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

		protected function isApproximatePointMatch(a:Point, b:Point, fuzz:uint = 6):Boolean
		{
			const d:Number = Point.distance(a, b);

			return (d <= fuzz);
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
						debug(this, "onActionTriggered({0}) - could not resolve target nodeId for color {1}", actionType, uintToString(trigger.hotSpotColor));
					break;

				case ActionTypeEnum.MAP_PICK_NODE:
					const pickId:String = trigger.nodeId || getNodeByMapPoint(trigger.mapPoint);
					if (pickId)
						changeNode(pickId);
					else
						debug(this, "onActionTriggered({0}) - could not resolve target nodeId for point {1}", actionType, trigger.mapPoint);
					break;

				default:
					debug(this, "onActionTriggered() - unknown action type '{0}'", actionType);
					break;
			}
		}

		protected function onMapLoaded():void
		{
			mcp.onMapLoadCompleted();
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
