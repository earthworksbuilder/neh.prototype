package mteb.view.debug
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import pixeldroid.logging.LogDispatcher;
	import pixeldroid.logging.appenders.console.ConsoleAppender;

	import mteb.view.Updatable;


	public class DebugLayer extends Sprite implements Updatable
	{
		public function DebugLayer()
		{
			super();

			var c:ConsoleAppender = new ConsoleAppender();
			addChild(c);
			LogDispatcher.addAppender(c);

			debug(this, "constructor");
		}

		public function get displayObject():DisplayObject  { return this as DisplayObject; }

		public function update(s:Number):void
		{
		}
	}
}
