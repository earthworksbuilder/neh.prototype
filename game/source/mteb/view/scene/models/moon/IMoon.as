package mteb.view.scene.models.moon
{
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.LightBase;

	import mteb.data.time.ITimeDriven;


	public interface IMoon extends ITimeDriven
	{
		function get geometry():Mesh;

		function get lights():Vector.<LightBase>;

		function onClicked(event:MouseEvent3D):void;

		function get radius():Number;

		function get state():MoonStateEnum;
	}
}
