package mteb.view.scene
{
	import flash.display.DisplayObject;

	import away3d.containers.View3D;


	public interface ISceneLayer
	{

		function get displayObject():DisplayObject;
		function get view3D():View3D;
	}
}
