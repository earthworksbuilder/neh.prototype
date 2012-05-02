package mteb.view.debug
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import pixeldroid.logging.appenders.console.ConsoleAppender;
	import pixeldroid.logging.appenders.console.ConsoleAppenderProperties;


	public class CommandLine extends Sprite
	{
		protected var properties:ConsoleAppenderProperties = new ConsoleAppenderProperties();
		protected var background:Shape;
		protected var cmd:TextField;
		private var _console:ConsoleAppender; // ensure static font asset is in scope


		public function CommandLine()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);

			properties.width = stage.width;
			properties.height = properties.fontSize + 4;

			background = new Shape();
			background.graphics.beginFill(properties.backColor, properties.backAlpha);
			background.graphics.drawRect(0, 0, properties.width, properties.height);
			background.graphics.endFill();
			addChild(background);

			var format:TextFormat = new TextFormat();
			format.font = "FONT_CONSOLE";
			format.color = properties.foreColor;
			format.size = properties.fontSize;
			format.align = TextFormatAlign.LEFT;
			format.leading = properties.leading;

			cmd = new TextField();
			cmd.antiAliasType = (format.size > 24) ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			cmd.gridFitType = GridFitType.PIXEL;
			cmd.embedFonts = true;
			cmd.defaultTextFormat = format;
			cmd.multiline = true;
			cmd.selectable = true;
			cmd.wordWrap = true;
			addChild(cmd);

			cmd.width = properties.width;
			cmd.height = properties.height;

			cmd.text = "would you like to play a game? > ";
		}

		protected function keyDownHandler(e:KeyboardEvent):void
		{

		}
	}
}
