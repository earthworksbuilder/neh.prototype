package mteb.view.scene.fx
{
	import flash.geom.Point;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.assets.Particles;
	import mteb.control.SignalBus;
	import mteb.control.signals.MoonClicked;
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
			signalBus.addReceiver(MoonClicked, this);

			particles = Particles.starParticleSystem;
			addChild(particles);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function onTimeElapsed(time:ITime):void
		{
			// no-op, Starling juggler handles frame updates
		}

		public function pointSplash(emitterX:Number, emitterY:Number):void
		{
			particles.emitterX = emitterX;
			particles.emitterY = emitterY;
			particles.start(.65);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case signal is MoonClicked:
					var coords:Point = authority as Point;
					pointSplash(coords.x, coords.y);
					break;
			}
		}

		private function onAddedToStage(event:Event):void
		{
			Starling.juggler.add(particles);
		}

		private function onRemovedFromStage(event:Event):void
		{
			particles.stop();
			Starling.juggler.remove(particles);
		}
	}
}
