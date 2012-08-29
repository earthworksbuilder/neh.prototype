package mteb.control.gamestate
{


	public class CompassStateMachine
	{
		protected const TOTAL_ARTIFACTS:uint = 4;
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
				if (_currentArtifactIndex == TOTAL_ARTIFACTS)
					_currentArtifactIndex = -1;
			}
			return captured;
		}

		public function get capturesRemaining():int
		{
			return (_currentArtifactIndex > -1) ? TOTAL_ARTIFACTS - _currentArtifactIndex : 0;
		}

		public function get currentArtifactIndex():int
		{
			return _currentArtifactIndex;
		}

		public function get lastCapturedArtifactIndex():int
		{
			return (_currentArtifactIndex > -1) ? _currentArtifactIndex - 1 : -1;
		}
	}
}
