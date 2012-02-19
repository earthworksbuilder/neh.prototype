package
{
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.View3D;
    import away3d.core.base.Object3D;
    import away3d.entities.Mesh;
    import away3d.events.MouseEvent3D;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.getTimer;
    
    import pixeldroid.logging.LogDispatcher;
    import pixeldroid.logging.appenders.console.ConsoleAppender;
		

    [SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class NodeTest extends Sprite
	{
		protected const TO_DEGREES:Number = 180 / Math.PI;
		protected const STARTING_AZIMUTH:Number = 51.5; // azimuth of initial node view
		
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
			//skyGeo.addEventListener(MouseEvent3D.CLICK, onSkyClicked); // not getting any hits
			groundGeo = new NodeGeometry();
			groundGeo.addEventListener(MouseEvent3D.CLICK, onGroundClicked);
			sceneGeo.addChildren(skyGeo, groundGeo);
			view.scene.addChild(sceneGeo);
			onNodeTraveled();
			
			// let user manipulate camera orientation
			userTransform = new UserTransform(stage, view.camera.transform);
			
			// listen for enterframe to to render updates
			addEventListener(Event.ENTER_FRAME, update);
			
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
		
		protected function onSkyClicked(event:MouseEvent3D):void
		{
			debug(this, "onSkyClicked()");
		}
		
		protected function onGroundClicked(event:MouseEvent3D):void
		{
			var object3d:Object3D = event.object;
			var uv:Point = event.uv;
			var action:String = getActionType(object3d.name, uv);
			
			debug(this, "onViewClicked() - azimuth: {0}, N{1}.{2} ({3}, {4}), action: {5}", currentAzimuth.toFixed(2), currentNode, object3d.name, uv.x.toFixed(3), uv.y.toFixed(3), action);
			handleAction(action);
		}
		
		protected function onNodeTraveled():void
		{
			debug(this, "onNodeTraveled() - currentNode is {0}; updating bitmapdata", currentNode);
			for (var i:uint = 0; i < 6; i++)
			{
				groundGeo.setTextureData(bitmapCubeLoader.getBitmapDataAt(i), i);
			}
		}
		
		protected function handleAction(action:String):void
		{
			switch(action)
			{
				case "NEXT_NODE":
					setNodeImages(nextNode());
					bitmapCubeLoader.load(onNodeTraveled);
					break;
				
				default:
					debug(this, "handleAction() - unknown action type {0}", action);
					break;
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
				case "006" : next = "007"; break;
				case "007" : next = "008"; break;
				case "008" : next = "009"; break;
				case "009" : next = "001"; break;
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
		}
		
		protected function getActionType(objectName:String, textureCoords:Point=null):String
		{
			return "NEXT_NODE";
		}
		
		protected function get currentAzimuth():Number
		{
			var a:Number;
			var forward:Vector3D = view.camera.forwardVector;
			var ry:Number = view.camera.rotationY;
			
			if (forward.x >= 0)
			{
				if (forward.z >= 0) a = ry;
				else a = 180 - ry;
			}
			else
			{
				if (forward.z < 0) a = 180 - ry;
				else a = 360 + ry;
			}
			
			return (a + STARTING_AZIMUTH) % 360;
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
