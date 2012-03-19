package mteb.data.map
{


	public interface IMap
	{
		function get currentNode():Node;
		function triggerAction(trigger:ActionTrigger):void;
		function load(file:String):void;
	}
}
