package pixeldroid.away3d
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.primitives.CubeGeometry;
	import away3d.tools.helpers.LightsHelper;


	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW")]
	public class SimpleView3D extends Sprite implements ISimpleView3D
	{

		protected var view:View3D;
		protected var geo:ObjectContainer3D;
		protected var lights:Vector.<LightBase>;
		protected var managedCamera:IManagedCamera;
		protected var awayStats:AwayStats;

		private var lastTime:int;
		private var _cameraIsMoving:Boolean = false;


		public function SimpleView3D()
		{
			super();

			initStage();
			initView3D();
			initCamera();
			initDebug();

			// listen for enterframe to to render updates
			addEventListener(Event.ENTER_FRAME, update);
		}

		protected function applyLightsToGeo():void
		{
			for (var i:uint = 0; i < geo.numChildren; i++)
				LightsHelper.addStaticLightsToMaterials(geo.getChildAt(i), lights);
		}

		protected function createGeo():ObjectContainer3D
		{
			const geoContainer:ObjectContainer3D = new ObjectContainer3D();

			const geometry:CubeGeometry = new CubeGeometry();
			const material:ColorMaterial = new ColorMaterial();
			const mesh:Mesh = new Mesh(geometry, material);

			geoContainer.addChildren(mesh);
			return geoContainer;
		}

		protected function createLights():Vector.<LightBase>
		{
			// simple two-point light setup: key, fill
			const key:DirectionalLight = new DirectionalLight(.5, -1, .75);
			key.color = 0xffffff;
			key.ambient = 0;
			key.diffuse = .75;
			key.specular = .4;

			const fill:DirectionalLight = new DirectionalLight(-1, .5, .75);
			fill.color = 0xffffff;
			fill.ambient = 0;
			fill.diffuse = .25;
			fill.specular = 0;

			const lights:Vector.<LightBase> = new <LightBase>[key, fill];
			return lights;
		}

		protected function get elapsed():Number
		{
			const now:int = getTimer();
			const value:Number = (lastTime ? (now - lastTime) : now) * .001; // seconds elapsed
			lastTime = now;
			return value;
		}

		protected function initCamera():void
		{
			managedCamera = new ManagedHoverCamera(view.camera, stage);
		}

		protected function initDebug():void
		{
			addChild(awayStats = new AwayStats(view));
			awayStats.x = stage.stageWidth - awayStats.width;
			awayStats.y = 0;
		}

		protected function initStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
		}

		protected function initView3D():void
		{
			// create a viewport and add it to the stage
			view = new View3D();
			view.backgroundColor = 0x2a2a2a;
			addChild(view);

			// add lighting to the scene
			lights = createLights();
			for (var i:uint = 0; i < lights.length; i++)
				view.scene.addChild(lights[i]);

			// add geometry to the scene
			geo = createGeo();
			view.scene.addChild(geo);

			applyLightsToGeo();
		}

		protected function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			resizeDebug(event);
		}

		protected function resizeDebug(event:Event = null):void
		{
			awayStats.x = stage.stageWidth - awayStats.width;
		}

		protected function update(e:Event):void
		{
			managedCamera.update();
			view.render();
		}
	}
}
