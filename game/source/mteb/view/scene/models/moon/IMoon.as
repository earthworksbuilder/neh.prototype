package mteb.view.scene.models.moon
{
	import flash.geom.Point;

	import away3d.entities.Mesh;
	import away3d.lights.LightBase;

	import mteb.data.time.ITimeDriven;


	public interface IMoon extends ITimeDriven
	{
		function get geometry():Mesh;

		function get lights():Vector.<LightBase>;

		function onClicked(screenCoords:Point):void;

		function get radius():Number;

		function get state():MoonStateEnum;
	}
}
