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
	import mteb.control.signals.MoonTravelChanged;
	import mteb.control.signals.TimeScaleChanged;
	import mteb.control.signals.UiMessageChanged;
	import mteb.data.DataLocator;
	import mteb.data.map.IArtifact;
	import mteb.data.map.ICompassLightStateProvider;
	import mteb.data.orbit.Ephemeris;
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
		private const moonTravelChanged:MoonTravelChanged = new MoonTravelChanged();
		private const uiMessageChanged:UiMessageChanged = new UiMessageChanged();

		private var layerUiReady:Boolean = false;
		private var layerSceneReady:Boolean = false;
		private var layerDebugReady:Boolean = false;

		private var lastState:GameStateEnum = GameStateEnum.TITLE_SHOWING;
		private var currentState:GameStateEnum = GameStateEnum.TITLE_SHOWING;
		private var pendingState:GameStateEnum;
		private var gameStarted:Boolean = false;
		private var moonPaused:Boolean = false;

		private var currentActivatedArtifactIndex:int;
		private var currentDay:uint;


		public function MCP()
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(gameStateChanged as ISignal);
			signalBus.addSignal(artifactChanged as ISignal);
			signalBus.addSignal(timeScaleChanged as ISignal);
			signalBus.addSignal(moonTravelChanged as ISignal);
			signalBus.addSignal(uiMessageChanged as ISignal);
		}

		public function onArtifactCollected(artifact:IArtifact):void
		{
			debug(this, "onArtifactCollected() - player collected artifact {0}", artifact.id);
			inventory.addArtifact(artifact);

			uiMessageChanged.message = "You got the (" + artifact.index + ")";
			uiMessageChanged.send(uiMessageChanged);

			checkForActivation();
		}

		public function onDebugLayerReady():void  { layerDebugReady = true; assessReadiness(); }

		public function onMapLoadCompleted():void  { setState(GameStateEnum.WAITING_TO_SHOW); }

		public function onMapLoadStarted():void  { setState(GameStateEnum.LOADING); }

		public function onMoonCaptured():void
		{
			debug(this, "onMoonCaptured() - player captured moon; yay, points!");
			if (compassState.captureMoonForArtifact(currentActivatedArtifactIndex))
			{
				uiMessageChanged.message = "You caught the moon!";
				uiMessageChanged.send(uiMessageChanged);

				setState(GameStateEnum.CAPTURING);
			}
			else
				throw new Error("wait, what?! how can currentActivatedArtifact not match what compassState is looking for?");
		}

		public function onMoonClicked():void
		{
			if (currentState == GameStateEnum.MOON_PAUSED)
			{
				moonTravelChanged.isMoving = true;
				moonTravelChanged.send(moonTravelChanged);
			}
		}

		public function onMoonTravelCompleted(day:uint):void
		{
			const firstDay:uint = Ephemeris.NUM_DAYS - 1;
			const lastDay:uint = 0;

			debug(this, "onMoonTravelCompleted() - orbit segment for day index {0} / {1} completed", day, Ephemeris.NUM_DAYS - 1);
			currentDay = day;

			// if one of the first two segments, stop time and unlock artifact			
			if (currentDay == firstDay)
			{
				timeScaleChanged.scale = 0;
				timeScaleChanged.send();

				if (currentState == GameStateEnum.ACTIVATING)
					setState(GameStateEnum.UNLOCKING);
				else
					checkForActivation();
			}
			// if one of the last two segments, unlock activated artifact or check for activation
			else if (currentDay == lastDay)
			{
				debug(this, "onMoonTravelCompleted() - last segments!");
				timeScaleChanged.scale = 0;
				timeScaleChanged.send();

				if (currentState == GameStateEnum.ACTIVATING)
					setState(GameStateEnum.UNLOCKING);
				else
					checkForActivation();
			}
			// accelerate in the middle, but hold until clicked
			else
			{
				timeScaleChanged.scale *= 1.05;
				timeScaleChanged.send();

				uiMessageChanged.message = "Where is the moon now?";
				uiMessageChanged.send(uiMessageChanged);

				setState(GameStateEnum.MOON_PAUSED);
			}


		}

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

		private function checkForActivation():void
		{
			if (inventory.hasArtifact(compassState.currentArtifactIndex))
				setState(GameStateEnum.ACTIVATING);
			else
			{
				debug(this, "checkForActivation() - inventory does not contain the currently sought index ({0})", compassState.currentArtifactIndex);

				uiMessageChanged.message = "You still need to collect the (" + compassState.currentArtifactIndex + ")!";
				uiMessageChanged.send(uiMessageChanged);
			}
		}


		private function onArtifactActivated(index:int):void
		{
			debug(this, "onArtifactActivated() - announcing activation of artifact {0}, setting state to ACTIVATED", index);
			currentActivatedArtifactIndex = index;

			artifactChanged.pointIndex = index;
			artifactChanged.pointState = CompassLightEnum.ACTIVATED;
			artifactChanged.send(artifactChanged as ICompassLightStateProvider);

			//uiMessageChanged.message = "You have activated the (" + index + ")!";
			//uiMessageChanged.send(uiMessageChanged);
		}

		private function onArtifactCaptured(index:int):void
		{
			if (compassState.capturesRemaining == 0)
			{
				debug(this, "onArtifactCaptured() - GAME OVER, YOU WIN!");

				uiMessageChanged.message = "Level 1 Complete!";
				uiMessageChanged.send(uiMessageChanged);
			}
			else
			{
				debug(this, "onArtifactCaptured() - announcing capture of artifact {0}, setting state to CAPTURED, telling moon to move", index);

				artifactChanged.pointIndex = index;
				artifactChanged.pointState = CompassLightEnum.CAPTURED;
				artifactChanged.send(artifactChanged as ICompassLightStateProvider);

				const t:Number = .42;
				timeScaleChanged.scale = t * t * t * (50 * 1000);
				timeScaleChanged.send();

				moonTravelChanged.isMoving = true;
				moonTravelChanged.send(moonTravelChanged);

					//uiMessageChanged.message = "You captured the (" + index + ")!";
					//uiMessageChanged.send(uiMessageChanged);
			}
		}

		private function onArtifactUnlocked(index:int):void
		{
			debug(this, "onArtifactUnlocked() - announcing unlocking of {0}, setting state to UNLOCKED", index);

			artifactChanged.pointIndex = index;
			artifactChanged.pointState = CompassLightEnum.UNLOCKED;
			artifactChanged.send(artifactChanged as ICompassLightStateProvider);

			uiMessageChanged.message = "The (" + index + ") is now unlocked";
			uiMessageChanged.send(uiMessageChanged);
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
					else if (moonPaused)
						nextState = GameStateEnum.MOON_PAUSED;
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

				case GameStateEnum.MOON_PAUSED:
					moonPaused = true;
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
