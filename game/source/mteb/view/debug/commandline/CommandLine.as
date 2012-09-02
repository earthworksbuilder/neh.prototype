package mteb.view.debug.commandline
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;

	import pixeldroid.logging.appenders.console.ConsoleAppender;
	import pixeldroid.logging.appenders.console.ConsoleAppenderProperties;

	import mteb.control.interpreters.ICommandInterpreter;


	public class CommandLine extends Sprite
	{
		protected var properties:ConsoleAppenderProperties = new ConsoleAppenderProperties();
		protected var background:Shape;
		protected var cmd:TextField;
		protected var prompt:String;
		protected var parser:ICommandInterpreter;
		private var _console:ConsoleAppender; // ensure static font asset is in scope


		public function CommandLine(parser:ICommandInterpreter, prompt:String = "> ")
		{
			super();

			this.parser = parser;
			this.prompt = prompt;

			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function blur():void
		{
			stage.focus = null;
		}

		public function get commandParser():ICommandInterpreter  { return parser; }

		public function set commandParser(value:ICommandInterpreter):void  { parser = value; }

		public function get commandPrompt():String  { return prompt; }

		public function set commandPrompt(value:String):void  { prompt = value; }

		public function focus():void
		{
			stage.focus = cmd;
			cmd.text = prompt;
			const i:int = cmd.length;
			cmd.setSelection(i, i);
		}

		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

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
			cmd.type = TextFieldType.INPUT;
			cmd.antiAliasType = (format.size > 24) ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			cmd.gridFitType = GridFitType.PIXEL;
			cmd.embedFonts = true;
			cmd.defaultTextFormat = format;
			cmd.multiline = false;
			cmd.selectable = true;
			cmd.wordWrap = false;
			addChild(cmd);

			cmd.width = properties.width;
			cmd.height = properties.height;
			cmd.y = 2;

			cmd.text = prompt;
			cmd.restrict = "^`";

			cmd.addEventListener(KeyboardEvent.KEY_DOWN, onKeyTyped);
		}

		protected function onKeyTyped(event:KeyboardEvent):void
		{
			event.stopImmediatePropagation();

			const kc:uint = event.keyCode;
			switch (kc)
			{
				case Keyboard.ENTER:
					processCommandLine();
					break;

				case Keyboard.BACKQUOTE:
					dispatchEvent(event);
					break;
			}
		}

		protected function processCommandLine():void
		{
			var string:String = cmd.text;
			var i:uint = 0;
			while (string.charAt(i) == prompt.charAt(i))
				i++;
			string = string.substring(i);

			if (parser.processCommand(string))
				cmd.text = prompt;
			else
				error(this, "processCommandLine() - unknown command '{0}'", string);
		}
	}
}
