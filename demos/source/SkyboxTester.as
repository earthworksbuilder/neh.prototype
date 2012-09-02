package
{
	import flash.display.Sprite;
	import flash.events.Event;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.primitives.SkyBox;


	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	public class SkyboxTester extends Sprite
	{
		protected var bitmapCubeLoader:BitmapCubeLoader;
		protected var userTransform:UserTransform;
		protected var view:View3D;


		public function SkyboxTester()
		{
			bitmapCubeLoader = new BitmapCubeLoader("posX.png", "negX.png", "posY.png", "negY.png", "posZ.png", "negZ.png", initScene);
		}

		protected function createGeo():ObjectContainer3D
		{
			// create a skybox with texture form the loaded images
			var geometry:SkyBox = new SkyBox(bitmapCubeLoader.getCubeTextureFor());
			return geometry;
		}

		protected function initScene():void
		{
			// create a viewport and add geometry to its scene
			view = new View3D();
			view.backgroundColor = 0x333333;
			view.scene.addChild(createGeo());
			addChild(view);

			// let user manipulate camera orientation
			userTransform = new UserTransform(stage, view.camera.transform);

			// listen for key events and frame updates
			addEventListener(Event.ENTER_FRAME, update);
		}

		protected function update(e:Event):void
		{
			// apply current user rotations
			userTransform.update();
			view.camera.transform = userTransform.value;

			// render the view
			view.render();
		}
	}
}
