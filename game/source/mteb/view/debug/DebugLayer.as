package mteb.view.debug
{
	import flash.display.Sprite;
	import flash.events.Event;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;
	import pixeldroid.logging.appenders.console.ConsoleAppenderProperties;


	public class DebugLayer extends Sprite
	{
		protected var console:ConsoleAppender;


		public function DebugLayer()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			debug(this, "constructor");
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			const consolePrefs:ConsoleAppenderProperties = new ConsoleAppenderProperties();
			consolePrefs.width = stage.stageWidth;
			consolePrefs.height = stage.stageHeight;

			console = new ConsoleAppender(consolePrefs);
			console.hide();

			LogDispatcher.addAppender(console);

			addChild(console);
			console.x = 0;
			console.y = 0;

			debug(this, "console added to stage");
		}
	}
}
