package mteb.control.gamestate
{


	public class CompassStateMachine
	{
		protected var _currentArtifactIndex:int = 0;


		public function CompassStateMachine()
		{
		}

		public function captureMoonForArtifact(index:uint):Boolean
		{
			var captured:Boolean = false;
			if (index == _currentArtifactIndex)
			{
				captured = true;
				_currentArtifactIndex++;
				if (_currentArtifactIndex > 3)
					_currentArtifactIndex = -1;
			}
			return captured;
		}

		public function get currentArtifactIndex():int
		{
			return _currentArtifactIndex;
		}
	}
}
