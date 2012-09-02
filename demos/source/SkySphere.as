package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;


	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class SkySphere extends Sprite
	{
		[Embed(source="/../embeds/starfield-2048x1024.png")]
		protected const SkyTexture:Class;
		protected const skySphereRadius:Number = 999;

		protected const spinRate:Number = .825;
		protected var userTransform:UserTransform;

		protected var view:View3D;


		public function SkySphere()
		{
			super();

			// create a viewport and add it to the stage
			view = new View3D();
			view.backgroundColor = 0x333333;
			addChild(view);

			// add geometry to the scene
			view.scene.addChild(sceneGeo);

			view.camera.position = new Vector3D(0, 0, 0);
			view.camera.rotate(Vector3D.X_AXIS, -85);

			// let user manipulate camera orientation
			userTransform = new UserTransform(stage, view.camera.transform);

			// listen for enterframe to to render updates
			addEventListener(Event.ENTER_FRAME, update);
		}

		protected function get sceneGeo():ObjectContainer3D
		{
			var geometry:SphereGeometry = new SphereGeometry(skySphereRadius);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(new SkyTexture().bitmapData));
			material.bothSides = true;
			var mesh:Mesh = new Mesh(geometry, material);
			mesh.rotate(Vector3D.Y_AXIS, -115);
			return mesh;
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
