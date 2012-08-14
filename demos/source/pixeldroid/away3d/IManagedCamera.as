package pixeldroid.away3d
{
	import flash.display.Stage;
	import flash.events.Event;

	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;


	public interface IManagedCamera
	{
		function get camera():Camera3D;
		function set camera(value:Camera3D):void;

		function get cameraIsMoving():Boolean;
		function set cameraIsMoving(value:Boolean):void;

		function get lookAtObject():ObjectContainer3D;
		function set lookAtObject(value:ObjectContainer3D):void;

		function get stage():Stage;
		function set stage(value:Stage):void;

		function update(e:Event = null):void;
	}
}
