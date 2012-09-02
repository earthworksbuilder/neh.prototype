package mteb.control.interpreters
{


	public interface ICommandInterpreter
	{
		function addCommand(command:String, impl:Class, usage:String = ""):void;

		function get commands():Vector.<String>;

		function processCommand(string:String):Boolean;
	}
}
