package
{
    import away3d.cameras.Camera3D;
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.Scene3D;
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.SphereGeometry;
    import away3d.textures.BitmapTexture;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    [SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class SkySphere extends Sprite
	{
		[Embed(source="/../embeds/milky-way.jpg")]
        protected const SkyTexture:Class;
		
		protected const spinRate:Number = .625;
		protected const skySphereRadius:Number = 2500;
		
		protected var view:View3D;
		protected var cam:Camera3D;
		protected var scene:Scene3D;
		
		protected var lastKey:uint;
		protected var keyIsDown:Boolean = false;
		protected var yaw:Matrix3D = new Matrix3D(); // looking left / right
		protected var pitch:Matrix3D = new Matrix3D(); // looking up / down
		
		public function SkySphere()
		{
			// initialize view angle matrices
			yaw.identity();
			pitch.identity();
			
			// create a viewport
			view = new View3D();
			addChild(view);
			
			// snag a reference to the view's default camera (default pos is at origin)
			cam = view.camera;
			
			// snag a reference to the view's default scene and add geometry to it
			scene = view.scene;
			scene.addChild(sceneGeo);
			
			// listen for key events and frame updates
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			addEventListener(Event.ENTER_FRAME,update);
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
		
		protected function get sceneGeo():ObjectContainer3D
		{
			var geometry:SphereGeometry = new SphereGeometry(skySphereRadius);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(new SkyTexture().bitmapData));
			var mesh:Mesh = new Mesh(geometry, material);
			mesh.scaleX = -1; // scaled inside out to show texture while inside
			return mesh;
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
