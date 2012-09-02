package mteb.view.scene.models.ground
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;

	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;


	public class BitmapCubeLoader
	{
		protected const POSX:uint = SkyBoxFaceEnum.POSX.index;
		protected const NEGX:uint = SkyBoxFaceEnum.NEGX.index;
		protected const POSY:uint = SkyBoxFaceEnum.POSY.index;
		protected const NEGY:uint = SkyBoxFaceEnum.NEGY.index;
		protected const POSZ:uint = SkyBoxFaceEnum.POSZ.index;
		protected const NEGZ:uint = SkyBoxFaceEnum.NEGZ.index;

		protected const imageData:Vector.<BitmapData> = new <BitmapData>[null, null, null, null, null, null];
		protected const imageUrls:Vector.<String> = new <String>[null, null, null, null, null, null];
		protected const loadComplete:Vector.<Boolean> = new <Boolean>[false, false, false, false, false, false];
		protected const loaders:Vector.<Loader> = new <Loader>[null, null, null, null, null, null];

		protected var externalCallback:Function;


		public function BitmapCubeLoader(urlPosX:String = null, urlNegX:String = null, urlPosY:String = null, urlNegY:String = null, urlPosZ:String = null, urlNegZ:String = null, callback:Function = null):void
		{
			setLoaders();
			setUrls(urlPosX, urlNegX, urlPosY, urlNegY, urlPosZ, urlNegZ);
			if (callback != null)
				load(callback);
		}

		public function dispose():void
		{
			const n:uint = imageData.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (imageData[i] != null)
				{
					imageData[i].dispose();
					imageData[i] = null;
				}
			}
		}

		public function getBitmapDataAt(index:uint):BitmapData  { return imageData[index]; }

		public function getCubeTextureFor():BitmapCubeTexture
		{
			const bitmapCubeTexture:BitmapCubeTexture = new BitmapCubeTexture(imageData[POSX], imageData[NEGX], imageData[POSY], imageData[NEGY], imageData[POSZ], imageData[NEGZ]);

			return bitmapCubeTexture;
		}

		public function getTextureFor(index:uint):BitmapTexture
		{
			return new BitmapTexture(imageData[index]);
		}

		public function getUvColorAt(index:uint, uv:Point = null, use32Bits:Boolean = false):uint
		{
			const bd:BitmapData = imageData[index];
			const px:uint = Math.round(uv.x * bd.width);
			const py:uint = Math.round(uv.y * bd.height);
			const color:uint = use32Bits ? bd.getPixel32(px, py) : bd.getPixel(px, py);

			return color;
		}

		public function get isLoaded():Boolean
		{
			var imagesLoaded:Boolean = true;
			const n:uint = loadComplete.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (!loadComplete[i])
				{
					imagesLoaded = false;
					break;
				}
			}
			return imagesLoaded;
		}

		public function load(callback:Function):void
		{
			externalCallback = callback;

			const n:uint = imageUrls.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (imageUrls[i] == null)
					throw new ArgumentError("no image url provided for " + SkyBoxFaceEnum.faces[i] + " face");
				loadComplete[i] = false;
				loaders[i].load(new URLRequest(imageUrls[i]));
			}
		}

		public function setUrls(urlPosX:String, urlNegX:String, urlPosY:String, urlNegY:String, urlPosZ:String, urlNegZ:String):void
		{
			imageUrls[POSX] = urlPosX;
			imageUrls[NEGX] = urlNegX;
			imageUrls[POSY] = urlPosY;
			imageUrls[NEGY] = urlNegY;
			imageUrls[POSZ] = urlPosZ;
			imageUrls[NEGZ] = urlNegZ;
		}


		protected function makeImageLoadHandler(which:uint):Function
		{
			// create new closure to capture current value of which
			return function(event:Event):void
			{
				//debug(this, "imageLoadHandler() - loaded image {0}", which);
				setImage(which, event);
			}
		}

		protected function makeLoadErrorHandler(which:uint):Function
		{
			// create new closure to capture current value of which
			return function(event:IOErrorEvent):void
			{
				debug(this, "loadErrorHandler() - error loading image {0}: {1}", which, event.toString());
			}
		}

		protected function setImage(which:uint, event:Event):void
		{
			const bitmap:Bitmap = event.target.content as Bitmap;
			imageData[which] = bitmap.bitmapData;
			loadComplete[which] = true;

			if (isLoaded)
			{
				debug(this, "setImage() - image loads complete, executing externalCallback");
				externalCallback();
			}
		}

		protected function setLoaders():void
		{
			const n:uint = loaders.length;
			for (var i:uint = 0; i < n; i++)
			{
				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, makeImageLoadHandler(i));
				loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, makeLoadErrorHandler(i));
			}
		}
	}
}
