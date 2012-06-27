package mteb.control.gamestate
{
	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.ArtifactChanged;
	import mteb.control.signals.FrameEntered;
	import mteb.data.DataLocator;
	import mteb.data.map.IArtifact;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.player.IInventory;
	import mteb.data.time.ITime;
	import mteb.view.scene.compass.CompassLightEnum;


	public final class MCP implements IGameStateMachine
	{

		private const inventory:IInventory = DataLocator.getInstance().inventory;
		private const compassState:CompassStateMachine = new CompassStateMachine();

		private var lastState:GameStateEnum = GameStateEnum.WAITING;
		private var currentState:GameStateEnum = GameStateEnum.WAITING;
		private var pendingState:GameStateEnum;
		private var gameStarted:Boolean = false;

		public function onArtifactCollected(artifact:IArtifact):void
		{
			debug(this, "onArtifactCollected() - player collected artifact {0}", artifact.id);
			inventory.addArtifact(artifact);
			if (artifact.index == compassState.currentArtifactIndex)
				setState(GameStateEnum.CAPTURING);
			else
				debug(this, "onArtifactCollected() - doesn't match the currently sought index ({0})", compassState.currentArtifactIndex);
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

		public function onRiseCaptured(index:uint):void
		{
			debug(this, "onRiseCaptured() - player captured rise {0}", index);
		}

		public function get state():GameStateEnum
		{
			return currentState;
		}


		private function activateArtifact(index:uint):void
		{
			// TODO: move to command
			debug(this, "activateArtifact() - announcing activation of {0}", index);

			const artifactChanged:ArtifactChanged = new ArtifactChanged();
			artifactChanged.pointIndex = index;
			artifactChanged.pointState = CompassLightEnum.ACTIVATED;

			const signalBus:ISignalBus = SignalBus.getInstance();
			const announcement:IProtectedSignal = artifactChanged as IProtectedSignal;
			signalBus.addSignal(announcement as ISignal);
			announcement.send(artifactChanged as ICompassLightStateProvider);
		}

		private function setState(value:GameStateEnum):void
		{
			if (value != currentState)
			{
				pendingState = value;
				updateState();
			}
		}

		private function unlockArtifact(index:uint):void
		{
			// TODO: move to command
			debug(this, "unlockArtifact() - announcing unlocking of {0}", index);

			const artifactChanged:ArtifactChanged = new ArtifactChanged();
			artifactChanged.pointIndex = index;
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
					nextState = GameStateEnum.UNLOCKING;
					break;

				case GameStateEnum.UNLOCKING:
					nextState = GameStateEnum.WAITING;
					unlockArtifact(compassState.currentArtifactIndex);
					break;

				case GameStateEnum.CAPTURING:
					nextState = GameStateEnum.WAITING;
					activateArtifact(compassState.currentArtifactIndex);
					break;
			}

			lastState = currentState;
			currentState = pendingState;

			if (nextState)
				setState(nextState);
		}
	}
}