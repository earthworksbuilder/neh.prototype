package mteb.view.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.assets.Fonts;
	import mteb.control.SignalBus;
	import mteb.control.signals.FrameEntered;
	import mteb.control.signals.MoonClicked;
	import mteb.control.signals.StageResized;
	import mteb.control.signals.UiMessageChanged;
	import mteb.data.time.ITime;
	import mteb.data.time.ITimeDriven;


	public class MessageControl extends Sprite implements ISignalReceiver
	{
		private const FADE_SPEED:Number = .12; // alpha percent per second

		private const messageQueue:Vector.<String> = new <String>[];
		private var message:TextField;


		public function MessageControl()
		{
			super();
			initialize();
		}

		public function initialize():void
		{
			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(FrameEntered, this);
			signalBus.addReceiver(UiMessageChanged, this);
			signalBus.addReceiver(StageResized, this);

			const format:TextFormat = new TextFormat();
			format.font = Fonts.titleFontName;
			format.color = 0xffffff;
			format.size = 48;
			format.align = TextFormatAlign.CENTER;

			message = new TextField();
			message.antiAliasType = (format.size > 24) ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			message.gridFitType = GridFitType.PIXEL;
			message.embedFonts = true;
			message.defaultTextFormat = format;
			message.multiline = true;
			message.selectable = false;
			message.wordWrap = true;
			message.width = 800;
			message.height = 600;

			addChild(message);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is FrameEntered):
					onFrameEntered(authority as ITime);
					break;

				case signal is UiMessageChanged:
					onUiMessageChanged((authority as UiMessageChanged).message);
					break;

				case (signal is StageResized):
					onStageResized(authority as Stage);
					break;
			}
		}

		protected function onFrameEntered(time:ITime):void
		{
			if (message.text.length > 0)
			{
				const decrement:Number = time.secondsElapsed * FADE_SPEED;
				const accelerator:Number = (1 - message.alpha) * decrement;
				message.alpha -= (decrement + accelerator);
			}

			if (message.alpha < .10)
			{
				message.text = "";
				if (messageQueue.length > 0)
					setMessage(messageQueue.shift());
			}
		}

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);
			message.width = Math.round(stage.stageWidth * .75);
			message.height = Math.round(stage.stageHeight * .75);
			centerObject(message);
		}

		protected function onUiMessageChanged(string:String):void
		{
			if (message.text.length == 0)
				setMessage(string);
			else
				messageQueue.push(string);
		}

		private function centerObject(displayObject:DisplayObject):void
		{
			displayObject.x = Math.round((stage.stageWidth - displayObject.width) * .5);
			displayObject.y = Math.round((stage.stageHeight - displayObject.height) * .5);
		}

		private function onAddedToStage(event:Event):void
		{
		}

		private function onRemovedFromStage(event:Event):void
		{
		}

		private function setMessage(text:String):void
		{
			message.text = text;
			message.alpha = 1.00;

			centerObject(message);
		}
	}
}
