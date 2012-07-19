package mteb.view
{
	import flash.display.DisplayObject;

	import mteb.view.debug.DebugLayer;
	import mteb.view.debug.IDebugLayer;
	import mteb.view.scene.ISceneLayer;
	import mteb.view.scene.SceneLayer;
	import mteb.view.title.TitleLayer;
	import mteb.view.ui.UiLayer;


	public final class LayerLocator implements ILayerLocator
	{
		private static var instance:ILayerLocator;

		public static function getInstance():ILayerLocator
		{
			return instance || (instance = new LayerLocator(new SingletonKey()));
		}

		private var _debug:IDebugLayer;
		private var _ui:DisplayObject;
		private var _title:DisplayObject;
		private var _scene:ISceneLayer;


		public function LayerLocator(key:SingletonKey)
		{
			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);
		}

		public function get debug():IDebugLayer  { return _debug || (_debug = new DebugLayer() as IDebugLayer); }

		public function get scene():ISceneLayer  { return _scene || (_scene = new SceneLayer() as ISceneLayer); }

		public function get title():DisplayObject  { return _title || (_title = new TitleLayer() as DisplayObject); }

		public function get ui():DisplayObject  { return _ui || (_ui = new UiLayer() as DisplayObject); }
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
