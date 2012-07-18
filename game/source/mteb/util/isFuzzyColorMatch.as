package mteb.util
{
	public function isFuzzyColorMatch(a:uint, b:uint, fuzz:uint = 3):Boolean
	{
		if (a == b)
			return true;

		const ra:int = (a >> 16) & 0xff;
		const rb:int = (b >> 16) & 0xff;
		if (Math.abs(ra - rb) > fuzz)
			return false;

		const ga:int = (a >> 8) & 0xff;
		const gb:int = (b >> 8) & 0xff;
		if (Math.abs(ga - gb) > fuzz)
			return false;

		const ba:int = a & 0xff;
		const bb:int = b & 0xff;
		if (Math.abs(ba - bb) > fuzz)
			return false;

		return true;
	}
}
