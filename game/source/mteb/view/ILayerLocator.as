package mteb.view
{
	import flash.display.DisplayObject;


	public interface ILayerLocator
	{
		function get debug():DisplayObject;

		function get scene():DisplayObject;
	}
}
