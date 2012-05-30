package mteb.control
{
	import pixeldroid.signals.ISignalBus;
	import pixeldroid.signals.impl.SignalBusBase;


	public class SignalBus extends SignalBusBase
	{
		private static var instance:ISignalBus;

		/**
		 * Use this method to access the single instance of SignalBus.
		 */
		public static function getInstance():ISignalBus
		{
			return instance || (instance = new SignalBus(new SingletonKey()));
		}


		public function SignalBus(key:SingletonKey)
		{
			super();

			if (!key)
				throw new ArgumentError(SingletonKey.ERROR_MSG);

		}
	}
}


internal class SingletonKey
{
	public static const ERROR_MSG:String = "Please do not instantiate directly, use the getInstance() method instead.";
}
