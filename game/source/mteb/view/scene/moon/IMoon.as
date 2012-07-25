package mteb.view.scene.moon
{
	import away3d.entities.Mesh;
	import away3d.lights.LightBase;

	import mteb.data.time.ITimeDriven;


	public interface IMoon extends ITimeDriven
	{
		function get geometry():Mesh;

		function get lights():Vector.<LightBase>;

		function onClicked():void;

		function get radius():Number;

		function get state():MoonStateEnum;
	}
}
