package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;


	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF", quality="LOW")]
	public class Xform extends Sprite
	{
		protected var clock:FrameClock;
		protected var scene:Scene;
		protected var geo:Mesh;

		protected const S:Matrix3D = new Matrix3D();
		protected const T1:Matrix3D = new Matrix3D();
		protected const R:Matrix3D = new Matrix3D();
		protected const T2:Matrix3D = new Matrix3D();
		protected const _orbit:Matrix3D = new Matrix3D();

		protected var angle:Number = 0;


		public function Xform()
		{
			super();

			clock = new FrameClock(this, update);
			geo = createGeo();
			scene = new Scene().addGeo(geo, true);

			T1.appendTranslation(0, 0, 90);
			S.appendScale(.1, .1, .1);

			addChild(scene);
		}

		protected function createGeo():Mesh
		{
			const geometry:CubeGeometry = new CubeGeometry();
			const material:ColorMaterial = new ColorMaterial();
			const mesh:Mesh = new Mesh(geometry, material);
			return mesh;
		}

		protected function get orbit():Matrix3D
		{
			R.identity();
			R.appendRotation(-1 * angle++, Vector3D.X_AXIS);

			T2.identity();
			T2.appendTranslation(40 * Math.cos((1 / 14) * (angle * Math.PI / 180)), 0, 0);

			_orbit.identity();
			_orbit.append(S);
			_orbit.append(T1);
			_orbit.append(R);
			_orbit.append(T2);

			return _orbit;
		}

		protected function update(s:Number):void
		{
			geo.transform = orbit;
			scene.update();
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.utils.getTimer;

import away3d.cameras.Camera3D;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.lights.DirectionalLight;
import away3d.lights.LightBase;
import away3d.materials.ColorMaterial;
import away3d.tools.helpers.LightsHelper;


class FrameClock
{
	protected var callback:Function;
	protected var lastTime:int;


	public function FrameClock(eventSource:DisplayObject, callback:Function)
	{
		this.callback = callback;
		eventSource.addEventListener(Event.ENTER_FRAME, onFrame);
	}

	protected function get elapsed():Number
	{
		var now:int = getTimer();
		const value:Number = (lastTime ? (now - lastTime) : now) * .001; // seconds elapsed
		lastTime = now;
		return value;
	}

	protected function onFrame(e:Event):void
	{
		callback(elapsed);
	}
}


class Scene extends Sprite
{

	protected var view:View3D;
	protected var lights:Vector.<LightBase>;


	public function Scene()
	{
		super();

		view = new View3D();
		view.backgroundColor = 0x2a2a2a;
		addChild(view);

		lights = createLights();
		for (var i:uint = 0; i < lights.length; i++)
			view.scene.addChild(lights[i]);

		const cam:Camera3D = view.camera;
		cam.z = -200;
	}

	public function addGeo(geo:Mesh, addLights:Boolean):Scene
	{
		view.scene.addChild(geo);
		if (addLights)
			LightsHelper.addStaticLightsToMaterials(geo, lights);

		return this;
	}

	public function update():void
	{
		view.render();
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
}
