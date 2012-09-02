package pixeldroid.away3d
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.HoverController;


	public class ManagedHoverCamera implements IManagedCamera
	{
		protected var cameraController:HoverController;
		protected var lastPanAngle:Number;
		protected var lastTiltAngle:Number;
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;

		private var _camera:Camera3D;
		private var _cameraIsMoving:Boolean = false;
		private var _stage:Stage;


		public function ManagedHoverCamera(camera:Camera3D, stage:Stage)
		{
			this.camera = camera;
			this.stage = stage;
		}

		public function get camera():Camera3D
		{
			return _camera;
		}

		public function set camera(value:Camera3D):void
		{
			_camera = value;
			_camera.moveTo(0, 100, -100);
			_camera.lookAt(new Vector3D(0, 0, 0));
			cameraController = new HoverController(_camera, null, 135, 15, 600);
		}

		public function get cameraIsMoving():Boolean  { return _cameraIsMoving; }

		public function set cameraIsMoving(value:Boolean):void
		{
			_cameraIsMoving = value;
			if (_cameraIsMoving)
				stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			else
				stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		public function get lookAtObject():ObjectContainer3D
		{
			return cameraController.lookAtObject;
		}

		public function set lookAtObject(value:ObjectContainer3D):void
		{
			cameraController.lookAtObject = value;
		}

		public function removeListeners():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		public function get stage():Stage
		{
			return _stage;
		}

		public function set stage(value:Stage):void
		{
			_stage = value;

			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		public function update(e:Event = null):void
		{
			if (!_stage)
				throw new IllegalOperationError("stage value must be set before update can be called");
			if (!_camera)
				throw new IllegalOperationError("camera value must be set before update can be called");

			if (cameraIsMoving)
			{
				cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;

			cameraIsMoving = true;
		}

		protected function onMouseUp(e:MouseEvent):void
		{
			cameraIsMoving = false;
		}

		protected function onMouseWheel(event:MouseEvent):void
		{
			cameraController.distance -= event.delta * 5;

			if (cameraController.distance < 400)
				cameraController.distance = 400;
			else if (cameraController.distance > 10000)
				cameraController.distance = 10000;
		}

		protected function onStageMouseLeave(event:Event):void
		{
			cameraIsMoving = false;
		}
	}
}
