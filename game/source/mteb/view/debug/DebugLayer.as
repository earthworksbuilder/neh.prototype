package mteb.view.debug
{
	import flash.display.Sprite;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;


	public class DebugLayer extends Sprite
	{
		public function DebugLayer()
		{
			super();

			var c:ConsoleAppender = new ConsoleAppender();
			addChild(c);
			LogDispatcher.addAppender(c);

			debug(this, "constructor");
		}
	}
}
