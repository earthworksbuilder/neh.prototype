package mteb.view.debug
{
	import flash.display.Sprite;
	import flash.events.Event;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;


	public class DebugLayer extends Sprite
	{
		protected var console:ConsoleAppender;


		public function DebugLayer()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			console = new ConsoleAppender();
			LogDispatcher.addAppender(console);

			debug(this, "constructor");
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			addChild(console);
			console.y = stage.stageHeight - console.height; // console height is not set until after added to stage

			debug(this, "console added to stage");
		}
	}
}
