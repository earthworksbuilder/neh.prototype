package mteb.view
{
	import mteb.view.debug.DebugLayer;
	import mteb.view.scene.SceneLayer;


	public class LayerLocator
	{
		private static var instance:LayerLocator;

		public static function getInstance():LayerLocator
		{
			return instance || (instance = new LayerLocator(new SingletonKey()));
		}

		private var _debug:Updatable;
		private var _scene:Updatable;


		public function LayerLocator(key:SingletonKey)
		{
			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);
		}

		public function get debug():Updatable  { return _debug || (_debug = new DebugLayer()); }

		public function get scene():Updatable  { return _scene || (_scene = new SceneLayer()); }
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
