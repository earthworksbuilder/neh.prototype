package
{
    import away3d.cameras.Camera3D;
    import away3d.containers.View3D;
    import away3d.materials.BitmapMaterial;
    import away3d.primitives.Sphere;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    [SWF(width="1024", height="768", frameRate="50", backgroundColor="#FFFFFF")]
	public class SkySphere extends Sprite
	{
		protected const spinRate:Number = .625;
		protected const skySphereDiameter:Number = 2500;
		
		protected var cam:Camera3D;
		protected var lastKey:uint;
		protected var keyIsDown:Boolean = false;
		protected var view:View3D;
		protected var yaw:Matrix3D = new Matrix3D(); // looking left / right
		protected var pitch:Matrix3D = new Matrix3D(); // looking up / down
		
		[Embed(source="/../embeds/milky-way.jpg")]
        private var SkyTexture:Class;
		
		public function SkySphere()
		{
			// initialize view angle matrices
			yaw.identity();
			pitch.identity();
			
			// create a viewport
			view = new View3D();
			addChild(view);
			
			// snag a reference to the view's camera (default pos is at origin)
			cam = view.camera;
			
			// add a huge surrounding sphere centered around the origin
			var skyMaterial:BitmapMaterial = new BitmapMaterial(new SkyTexture().bitmapData);
			var largeSphere:Sphere = new Sphere(skyMaterial, skySphereDiameter, 14, 28);
			largeSphere.scaleX = -1; // scaled inside out so we can see the texture
			view.scene.addChild(largeSphere);
			
			// listen for key events and run every frame
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function update(e:Event):void
		{
			// adjust view rotations if user is pressing keys
			if(keyIsDown)
			{
                switch(lastKey)
                {
                    case Keyboard.UP    : adjustPitch(-spinRate); break;
                    case Keyboard.DOWN  : adjustPitch(+spinRate); break;
                    case Keyboard.LEFT  : adjustYaw(-spinRate); break;
                    case Keyboard.RIGHT : adjustYaw(+spinRate); break;
                }
            }
            
            // apply current view rotations
            cam.transform = cameraTransform;
            
            // render the view
            view.render();
		}
		
		protected function get cameraTransform():Matrix3D
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
			lastKey = e.keyCode;
			keyIsDown = true;
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			keyIsDown = false;
		}
	}
}
