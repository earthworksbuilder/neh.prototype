package mteb.view.debug
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	import away3d.Away3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;
	import pixeldroid.logging.appenders.console.ConsoleAppenderProperties;
	import pixeldroid.signals.ISignal;
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.ISignalReceiver;

	import mteb.control.CommandLineInitializer;
	import mteb.control.SignalBus;
	import mteb.control.interpreters.CommandInterpreter;
	import mteb.control.interpreters.ICommandInterpreter;
	import mteb.control.signals.StageResized;
	import mteb.data.DataLocator;
	import mteb.data.IDataLocator;
	import mteb.view.debug.commandline.CommandLine;


	public final class DebugLayer extends Sprite implements IDebugLayer, ISignalReceiver
	{
		protected const container:Sprite = new Sprite();
		protected var showing:Boolean = false;
		protected var console:ConsoleAppender;
		protected var cmd:CommandLine;
		protected var stats:AwayStats;
		protected const hideCharCode:uint = '`'.charCodeAt(0);


		public function DebugLayer()
		{
			super();

			const signalBus:ISignalBus = SignalBus.getInstance();
			signalBus.addReceiver(StageResized, this);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			debug(this, "constructor");
		}

		public function get commandParser():ICommandInterpreter  { return cmd.commandParser; }

		public function get displayObject():DisplayObject  { return this as DisplayObject; }

		public function receive(signal:ISignal, authority:* = null):void
		{
			switch (true)
			{
				case (signal is StageResized):
					onStageResized(authority as Stage);
					break;

				default:
					debug(this, "receive() - unrecognized signal {0}", signal);
					break;
			}
		}

		public function set view3D(value:View3D):void
		{
			debug(this, "set view3D() - Away3d v{0}.{1}.{2}", Away3D.MAJOR_VERSION, Away3D.MINOR_VERSION, Away3D.REVISION);
			stats.registerView(value);
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			addChild(container);

			container.addChild(console = new ConsoleAppender());
			LogDispatcher.addAppender(console);

			const ci:ICommandInterpreter = new CommandInterpreter();
			CommandLineInitializer.execute(ci);
			container.addChild(cmd = new CommandLine(ci));
			cmd.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			container.addChild(stats = new AwayStats());

			onStageResized(stage);
			updateVis();

			debug(this, "debug layer ready...");
			const dataLocator:IDataLocator = DataLocator.getInstance();
			dataLocator.mcp.onDebugLayerReady();
		}

		protected function onKeyDown(event:KeyboardEvent):void
		{
			event.stopImmediatePropagation();

			const cc:uint = event.charCode;
			switch (cc)
			{
				case hideCharCode:
					showing = !showing;
					updateVis();
					break;
			}
		}

		protected function onStageResized(stage:Stage):void
		{
			debug(this, "onStageResized() - adjusting to new dimensions: {0}x{1}", stage.stageWidth, stage.stageHeight);

			const consoleProperties:ConsoleAppenderProperties = new ConsoleAppenderProperties();
			consoleProperties.width = Math.min(1024, stage.stageWidth);
			consoleProperties.height = Math.min(768 - 80, stage.stageHeight - 80);
			console.properties = consoleProperties;
			console.x = 0;
			console.y = 0;

			cmd.x = 0;
			cmd.y = console.y + console.height;

			stats.x = stage.stageWidth - stats.width;
			stats.y = 0;
		}

		protected function updateVis():void
		{
			if (showing)
			{
				console.show();
				addChild(container);
				cmd.focus();
			}
			else
			{
				cmd.blur();
				console.hide();
				removeChild(container);
			}
		}
	}
}
