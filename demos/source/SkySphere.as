// from: http://www.flashmagazine.com/Tutorials/detail/away3d_basics_5_-_primitives_part_2/
package
{
    import away3d.cameras.Camera3D;
    import away3d.containers.View3D;
    import away3d.materials.BitmapMaterial;
    import away3d.primitives.Sphere;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    [SWF(width="500", height="400", frameRate="50", backgroundColor="#FFFFFF")]
	public class SkySphere extends Sprite
	{
		private var cam:Camera3D;
		private var lastKey:uint;
		private var keyIsDown:Boolean = false;
		public var view:View3D;
		
		[Embed(source="/../embeds/milky-way.jpg")]
        private var SkyTexture:Class;
		
		public function SkySphere()
		{
			// create a viewport
			view = new View3D();
			addChild(view);
			
			// make sure the camera is positioned away from the default 0,0,0 coordinate
			view.camera.z = -1000;
			
			// add a huge surrounding sphere so we really can see what we're doing
			var skyMaterial:BitmapMaterial = new BitmapMaterial(new SkyTexture().bitmapData);
			var largeSphere:Sphere = new Sphere(skyMaterial, 1500, 14, 28);
			largeSphere.scaleX = -1;
			view.scene.addChild(largeSphere);
			
			// listen for key events and run every frame
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		
		public function update(e:Event):void
		{
			/*
			if(keyIsDown){
                // if the key is still pressed, just keep on moving
                switch(lastKey){
                    case Keyboard.UP	: cam.tiltAngle -= 5; break;
                    case Keyboard.DOWN	: cam.tiltAngle += 5; break;
                    case 87				: cam.zoom += 0.3; break;
                    case 83				: if(cam.zoom > 1.4){cam.zoom -= 0.3} break;
                    case Keyboard.LEFT	: cam.panAngle -= 5; break;
                    case Keyboard.RIGHT	: cam.panAngle += 5; break;
                }
            }
            */
            // render the view
            view.render();
		}
		private function onKeyDown(e:KeyboardEvent):void
		{
			lastKey = e.keyCode;
			keyIsDown = true;
		}
		private function onKeyUp(e:KeyboardEvent):void
		{
			keyIsDown = false;
		}
	}
}
