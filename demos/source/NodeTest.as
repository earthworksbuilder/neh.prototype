package
{
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.materials.ColorMaterial;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.primitives.SphereGeometry;
    import away3d.textures.BitmapTexture;
    
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Vector3D;
    import flash.utils.getTimer;

    [SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class NodeTest extends Sprite
	{
		[Embed(source="/../embeds/milky-way.jpg")]
        protected const SkyTexture:Class;
		
		[Embed(source="../embeds/newark-octagon/A-negX.png")]
		protected const GroundNegX:Class;
		[Embed(source="../embeds/newark-octagon/A-negY.png")]
		protected const GroundNegY:Class;
		[Embed(source="../embeds/newark-octagon/A-negZ.png")]
		protected const GroundNegZ:Class;
		
		[Embed(source="../embeds/newark-octagon/A-posX.png")]
		protected const GroundPosX:Class;
		[Embed(source="../embeds/newark-octagon/A-posY.png")]
		protected const GroundPosY:Class;
		[Embed(source="../embeds/newark-octagon/A-posZ.png")]
		protected const GroundPosZ:Class;
		
		protected const spinRate:Number = .825;
		protected const skySphereRadius:Number = 999;
		protected var lastTime:int;
		
		protected var view:View3D;
		protected var userTransform:UserTransform;
		protected var skyGeo:ObjectContainer3D;
		protected var groundGeo:ObjectContainer3D;
		
		public function NodeTest()
		{
			super();
			
			// create a viewport and add it to the stage
			view = new View3D();
			view.backgroundColor = 0x333333;
			addChild(view);
			
			// set camera at origin
			view.camera.position = new Vector3D(0, 0, 0);
			view.camera.lookAt(new Vector3D(0, 0, 50));
			
			// add geometry to the scene
			var sceneGeo:ObjectContainer3D = new ObjectContainer3D();
			skyGeo = createSkyGeo();
			groundGeo = createGroundGeo();
			sceneGeo.addChildren(skyGeo, groundGeo);
			view.scene.addChild(sceneGeo);
			
			// let user manipulate camera orientation
			userTransform = new UserTransform(stage, view.camera.transform);
			
			// listen for enterframe to to render updates
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function update(e:Event):void
		{
			var s:Number = elapsed;
			
			// apply current user rotations
			userTransform.update();
			view.camera.transform = userTransform.value;
			
			// spin the sky
            skyGeo.rotationY += .25 * s;
			
            // render the view
            view.render();
		}
		
		protected function get elapsed():Number
		{
			var now:int = getTimer();
			var value:Number = (lastTime ? (now - lastTime) : now) * .001; // seconds elapsed
			lastTime = now;
			return value;
		}
		
		protected function createSkyGeo():ObjectContainer3D
		{
			var geometry:SphereGeometry = new SphereGeometry(skySphereRadius);
			var material:TextureMaterial = new TextureMaterial(new BitmapTexture(new SkyTexture().bitmapData));
			material.bothSides = true;
			var mesh:Mesh = new Mesh(geometry, material);
			return mesh;
		}
				
		protected function createGroundGeo():ObjectContainer3D
		{
			var r:Number = 50;
			
			var posZMesh:Mesh = createTexturedPlane(r*2, new GroundPosZ().bitmapData, false);
			posZMesh.translate(Vector3D.Z_AXIS,  r);
			
			var negZMesh:Mesh = createTexturedPlane(r*2, new GroundNegZ().bitmapData, false);
			negZMesh.rotationY = 180;
			negZMesh.translate(Vector3D.Z_AXIS, -r);
			
			var posXMesh:Mesh = createTexturedPlane(r*2, new GroundPosX().bitmapData, false);
			posXMesh.rotationY = 90;
			posXMesh.translate(Vector3D.X_AXIS,  r);
			
			var negXMesh:Mesh = createTexturedPlane(r*2, new GroundNegX().bitmapData, false);
			negXMesh.rotationY = -90;
			negXMesh.translate(Vector3D.X_AXIS, -r);
			
			var ground:ObjectContainer3D = new ObjectContainer3D();
			ground.addChildren(posZMesh, negZMesh, posXMesh, negXMesh);
			
			return ground;
		}
		
		protected function createTexturedPlane(dim:Number, bitmapData:BitmapData, horizontal:Boolean):Mesh
		{
			var seg:uint = 1;
			
			var geo:PlaneGeometry = new PlaneGeometry(dim, dim, seg, seg, horizontal);
			var mat:TextureMaterial = new TextureMaterial(new BitmapTexture(bitmapData));
			mat.alphaBlending = true;
			
			var mesh:Mesh = new Mesh(geo, mat);
			return mesh;
		}
	}
}
