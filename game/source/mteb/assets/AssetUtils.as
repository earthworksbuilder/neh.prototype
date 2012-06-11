package mteb.assets
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;


	public final class AssetUtils
	{

		public static function createOffsetParent(value:DisplayObject, offsetX:Number = -.5, offsetY:Number = -.5):Sprite
		{
			const p:Sprite = new Sprite();
			const c:DisplayObject = p.addChild(value);
			c.x += c.width * offsetX;
			c.y += c.height * offsetY;
			return p;
		}
	}
}
