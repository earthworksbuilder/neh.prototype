package mteb.view.debug
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	import away3d.containers.View3D;
	import away3d.debug.AwayStats;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;
	import pixeldroid.logging.appenders.console.ConsoleAppenderProperties;


	public class DebugLayer extends Sprite implements IDebugLayer
	{
		protected var console:ConsoleAppender;
		protected var cmd:CommandLine;
		protected var stats:AwayStats;


		public function DebugLayer()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			debug(this, "constructor");
		}

		public function get displayObject():DisplayObject  { return this as DisplayObject; }

		public function set view3D(value:View3D):void  { stats.registerView(value); }

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			const consolePrefs:ConsoleAppenderProperties = new ConsoleAppenderProperties();
			consolePrefs.width = stage.stageWidth;
			consolePrefs.height = stage.stageHeight - 80;

			console = new ConsoleAppender(consolePrefs);
			console.hide();

			LogDispatcher.addAppender(console);

			addChild(console);
			console.x = 0;
			console.y = 0;

			cmd = new CommandLine();
			addChild(cmd);
			cmd.x = 0;
			cmd.y = console.y + console.height;

			stats = new AwayStats();
			addChild(stats);
			stats.x = stage.stageWidth - stats.width;
			stats.y = 0;

			debug(this, "console added to stage");
		}
	}
}
