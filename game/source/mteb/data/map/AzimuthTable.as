package mteb.data.map
{


	/**
	Data from JPL's Horizons tool.
	http://ssd.jpl.nasa.gov/horizons.cgi
	
	for the max rise/sets, used email interface as follows:
	to:		horizons@ssd.jpl.nasa.gov
	subj:	JOB
	body:
	!$$SOF
	COMMAND= '301'
	CENTER= 'coord@399'
	COORD_TYPE= 'GEODETIC'
	SITE_COORD= '-82.4472222222222,40.0527777777778,0.265176'
	MAKE_EPHEM= 'YES'
	TABLE_TYPE= 'OBSERVER'
	START_TIME= '2006AD-Sep-01 00:00 UT-4:00'
	STOP_TIME= '2006AD-Dec-31'
	STEP_SIZE= '1 m'
	CAL_FORMAT= 'CAL'
	TIME_DIGITS= 'MINUTES'
	ANG_FORMAT= 'DEG'
	OUT_UNITS= 'KM-S'
	RANGE_UNITS= 'AU'
	APPARENT= 'REFRACTED'
	SOLAR_ELONG= '0,180'
	SUPPRESS_RANGE_RATE= 'NO'
	SKIP_DAYLT= 'NO'
	EXTRA_PREC= 'NO'
	R_T_S_ONLY= 'TVH'
	REF_SYSTEM= 'J2000'
	CSV_FORMAT= 'NO'
	OBJ_DATA= 'YES'
	QUANTITIES= '4,10,13'
	!$$EOF
	
	for the min rise sets, used:
	START_TIME= '2015AD-Dec-01 00:00 UT-4:00'
	STOP_TIME= '2016AD-Mar-31'
	
	Fri Sep 1, 2006 + 9.3yrs = Sat Dec 19, 2015
	*/
	public class AzimuthTable
	{
		public static const NORTH:Number = 0;
		public static const EAST:Number = 90;
		public static const SOUTH:Number = 180;
		public static const WEST:Number = 270;

		/**
		 * Representative set of moon rise azimuths for Newark earthworks when north and south are at their maximum separation.
		 * Values progress from north-most at index 0 to south.
		 * */
		public static const MOON_RISES_MAX:Vector.<Number> = new <Number>[51.2526, 52.2610, 55.9086, 61.6611, 69.0049, 77.8914, 87.3494, 96.9872, 106.3863, 114.9607, 121.9640, 126.7904, 128.9762, 128.3899];

		/**
		 * Representative set of moon set azimuths for Newark earthworks when north and south are at their maximum separation.
		 * Values progress from north-most at index 0 to south.
		 * */
		public static const MOON_SETS_MAX:Vector.<Number> = new <Number>[308.0818, 308.7496, 306.8875, 302.4444, 295.6824, 287.3015, 277.9792, 267.9747, 257.9815, 248.6956, 240.6745, 234.8163, 231.6404, 231.2205];

		/**
		 * Representative set of moon set azimuths for Newark earthworks when north and south are at their minimum separation.
		 * Values progress from north-most at index 0 to south.
		 * */
		public static const MOON_RISES_MIN:Vector.<Number> = new <Number>[65.9350, 66.4278, 68.5431, 71.9543, 76.4894, 81.8397, 87.5598, 93.6682, 99.4110, 104.6273, 109.1351, 112.2756, 114.1630, 114.4837];

		/**
		 * Representative set of moon set azimuths for Newark earthworks when north and south are at their minimum separation.
		 * Values progress from north-most at index 0 to south.
		 * */
		public static const MOON_SETS_MIN:Vector.<Number> = new <Number>[293.8844, 294.2182, 293.0324, 290.3463, 286.2875, 281.2679, 275.6576, 269.5910, 263.3985, 257.7205, 252.8281, 249.0480, 246.5750, 245.6333];

		public static function get northMaxRise():Number { return MOON_RISES_MAX[0]; }
		public static function get northMaxSet():Number { return MOON_SETS_MAX[0]; }
		
		public static function get northMinRise():Number { return MOON_RISES_MIN[0]; }
		public static function get northMinSet():Number { return MOON_SETS_MIN[0]; }
		
		public static function get southMaxRise():Number { return MOON_RISES_MAX[MOON_RISES_MAX.length-1]; }
		public static function get southMaxSet():Number { return MOON_SETS_MAX[MOON_SETS_MAX.length-1]; }
		
		public static function get southMinRise():Number { return MOON_RISES_MIN[MOON_RISES_MIN.length-1]; }
		public static function get southMinSet():Number { return MOON_SETS_MIN[MOON_SETS_MIN.length-1]; }
	}
}
