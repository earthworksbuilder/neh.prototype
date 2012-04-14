package mteb.view.ui
{
	import flash.display.Sprite;
	import flash.events.Event;


	public class UiLayer extends Sprite
	{
		protected var heading:HeadingDisplay;
		protected var timeControl:TimeControl;
		protected var mapControl:MapControl;


		public function UiLayer()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			heading = new HeadingDisplay();
			heading.x = 0;
			heading.y = stage.stageHeight - heading.height;
			addChild(heading);

			timeControl = new TimeControl();
			timeControl.x = (stage.stageWidth * .5) - (timeControl.width * .5);
			timeControl.y = stage.stageHeight - timeControl.height;
			addChild(timeControl);

			mapControl = new MapControl();
			mapControl.x = stage.stageWidth - mapControl.width;
			mapControl.y = stage.stageHeight - mapControl.height;
			addChild(mapControl);

			debug(this, "ui layer added to stage");
		}
	}
}
