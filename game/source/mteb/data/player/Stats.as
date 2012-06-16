package mteb.data.player
{


	public class Stats implements IStats
	{

		private var _score:Number = 0;


		public function Stats()
		{
		}

		public function get score():Number  { return score; }

		public function setScore(value:Number):void  { _score = value; }
	}
}
