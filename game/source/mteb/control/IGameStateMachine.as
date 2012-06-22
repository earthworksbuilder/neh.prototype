package mteb.control
{


	public interface IGameStateMachine
	{
		function get state():GameStateEnum;

		function set state(value:GameStateEnum):void;
	}
}
