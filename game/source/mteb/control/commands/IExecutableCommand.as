package mteb.control.commands
{


	public interface IExecutableCommand
	{

		function get command():String;

		function execute(args:Array):void;

		function get usage():String;
	}
}
