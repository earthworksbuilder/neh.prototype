package mteb.assets
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;


	public final class AssetUtils
	{

		public static function centeredParent(value:DisplayObject):Sprite
		{
			const p:Sprite = new Sprite();
			const c:DisplayObject = p.addChild(value);
			c.x -= c.width / 2;
			c.y -= c.height / 2;
			return p;
		}
	}
}
