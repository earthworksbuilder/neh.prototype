
package
{
    import away3d.textures.BitmapCubeTexture;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    
    
	public class BitmapCubeLoader
	{
		protected const POSX:uint = 0;
		protected const NEGX:uint = 1;
		protected const POSY:uint = 2;
		protected const NEGY:uint = 3;
		protected const POSZ:uint = 4;
		protected const NEGZ:uint = 5;
		
		protected var images:Vector.<BitmapData> = new <BitmapData>[null,null,null,null,null,null];
		protected var loaders:Vector.<Loader> = new <Loader>[null,null,null,null,null,null];
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
			
			for (var i:uint = 0; i < imageUrls.length; i++)
			{
				if (imageUrls[i] == null) throw new ArgumentError("no image url provided for " +cubeFaces[i] +" face");
				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, makeImageLoadHandler(i));
				loaders[i].load(new URLRequest(imageUrls[i]));
			}
		}
		
		public function get texture():BitmapCubeTexture
		{
			var bitmapCubeTexture:BitmapCubeTexture = new BitmapCubeTexture
			(
				images[POSX], images[NEGX],
				images[POSY], images[NEGY],
				images[POSZ], images[NEGZ]
			);
			
			return bitmapCubeTexture;
		}
		
		public function get isLoaded():Boolean
		{
			var imagesLoaded:Boolean = true;
			for (var i:uint = 0; i < images.length; i++)
			{
				if (images[i] == null)
				{
					imagesLoaded = false;
					break;
				}
			}
			return imagesLoaded;
		}
		
		public function dispose():void
		{
			for (var i:uint = 0; i < images.length; i++)
			{
				if (images[i] != null)
				{
					images[i].dispose();
					images[i] = null;
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
			images[which] = bitmap.bitmapData;
			
			if (isLoaded) externalCallback();
		}
	}
}
