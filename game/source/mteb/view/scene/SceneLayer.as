package mteb.view.scene
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import starling.core.Starling;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.SignalBus;
	import mteb.control.gamestate.MCP;
	import mteb.control.signals.FrameEntered;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.data.time.ITime;
	import mteb.view.scene.fx.FxLayer;
	import mteb.view.scene.models.ModelLayer;


	public final class SceneLayer extends Sprite implements ISceneLayer, ISignalReceiver
	{


		protected var fxLayer:Starling;

		protected var stage3DManager:Stage3DManager;
		protected var stage3DProxy:Stage3DProxy;

		protected var modelLayer:ModelLayer;


		public function SceneLayer()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function get displayObject():DisplayObject  { return this as DisplayObject; }

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is FrameEntered):
					onFrameEntered(authority as ITime);
					break;

				case (signal is StageResized):
					onStageResized(authority as Stage);
					break;
			}
		}

		public function get view3D():View3D  { return modelLayer.view3D; }

		protected function onAddedToStage(event:Event):void
		{
			debug(this, "onAddedToStage()");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			stage3DManager = Stage3DManager.getInstance(stage);

			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.color = 0x000000;
			stage3DProxy.antiAlias = 8;

			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
		}

		protected function onContextCreated(event:Stage3DEvent):void
		{
			debug(this, "onContextCreated()");

			modelLayer = new ModelLayer();
			modelLayer.initialize();
			modelLayer.view3D.stage3DProxy = stage3DProxy;
			modelLayer.view3D.shareContext = true;
			addChild(modelLayer);

			fxLayer = new Starling(FxLayer, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(StageResized, this);

			debug(this, "scene layer ready...");
			const dataLocator:IDataLocator = DataLocator.getInstance();
			dataLocator.mcp.onSceneLayerReady();
		}

		protected function onFrameEntered(time:ITime):void
		{
			stage3DProxy.clear();

			modelLayer.onTimeElapsed(time);
			fxLayer.nextFrame();

			stage3DProxy.present();
		}

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);
			// updating the stage3DProxy updates the Starling engine as well
			stage3DProxy.width = stage.stageWidth;
			stage3DProxy.height = stage.stageHeight;
			modelLayer.view3D.width = stage.stageWidth;
			modelLayer.view3D.height = stage.stageHeight;
		}
	}
}
