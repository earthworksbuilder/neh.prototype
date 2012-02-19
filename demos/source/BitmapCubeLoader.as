
package
{
    import away3d.textures.BitmapCubeTexture;
    import away3d.textures.BitmapTexture;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    
    
	public class BitmapCubeLoader
	{
		public static const POSX:uint = 0;
		public static const NEGX:uint = 1;
		public static const POSY:uint = 2;
		public static const NEGY:uint = 3;
		public static const POSZ:uint = 4;
		public static const NEGZ:uint = 5;
		
		protected var imageData:Vector.<BitmapData> = new <BitmapData>[null,null,null,null,null,null];
		protected var loaders:Vector.<Loader> = new <Loader>[null,null,null,null,null,null];
		protected var loadComplete:Vector.<Boolean> = new <Boolean>[false,false,false,false,false,false];
		protected var imageUrls:Vector.<String> = new <String>[null,null,null,null,null,null];
		protected var cubeFaces:Vector.<String> = new <String>["POSX", "NEGX", "POSY", "NEGY", "POSZ", "NEGZ"];
		
		protected var externalCallback:Function;
		
		
		public function BitmapCubeLoader(
			urlPosX:String=null, urlNegX:String=null, 
			urlPosY:String=null, urlNegY:String=null, 
			urlPosZ:String=null, urlNegZ:String=null,
			callback:Function=null
			):void
		{
			setLoaders();
			setUrls(urlPosX, urlNegX, urlPosY, urlNegY, urlPosZ, urlNegZ);
			if (callback != null) load(callback);
		}
		
		public function setUrls(
			urlPosX:String, urlNegX:String,
			urlPosY:String, urlNegY:String,
			urlPosZ:String, urlNegZ:String
			):void
		{
			imageUrls[POSX] = urlPosX;
			imageUrls[NEGX] = urlNegX;
			imageUrls[POSY] = urlPosY;
			imageUrls[NEGY] = urlNegY;
			imageUrls[POSZ] = urlPosZ;
			imageUrls[NEGZ] = urlNegZ;
		}
		
		public function load(callback:Function):void
		{
			externalCallback = callback;
			
			var n:uint = imageUrls.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (imageUrls[i] == null) throw new ArgumentError("no image url provided for " +cubeFaces[i] +" face");
				loadComplete[i] = false;
				loaders[i].load(new URLRequest(imageUrls[i]));
			}
		}
		
		public function get isLoaded():Boolean
		{
			var imagesLoaded:Boolean = true;
			var n:uint = loadComplete.length;
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
		
		public function getCubeTextureFor():BitmapCubeTexture
		{
			var bitmapCubeTexture:BitmapCubeTexture = new BitmapCubeTexture
			(
				imageData[POSX], imageData[NEGX],
				imageData[POSY], imageData[NEGY],
				imageData[POSZ], imageData[NEGZ]
			);
			
			return bitmapCubeTexture;
		}
		
		public function getTextureFor(index:uint):BitmapTexture
		{
			if (index >= imageData.length) throw new ArgumentError("index out of range. expected [0..5], got " +index);
			return new BitmapTexture(imageData[index]);
		}
		
		public function getBitmapDataAt(index:uint):BitmapData
		{
			if (index >= imageData.length) throw new ArgumentError("index out of range. expected [0..5], got " +index);
			return imageData[index];
		}
		
		public function dispose():void
		{
			var n:uint = imageData.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (imageData[i] != null)
				{
					imageData[i].dispose();
					imageData[i] = null;
				}
			}
		}
		
		
		protected function makeImageLoadHandler(which:uint):Function
		{
			// create new closure to capture current value of which
			return function(event:Event):void { setImage(which, event); }
		}
		
		protected function setImage(which:uint, event:Event):void
		{
			var bitmap:Bitmap = event.target.content as Bitmap;
			imageData[which] = bitmap.bitmapData;
			loadComplete[which] = true;
			
			if (isLoaded) externalCallback();
		}
		
		protected function setLoaders():void
		{
			var n:uint = loaders.length;
			for (var i:uint = 0; i < n; i++)
			{
				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, makeImageLoadHandler(i));
			}
		}
	}
}
