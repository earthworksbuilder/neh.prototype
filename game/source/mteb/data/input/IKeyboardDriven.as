package mteb.data.input
{
	import flash.events.KeyboardEvent;


	public interface IKeyboardDriven
	{
		function onKeyDown(e:KeyboardEvent):void;

		function onKeyUp(e:KeyboardEvent):void;
	}
}
