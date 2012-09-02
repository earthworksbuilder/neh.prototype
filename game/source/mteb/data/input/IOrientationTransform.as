package mteb.data.input
{
	import flash.geom.Matrix3D;


	public interface IOrientationTransform extends IKeyboardDriven
	{
		function get initialValue():Matrix3D

		function set initialValue(value:Matrix3D):void

		function get spinRate():Number;

		function set spinRate(value:Number):void;

		function get value():Matrix3D;
	}
}
