package mteb.control.gamestate
{
	import away3d.library.assets.NamedAssetBase;

	import pixeldroid.signals.IProtectedSignal;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.signals.ArtifactChanged;
	import mteb.control.signals.FrameEntered;
	import mteb.control.signals.GameStateChanged;
	import mteb.control.signals.TimeScaleChanged;
	import mteb.data.DataLocator;
	import mteb.data.map.IArtifact;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.player.IInventory;
	import mteb.data.time.ITime;
	import mteb.view.scene.models.compass.CompassLightEnum;


	public final class MCP implements IGameStateMachine
	{

		private const inventory:IInventory = DataLocator.getInstance().inventory;
		private const compassState:CompassStateMachine = new CompassStateMachine();

		private const gameStateChanged:IProtectedSignal = new GameStateChanged();
		private const artifactChanged:ArtifactChanged = new ArtifactChanged();
		private const timeScaleChanged:TimeScaleChanged = new TimeScaleChanged();

		private var layerUiReady:Boolean = false;
		private var layerSceneReady:Boolean = false;
		private var layerDebugReady:Boolean = false;

		private var lastState:GameStateEnum = GameStateEnum.TITLE_SHOWING;
		private var currentState:GameStateEnum = GameStateEnum.TITLE_SHOWING;
		private var pendingState:GameStateEnum;
		private var gameStarted:Boolean = false;

		private var currentActivatedArtifactIndex:int;


		public function MCP()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(gameStateChanged as ISignal);
			signalBus.addSignal(artifactChanged as ISignal);
			signalBus.addSignal(timeScaleChanged as ISignal);
		}

		public function onArtifactCollected(artifact:IArtifact):void
		{
			debug(this, "onArtifactCollected() - player collected artifact {0}", artifact.id);
			inventory.addArtifact(artifact);

			if (artifact.index == compassState.currentArtifactIndex)
				setState(GameStateEnum.ACTIVATING);
			else
				debug(this, "onArtifactCollected() - doesn't match the currently sought index ({0})", compassState.currentArtifactIndex);
		}

		public function onDebugLayerReady():void  { layerDebugReady = true; assessReadiness(); }

		public function onMapLoadCompleted():void  { setState(GameStateEnum.WAITING_TO_SHOW); }

		public function onMapLoadStarted():void  { setState(GameStateEnum.LOADING); }

		public function onMoonCaptured():void
		{
			debug(this, "onMoonCaptured() - player captured moon; yay, points!");
			if (compassState.captureMoonForArtifact(currentActivatedArtifactIndex))
				setState(GameStateEnum.CAPTURING);
			else
				throw new Error("wait, what?! how can currentActivatedArtifact not match what compassState is looking for?");
		}

		public function onMoonTravelCompleted():void  { setState(GameStateEnum.UNLOCKING); }

		public function onNewGameRequested():void  { setState(GameStateEnum.INITIALIZING); }

		public function onNodeTravelCompleted():void  { setState(GameStateEnum.NODE_ARRIVED); }

		public function onNodeTravelStarted():void  { setState(GameStateEnum.NODE_TRAVELING); }

		public function onSceneLayerReady():void  { layerSceneReady = true; assessReadiness(); }

		public function onUiLayerReady():void  { layerUiReady = true; assessReadiness(); }

		public function get state():GameStateEnum
		{
			return currentState;
		}

		private function announceStateChange():void
		{
			gameStateChanged.send(this as IGameStateMachine);
		}

		private function assessReadiness():void
		{
			if (currentState == GameStateEnum.INITIALIZING)
			{
				if (layerUiReady && layerSceneReady && layerDebugReady)
					setState(GameStateEnum.WAITING_TO_LOAD);
			}
		}


		private function onArtifactActivated(index:uint):void
		{
			debug(this, "onArtifactActivated() - announcing capture of artifact {0}, setting state to ACTIVATED", index);
			currentActivatedArtifactIndex = index;

			artifactChanged.pointIndex = index;
			artifactChanged.pointState = CompassLightEnum.ACTIVATED;
			artifactChanged.send(artifactChanged as ICompassLightStateProvider);
		}

		private function onArtifactCaptured(index:uint):void
		{
			debug(this, "onArtifactCaptured() - announcing capture of artifact {0}, setting state to CAPTURED", index);

			artifactChanged.pointIndex = index;
			artifactChanged.pointState = CompassLightEnum.CAPTURED;
			artifactChanged.send(artifactChanged as ICompassLightStateProvider);

			const t:Number = .35;
			timeScaleChanged.scale = t * t * t * (50 * 1000);
			timeScaleChanged.send();

			if (compassState.capturesRemaining == 0)
			{
				debug(this, "onArtifactCaptured() - GAME OVER, YOU WIN!");
					// TODO: announce end game state
			}
		}

		private function onArtifactUnlocked(index:uint):void
		{
			debug(this, "onArtifactUnlocked() - announcing unlocking of {0}, setting state to UNLOCKED", index);

			artifactChanged.pointIndex = index;
			artifactChanged.pointState = CompassLightEnum.UNLOCKED;
			artifactChanged.send(artifactChanged as ICompassLightStateProvider);

			timeScaleChanged.scale = 0;
			timeScaleChanged.send();
		}

		private function setState(value:GameStateEnum):void
		{
			if (value != currentState)
			{
				pendingState = value;
				updateState();
			}
		}

		private function updateState():void
		{
			debug(this, "updateState() - state transition: {0} --> {1}", currentState, pendingState);

			var nextState:GameStateEnum;

			switch (pendingState)
			{
				case GameStateEnum.WAITING_TO_SHOW:
					nextState = GameStateEnum.WAITING;
					break;

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
					onArtifactUnlocked(compassState.currentArtifactIndex);
					break;

				case GameStateEnum.ACTIVATING:
					nextState = GameStateEnum.WAITING;
					onArtifactActivated(compassState.currentArtifactIndex);
					break;

				case GameStateEnum.CAPTURING:
					nextState = GameStateEnum.WAITING;
					onArtifactCaptured(compassState.lastCapturedArtifactIndex);
					break;
			}

			lastState = currentState;
			currentState = pendingState;

			announceStateChange();

			if (nextState)
				setState(nextState);
		}
	}
}
