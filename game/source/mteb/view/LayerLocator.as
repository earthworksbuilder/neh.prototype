package mteb.view
{
	import flash.display.DisplayObject;

	import mteb.view.debug.DebugLayer;
	import mteb.view.scene.SceneLayer;


	public class LayerLocator
	{
		private static var instance:LayerLocator;

		public static function getInstance():LayerLocator
		{
			return instance || (instance = new LayerLocator(new SingletonKey()));
		}

		private var _debug:DisplayObject;
		private var _scene:DisplayObject;


		public function LayerLocator(key:SingletonKey)
		{
			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);
		}

		public function get debug():DisplayObject  { return _debug || (_debug = new DebugLayer() as DisplayObject); }

		public function get scene():DisplayObject  { return _scene || (_scene = new SceneLayer() as DisplayObject); }
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
