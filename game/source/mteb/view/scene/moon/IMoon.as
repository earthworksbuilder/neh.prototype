package mteb.view.scene.moon
{
	import away3d.entities.Mesh;


	public interface IMoon
	{
		function get geometry():Mesh;

		function get radius():Number;

		function get state():MoonStateEnum;
	}
}
