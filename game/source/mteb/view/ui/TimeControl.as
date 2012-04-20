package mteb.view.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import pixeldroid.signals.ISignalBus;

	import mteb.command.SignalBus;
	import mteb.command.signals.TimeScaleChanged;


	public class TimeControl extends Sprite
	{
		protected const MAX_MULTIPLIER:Number = 50 * 1000;

		protected const timeScaleChanged:TimeScaleChanged = new TimeScaleChanged();


		public function TimeControl()
		{
			super();
			initialize();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addSignal(timeScaleChanged);

			addEventListener(MouseEvent.CLICK, onClicked);
		}

		protected function initialize():void
		{
			const g:Graphics = graphics;
			g.beginFill(0x888888);
			g.drawRect(0, 0, 300, 30);
			g.endFill();

			buttonMode = true;
			useHandCursor = true;
		}

		protected function onClicked(event:MouseEvent):void
		{
			const t:Number = (event.localX / width) * 2 - 1;
			debug(this, "onClicked() - t: {0}", t);

			timeScaleChanged.scale = t * t * t * MAX_MULTIPLIER;
			timeScaleChanged.send();
		}
	}
}
