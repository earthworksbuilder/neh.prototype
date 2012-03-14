package mteb.data.map
{


	public class Map implements IMap
	{
		protected var _currentNode:Node;

		protected var xml:XML;


		public function Map()
		{
		}

		public function get currentNode():Node  { return _currentNode; }

		public function load(file:String):void
		{

		}

		public function setCurrentNode(value:Node):void  { _currentNode = value; }
	}
}
