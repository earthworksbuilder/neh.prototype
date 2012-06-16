package mteb.data.player
{


	public interface IInventory
	{
		function addArtifact(which:uint):void;

		function hasArtifact(which:uint):Boolean;
	}
}
