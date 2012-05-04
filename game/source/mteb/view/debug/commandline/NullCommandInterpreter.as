package mteb.view.debug.commandline
{


	/**
	 * Safely processes commands by ignoring them.
	 */
	public class NullCommandInterpreter implements ICommandInterpreter
	{

		public function processCommand(string:String):Boolean
		{
			return false;
		}
	}
}
