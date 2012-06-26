package mteb.data.player
{


	public class Inventory implements IInventory
	{
		protected const artifacts:Vector.<Boolean> = new <Boolean>[false, false, false, false];


		public function Inventory()
		{
		}

		public function addArtifact(which:uint):void
		{
			if (!artifacts[which])
			{
				artifacts[which] = true;
				debug(this, "addArtifact() - added artifact{0}", which);
			}
			else
				warn(this, "addArtifact() - already in possession of artifact{0}", which);
		}

		public function hasArtifact(which:uint):Boolean
		{
			return (artifacts[which] == true);
		}

		public function toString():String
		{
			const n:uint = artifacts.length;
			var s:String = "";
			for (var i:uint = 0; i < n; i++)
			{
				if (artifacts[i])
					s += "artifact " + i;
			}

			return s;
		}
	}
}
