package mteb.data.map
{
	import mteb.view.scene.compass.CompassLightEnum;


	public interface ICompassLightStateProvider
	{
		function get pointIndex():uint;

		function get pointState():CompassLightEnum;
	}
}
