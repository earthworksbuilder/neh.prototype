package mteb.view.debug
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	import away3d.containers.View3D;
	import away3d.debug.AwayStats;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;
	import pixeldroid.logging.appenders.console.ConsoleAppenderProperties;

	import mteb.control.interpreters.CommandInterpreter;
	import mteb.control.CommandLineInitializer;
	import mteb.view.debug.commandline.CommandLine;
	import mteb.control.interpreters.ICommandInterpreter;


	public class DebugLayer extends Sprite implements IDebugLayer
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

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			debug(this, "constructor");
		}

		public function get commandParser():ICommandInterpreter  { return cmd.commandParser; }

		public function get displayObject():DisplayObject  { return this as DisplayObject; }

		public function set view3D(value:View3D):void  { stats.registerView(value); }

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addChild(container);

			const consolePrefs:ConsoleAppenderProperties = new ConsoleAppenderProperties();
			consolePrefs.width = stage.stageWidth;
			consolePrefs.height = stage.stageHeight - 80;

			console = new ConsoleAppender(consolePrefs);
			container.addChild(console);
			console.x = 0;
			console.y = 0;
			LogDispatcher.addAppender(console);

			const ci:ICommandInterpreter = new CommandInterpreter();
			CommandLineInitializer.execute(ci);

			cmd = new CommandLine(ci);
			container.addChild(cmd);
			cmd.x = 0;
			cmd.y = console.y + console.height;

			stats = new AwayStats();
			container.addChild(stats);
			stats.x = stage.stageWidth - stats.width;
			stats.y = 0;

			debug(this, "debug layer ready");
			updateVis();
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

		protected function updateVis():void
		{
			if (showing)
			{
				console.show();
				addChild(container);
			}
			else
			{
				console.hide();
				removeChild(container);
			}
		}
	}
}
