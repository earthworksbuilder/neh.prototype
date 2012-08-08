package mteb.view.scene.fx
{
	import flash.display.Stage;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.assets.Particles;
	import mteb.control.SignalBus;
	import mteb.control.signals.StageResized;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;


	public class FxLayer extends Sprite implements ITimeDriven, ISignalReceiver
	{
		protected var particles:PDParticleSystem;


		public function FxLayer()
		{
			super();
			initialize();
		}

		public function initialize():void
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(StageResized, this);

			particles = Particles.starParticleSystem;
			addChild(particles);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function onTimeElapsed(time:ITime):void
		{

		}

		public function pointSplash(emitterX:Number, emitterY:Number):void
		{
			particles.emitterX = emitterX;
			particles.emitterY = emitterY;
			particles.start(1.5);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is StageResized):
					onStageResized(authority as Stage);
					break;
			}
		}

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);
		}

		private function onAddedToStage(event:Event):void
		{
			Starling.juggler.add(particles);
			particles.emitterX = stage.stageWidth / 2;
			particles.emitterY = stage.stageHeight / 2;
			particles.start();
		}

		private function onRemovedFromStage(event:Event):void
		{
			Starling.juggler.remove(particles);
			particles.stop();
		}
	}
}
