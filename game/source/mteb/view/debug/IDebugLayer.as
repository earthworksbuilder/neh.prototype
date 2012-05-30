package mteb.view.debug
{
	import flash.display.DisplayObject;

	import away3d.containers.View3D;

	import mteb.control.interpreters.ICommandInterpreter;


	public interface IDebugLayer
	{
		function get commandParser():ICommandInterpreter;

		function get displayObject():DisplayObject;

		function set view3D(value:View3D):void;
	}
}
