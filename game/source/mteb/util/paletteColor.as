package mteb.util
{

	/**
	 * Select a color from a sequential palette of colors.
	 *
	 * @param colorIndex Index of color to select.
	 * @param center Base channel value used to calculate colors. Deviation are up to +-width.
	 * @param width Absolute value of amount that colors can deviate from center. Center and width should total to 255.
	 *
	 * @param rf Frequency value for red channel
	 * @param rp Phase offset value for red channel
	 * @param gf Frequency value for green channel
	 * @param gp Phase offset value for green channel
	 * @param bf Frequency value for blue channel
	 * @param bp Phase offset value for blue channel
	 */
	public function paletteColor(colorIndex:uint, center:Number = 128, width:Number = 127, rf:Number = .666, rp:Number = 0, gf:Number = .777, gp:Number = 0, bf:Number = .999, bp:Number = 0):uint
	{
		// http://krazydad.com/tutorials/makecolors.php
		const r:uint = Math.sin(rf * colorIndex + rp) * width + center;
		const g:uint = Math.sin(gf * colorIndex + gp) * width + center;
		const b:uint = Math.sin(bf * colorIndex + bp) * width + center;

		return ((r << 16) | (g << 8) | b);
	}
}
