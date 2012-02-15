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
		

    [SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class NodeTest extends Sprite
	{
		protected var view:View3D;
		protected var userTransform:UserTransform;
		protected var bitmapCubeLoader:BitmapCubeLoader;
		protected var skyGeo:ObjectContainer3D;
		protected var groundGeo:NodeGeometry;
		
		protected var lastTime:int;
		protected var currentNode:String;
		
		
		public function NodeTest()
		{
			super();
			
			var c:ConsoleAppender = new ConsoleAppender();
			addChild(c);
			LogDispatcher.addAppender(c);
			
			bitmapCubeLoader = new BitmapCubeLoader();
			setNodeImages(nextNode());
			
			debug(this, "constructor - loading cube images...");
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
			skyGeo = new SkyGeometry();
			groundGeo = new NodeGeometry();
			sceneGeo.addChildren(skyGeo, groundGeo);
			view.scene.addChild(sceneGeo);
			onNodeTraveled();
			
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
			debug(this, "onNodeTraveled() - currentNode is {0}; updating bitmapdata", currentNode);
			for (var i:uint = 0; i < 6; i++)
			{
				groundGeo.setTextureData(bitmapCubeLoader.getBitmapDataAt(i), i);
			}
		}
		
		protected function nextNode():String
		{
			var next:String;
			switch(currentNode)
			{
				case  null : next = "001"; break;
				case "001" : next = "002"; break;
				case "002" : next = "003"; break;
				case "003" : next = "004"; break;
				case "004" : next = "005"; break;
				case "005" : next = "006"; break;
			}
			
			debug(this, "nextNode() - {0} -> {1}", currentNode, next);
			currentNode = next;
			return currentNode;
		}
		
		protected function setNodeImages(nodeName:String):void
		{
			bitmapCubeLoader.setUrls(
				"nodes/posX/posX."+nodeName+".png", "nodes/negX/negX."+nodeName+".png", 
				"nodes/posY/posY."+nodeName+".png", "nodes/negY/negY."+nodeName+".png", 
				"nodes/posZ/posZ."+nodeName+".png", "nodes/negZ/negZ."+nodeName+".png"
			);
			/*
			bitmapCubeLoader.setUrls(
				"nodes/"+nodeName+"-posX.png", "nodes/"+nodeName+"-negX.png", 
				"nodes/"+nodeName+"-posY.png", "nodes/"+nodeName+"-negY.png", 
				"nodes/"+nodeName+"-posZ.png", "nodes/"+nodeName+"-negZ.png"
			);
			*/
		}
		
		protected function get elapsed():Number
		{
			var now:int = getTimer();
			var value:Number = (lastTime ? (now - lastTime) : now) * .001; // seconds elapsed
			lastTime = now;
			return value;
		}
		
	}
}
