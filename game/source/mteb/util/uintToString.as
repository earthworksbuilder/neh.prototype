package mteb.util
{
	public function uintToString(value:uint, use32Bits:Boolean = false):String
	{
		const r:uint = (value >> 16) & 0xff;
		const g:uint = (value >> 8) & 0xff;
		const b:uint = value & 0xff;

		const rx:String = ((r < 16) ? "0" : "") + r.toString(16);
		const gx:String = ((g < 16) ? "0" : "") + g.toString(16);
		const bx:String = ((b < 16) ? "0" : "") + b.toString(16);

		if (use32Bits)
		{
			const a:uint = (value >> 24) & 0xff;
			const ax:String = ((a < 16) ? "0" : "") + a.toString(16);
			return "0x" + ax + rx + gx + bx;
		}

		return "0x" + rx + gx + bx;
	}
}
