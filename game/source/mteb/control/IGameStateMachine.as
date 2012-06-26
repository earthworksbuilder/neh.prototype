package mteb.control
{


	public interface IGameStateMachine
	{

		function onArtifactCollected(index:uint):void;

		function onInitializationStarted():void;

		function onMapLoadCompleted():void;

		function onMapLoadStarted():void;

		function onNodeTravelCompleted():void;

		function onNodeTravelStarted():void;

		function onNorthMinRiseCaptured():void;

		function onNorthMinRiseUnlocked():void;

		function onNorthMinSetCaptured():void;

		function onNorthMinSetUnlocked():void;

		function get state():GameStateEnum;
	}
}
