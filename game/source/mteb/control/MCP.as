package mteb.control
{
	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.signals.ArtifactChanged;
	import mteb.control.signals.FrameEntered;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.time.ITime;
	import mteb.view.scene.compass.CompassLightEnum;


	public final class MCP implements IGameStateMachine
	{

		private var lastState:GameStateEnum = GameStateEnum.WAITING;
		private var currentState:GameStateEnum = GameStateEnum.WAITING;
		private var pendingState:GameStateEnum;
		private var gameStarted:Boolean = false;

		public function get state():GameStateEnum
		{
			return currentState;
		}

		public function set state(value:GameStateEnum):void
		{
			if (value != currentState)
			{
				pendingState = value;
				updateState();
			}
		}


		// TODO: move to command
		private function enableFirstArtifact():void
		{
			debug(this, "enableFirstArtifact()");

			const artifactChanged:ArtifactChanged = new ArtifactChanged();
			artifactChanged.pointIndex = 0;
			artifactChanged.pointState = CompassLightEnum.ENABLED;

			const signalBus:ISignalBus = SignalBus.getInstance();
			const announcement:IProtectedSignal = artifactChanged as IProtectedSignal;
			signalBus.addSignal(announcement as ISignal);
			announcement.send(artifactChanged as ICompassLightStateProvider);
		}

		private function updateState():void
		{
			debug(this, "updateState() - state transition: {0} --> {1}", currentState, pendingState);

			var nextState:GameStateEnum;

			switch (pendingState)
			{
				case GameStateEnum.NODE_ARRIVED:
					nextState = GameStateEnum.WAITING;
					break;

				case GameStateEnum.WAITING:
					if (!gameStarted)
						nextState = GameStateEnum.STARTED;
					break;

				case GameStateEnum.STARTED:
					gameStarted = true;
					nextState = GameStateEnum.WAITING;
					enableFirstArtifact();
					break;
			}

			lastState = currentState;
			currentState = pendingState;

			if (nextState)
				state = nextState;
		}
	}
}
