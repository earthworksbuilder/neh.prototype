package mteb.view
{
	import flash.display.DisplayObject;

	import mteb.view.debug.IDebugLayer;
	import mteb.view.scene.ISceneLayer;


	public interface ILayerLocator
	{
		function get debug():IDebugLayer;

		function get scene():ISceneLayer;

		function get title():DisplayObject;

		function get ui():DisplayObject;
	}
}
