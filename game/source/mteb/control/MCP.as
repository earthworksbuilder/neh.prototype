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

		public function onArtifactCollected(index:uint):void
		{
			debug(this, "onArtifactCollected() - player collected artifact {0}", index + 1);
			debug(this, "onArtifactCollected() - TODO: does this index match an unlocked icon? if so, announce capture");
		}

		public function onInitializationStarted():void  { setState(GameStateEnum.INITIALIZING); }

		public function onMapLoadCompleted():void  { setState(GameStateEnum.WAITING); }

		public function onMapLoadStarted():void  { setState(GameStateEnum.LOADING); }

		public function onNodeTravelCompleted():void  { setState(GameStateEnum.NODE_ARRIVED); }

		public function onNodeTravelStarted():void  { setState(GameStateEnum.NODE_TRAVELING); }

		public function onNorthMinRiseCaptured():void  { setState(GameStateEnum.NORTH_MIN_RISE_CAPTURED); }

		public function onNorthMinRiseUnlocked():void  { setState(GameStateEnum.NORTH_MIN_RISE_UNLOCKED); }

		public function onNorthMinSetCaptured():void  { setState(GameStateEnum.NORTH_MIN_SET_CAPTURED); }

		public function onNorthMinSetUnlocked():void  { setState(GameStateEnum.NORTH_MIN_SET_UNLOCKED); }

		public function get state():GameStateEnum
		{
			return currentState;
		}

		private function setState(value:GameStateEnum):void
		{
			if (value != currentState)
			{
				pendingState = value;
				updateState();
			}
		}


		private function unlockFirstArtifact():void
		{
			// TODO: move to command
			debug(this, "enableFirstArtifact()");

			const artifactChanged:ArtifactChanged = new ArtifactChanged();
			artifactChanged.pointIndex = 0;
			artifactChanged.pointState = CompassLightEnum.UNLOCKED;

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
					unlockFirstArtifact();
					break;
			}

			lastState = currentState;
			currentState = pendingState;

			if (nextState)
				setState(nextState);
		}
	}
}
