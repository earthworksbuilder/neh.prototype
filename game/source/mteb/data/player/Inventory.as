package mteb.data.player
{
	import mteb.data.map.IArtifact;


	public class Inventory implements IInventory
	{
		protected const artifacts:Vector.<Boolean> = new <Boolean>[false, false, false, false];


		public function Inventory()
		{
		}

		public function addArtifact(artifact:IArtifact):void
		{
			if (!artifacts[artifact.index])
			{
				artifacts[artifact.index] = true;
				debug(this, "addArtifact() - added artifact{0}", artifact.index);
			}
			else
				warn(this, "addArtifact() - already in possession of artifact{0}", artifact.index);
		}

		public function hasArtifact(index:uint):Boolean
		{
			return (artifacts[index] == true);
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
