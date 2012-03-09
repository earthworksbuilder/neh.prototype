package mteb.view
{
	import flash.display.DisplayObject;


	public interface Updatable
	{

		function get displayObject():DisplayObject;
		function update(s:Number):void;
	}
}
