package mteb.control.gamestate
{
	import mteb.data.map.IArtifact;


	public interface IGameStateMachine
	{

		function onArtifactCollected(artifact:IArtifact):void;

		function onDebugLayerReady():void;

		function onMapLoadCompleted():void;

		function onMapLoadStarted():void;

		function onMoonCaptured():void;

		function onMoonTravelCompleted():void;

		function onNewGameRequested():void;

		function onNodeTravelCompleted():void;

		function onNodeTravelStarted():void;

		function onSceneLayerReady():void;

		function onUiLayerReady():void;

		function get state():GameStateEnum;
	}
}
