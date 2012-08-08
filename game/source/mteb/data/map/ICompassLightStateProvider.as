package mteb.data.map
{
	import mteb.view.scene.models.compass.CompassLightEnum;


	public interface ICompassLightStateProvider
	{
		function get pointIndex():uint;

		function get pointState():CompassLightEnum;
	}
}
