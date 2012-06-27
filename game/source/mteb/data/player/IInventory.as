package mteb.data.player
{
	import mteb.data.map.IArtifact;


	public interface IInventory
	{
		function addArtifact(artifact:IArtifact):void;

		function hasArtifact(index:uint):Boolean;
	}
}
