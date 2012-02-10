package
{
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.primitives.SphereGeometry;
    import away3d.textures.BitmapTexture;
    
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.utils.getTimer;
    
    import pixeldroid.logging.LogDispatcher;
    import pixeldroid.logging.appenders.console.ConsoleAppender;
		

    [SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class NodeTest extends Sprite
	{
		[Embed(source="/../embeds/milky-way.jpg")]
        protected const SkyTexture:Class;
		
		protected const skySphereRadius:Number = 999;
		protected var lastTime:int;
		
		protected var view:View3D;
		protected var userTransform:UserTransform;
		protected var bitmapCubeLoader:BitmapCubeLoader;
		protected var skyGeo:ObjectContainer3D;
		protected var groundGeo:ObjectContainer3D;
		
		protected var currentNode:String;
		
		public function NodeTest()
		{
			super();
			
			var c:ConsoleAppender = new ConsoleAppender();
			addChild(c);
			LogDispatcher.addAppender(c);
			
			bitmapCubeLoader = new BitmapCubeLoader();
			setNodeImages(nextNode());
			
			debug(this, "constructor - currentNode is {0}", currentNode);
			bitmapCubeLoader.load(initScene);
		}
		
		protected function initScene():void
		{
			debug(this, "initScene()");
			
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
			addEventListener(Event.ENTER_FRAME, update);
			
			view.addEventListener(MouseEvent.CLICK, onViewClicked);
		}
		
		protected function update(event:Event):void
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
		
		protected function onViewClicked(event:MouseEvent):void
		{
			debug(this, "onViewClicked() - stage ({0},{1})", event.stageX, event.stageY);
			debug(this, "onViewClicked() - currentNode is {0}", currentNode);
			setNodeImages(nextNode());
			bitmapCubeLoader.load(onNodeTraveled);
		}
		
		protected function onNodeTraveled():void
		{
			debug(this, "onNodeTraveled() - currentNode is {0}", currentNode);
		}
		
		protected function nextNode():String
		{
			var next:String;
			switch(currentNode)
			{
				case null: next = "A"; break;
				case "A" : next = "B"; break;
				case "B" : next = "A"; break;
			}
			
			debug(this, "nextNode() - {0} -> {1}", currentNode, next);
			currentNode = next;
			return currentNode;
		}
		
		protected function setNodeImages(nodeName:String):void
		{
			bitmapCubeLoader.setUrls(
				"nodes/"+nodeName+"-posX.png", "nodes/"+nodeName+"-negX.png", 
				"nodes/"+nodeName+"-posY.png", "nodes/"+nodeName+"-negY.png", 
				"nodes/"+nodeName+"-posZ.png", "nodes/"+nodeName+"-negZ.png"
			);
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
			
			var posZMesh:Mesh = createTexturedPlane(r*2, bitmapCubeLoader.getTextureAt(BitmapCubeLoader.POSZ), false);
			posZMesh.translate(Vector3D.Z_AXIS,  r);
			
			var negZMesh:Mesh = createTexturedPlane(r*2, bitmapCubeLoader.getTextureAt(BitmapCubeLoader.NEGZ), false);
			negZMesh.rotationY = 180;
			negZMesh.translate(Vector3D.Z_AXIS, -r);
			
			var posXMesh:Mesh = createTexturedPlane(r*2, bitmapCubeLoader.getTextureAt(BitmapCubeLoader.POSX), false);
			posXMesh.rotationY = 90;
			posXMesh.translate(Vector3D.X_AXIS,  r);
			
			var negXMesh:Mesh = createTexturedPlane(r*2, bitmapCubeLoader.getTextureAt(BitmapCubeLoader.NEGX), false);
			negXMesh.rotationY = -90;
			negXMesh.translate(Vector3D.X_AXIS, -r);
			
			var ground:ObjectContainer3D = new ObjectContainer3D();
			ground.addChildren(posZMesh, negZMesh, posXMesh, negXMesh);
			
			return ground;
		}
		
		protected function createTexturedPlane(dim:Number, bitmapTexture:BitmapTexture, horizontal:Boolean):Mesh
		{
			var seg:uint = 1;
			
			var geo:PlaneGeometry = new PlaneGeometry(dim, dim, seg, seg, horizontal);
			var mat:TextureMaterial = new TextureMaterial(bitmapTexture);
			mat.alphaBlending = true;
			
			var mesh:Mesh = new Mesh(geo, mat);
			return mesh;
		}
	}
}
