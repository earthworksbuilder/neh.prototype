package
{
    import away3d.cameras.Camera3D;
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.Scene3D;
    import away3d.containers.View3D;
    import away3d.primitives.SkyBox;
    import away3d.textures.BitmapCubeTexture;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.net.URLRequest;
    import flash.ui.Keyboard;

    [SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	public class SkyboxTester extends Sprite
	{
		protected const spinRate:Number = .625;
		
		protected var view:View3D;
		protected var cam:Camera3D;
		protected var scene:Scene3D;
		protected var geo:ObjectContainer3D;
		
		protected var keysDown:Vector.<Boolean> = new <Boolean>[false, false, false, false];
		protected var yaw:Matrix3D = new Matrix3D(); // looking left / right
		protected var pitch:Matrix3D = new Matrix3D(); // looking up / down
		
		protected var images:Vector.<BitmapData> = new <BitmapData>[null,null,null,null,null,null];
		protected var loaders:Vector.<Loader> = new <Loader>[null,null,null,null,null,null];
		protected var imageUrls:Array = [
			"posX.png", "negX.png", 
			"posY.png", "negY.png", 
			"posZ.png", "negZ.png"
		];
		
		public function SkyboxTester()
		{
			for (var i:uint = 0; i < imageUrls.length; i++)
			{
				var imageRef:BitmapData = images[i];
				var handler:Function = function(event:Event):void { setImage(imageRef,event); }; // capture imageRef in closure
				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, handler);
				loaders[i].load(new URLRequest(imageUrls[i]));
			}
		}
		
		protected function setImage(image:BitmapData, event:Event):void
		{
			var bitmap:Bitmap = event.target.content as Bitmap;
			image = bitmap.bitmapData;
			//throw new Error("image="+image);
			
			var imagesLoaded:Boolean = true;
			for (var i:uint = 0; i < images.length; i++)
			{
				if (images[i] == null)
				{
					throw new Error("image " +i +" is null");
					imagesLoaded = false;
					break;
				}
			}
			if (imagesLoaded) initScene();
		}
		
		protected function initScene():void
		{
			throw new Error("initScene()");
			// initialize view angle matrices
			yaw.identity();
			pitch.identity();
			
			// create a viewport and add geometry to its scene
			view = new View3D();
			view.backgroundColor = 0x333333;
			addChild(view);
			
			geo = createGeo();
			
			scene = view.scene;
			scene.addChild(geo);
			
			cam = view.camera;
			
			// listen for key events and frame updates
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function update(e:Event):void
		{
			// adjust geo rotations if user is pressing keys
			if(keysDown[0]) adjustPitch(-spinRate);
			if(keysDown[1]) adjustPitch(+spinRate);
			if(keysDown[2]) adjustYaw(-spinRate);
			if(keysDown[3]) adjustYaw(+spinRate);
            
            // apply current user rotations
            cam.transform = userTransform;
            
            // render the view
            view.render();
		}
		
		protected function createGeo():ObjectContainer3D
		{
			var material:BitmapCubeTexture = new BitmapCubeTexture
			(
				images[0], images[1],
				images[2], images[3],
				images[4], images[5]
			);
			var geometry:SkyBox = new SkyBox(material);
			return geometry;
		}
		
		protected function get userTransform():Matrix3D
		{
			var xform:Matrix3D = cam.transform;
			xform.identity();
			xform.prepend(pitch);
			xform.append(yaw);
			return xform;
		}
		
		protected function adjustYaw(value:Number):void
		{
			yaw.prependRotation(value, Vector3D.Y_AXIS);
		}
		
		protected function adjustPitch(value:Number):void
		{
			pitch.prependRotation(value, Vector3D.X_AXIS);
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP    : keysDown[0] = true; break;
				case Keyboard.DOWN  : keysDown[1] = true; break;
				case Keyboard.LEFT  : keysDown[2] = true; break;
				case Keyboard.RIGHT : keysDown[3] = true; break;
			}
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP    : keysDown[0] = false; break;
				case Keyboard.DOWN  : keysDown[1] = false; break;
				case Keyboard.LEFT  : keysDown[2] = false; break;
				case Keyboard.RIGHT : keysDown[3] = false; break;
			}
		}
	}
}
