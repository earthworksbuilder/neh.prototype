package mteb.data.orbit
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
	public class Ephemeris
	{
		/** Total number of rises / sets / transits available for min or max */
		public static const NUM_DAYS:uint = 15;
		
		/** Azimuth value for astronomical true north */
		public static const NORTH:Number = 0;
		
		/** Azimuth value for astronomical true east */
		public static const EAST:Number = 90;
		
		/** Azimuth value for astronomical true south */
		public static const SOUTH:Number = 180;
		
		/** Azimuth value for astronomical true west */
		public static const WEST:Number = 270;

		/**
		 * Representative list of moon rise azimuths for Newark earthworks when northmost rise and southmost rise are at their maximum separation.
		 * Values correspond to the date range 2006-Sep-15 00:08 to 2006-Sep-29 14:39, showing azimuth at altitude ~0.
		 * Values progress from northmost at index 0 to south.
		 * */
		public static const MOON_MAX_RISES:Vector.<Number> = new <Number>[51.2526, 52.7848, 56.3471, 61.5807, 67.8182, 74.9262, 82.4113, 90.0850, 97.7574, 105.3961, 112.4887, 118.8524, 124.0302, 127.6658, 129.0907];

		/**
		 * Representative list of moon transit altitudes for Newark earthworks when northmost and southmost rises and sets are at their maximum separation.
		 * Values correspond to the date range 2006-Sep-15 08:16 to 2006-Sep-29 18:59, showing altitude at azimuth ~180.
		 * */
		public static const MOON_MAX_TRANSITS:Vector.<Number> = new <Number>[78.3266, 76.7984, 73.8690, 69.8349, 64.9840, 59.5739, 53.8236, 47.9323, 42.0872, 36.4805, 31.3212, 26.8501, 23.3426, 21.0987, 20.4027];
		
		/**
		 * Representative list of moon set azimuths for Newark earthworks when northmost set and southmost set are at their maximum separation.
		 * Values correspond to the date range 2006-Sep-15 16:20 to 2006-Sep-29 23:18, showing azimuth at altitude ~0.
		 * Values progress from northmost at index 0 to south.
		 * */
		public static const MOON_MAX_SETS:Vector.<Number> = new <Number>[308.0818, 305.2439, 300.8104, 294.9450, 288.3538, 281.2387, 273.7807, 266.3054, 258.8289, 251.6776, 245.0347, 239.2598, 234.6030, 231.6983, 231.1338];

		
		/**
		 * Representative list of moon rise azimuths for Newark earthworks when northmost rise and southmost rise are at their minimum separation.
		 * Values correspond to the date range 2015-Dec-24 17:56 to 2016-Jan-08 07:17, showing azimuth at altitude ~0.
		 * Values progress from northmost at index 0 to south.
		 * */
		public static const MOON_MIN_RISES:Vector.<Number> = new <Number>[65.9854, 66.0340, 67.8339, 70.7628, 74.7025, 79.2975, 84.1509, 89.1714, 94.2734, 99.2211, 103.7864, 107.7522, 111.0798, 113.4567, 114.4837];
		
		/**
		 * Representative list of moon transit altitudes for Newark earthworks when northmost and southmost rises and sets are at their minimum separation.
		 * Values correspond to the date range 2015-Dec-25 01:16 to 2016-Jan-08 12:22, showing altitude at azimuth ~180.
		 * */
		public static const MOON_MIN_TRANSITS:Vector.<Number> = new <Number>[68.0335, 67.5469, 65.9702, 63.5053, 60.3857, 56.8283, 53.0231, 49.1251, 45.2697, 41.5812, 38.1902, 35.2417, 32.9009, 31.3451, 30.7433];

		/**
		 * Representative list of moon set azimuths for Newark earthworks when northmost set and southmost set are at their minimum separation.
		 * Values correspond to the date range 2015-Dec-25 08:37 to 2016-Jan-08 17:28, showing azimuth at altitude ~0.
		 * Values progress from northmost at index 0 to south.
		 * */
		public static const MOON_MIN_SETS:Vector.<Number> = new <Number>[294.3181, 293.2025, 290.7739, 287.2413, 283.0594, 278.3127, 273.4997, 268.4695, 263.5171, 258.7804, 254.5634, 250.8861, 247.9622, 246.0549, 245.6333];

		
		public static function get northMaxRise():Number { return MOON_MAX_RISES[0]; }
		public static function get northMaxSet():Number { return MOON_MAX_SETS[0]; }
		
		public static function get northMinRise():Number { return MOON_MIN_RISES[0]; }
		public static function get northMinSet():Number { return MOON_MIN_SETS[0]; }
		
		public static function get southMaxRise():Number { return MOON_MAX_RISES[MOON_MAX_RISES.length-1]; }
		public static function get southMaxSet():Number { return MOON_MAX_SETS[MOON_MAX_SETS.length-1]; }
		
		public static function get southMinRise():Number { return MOON_MIN_RISES[MOON_MIN_RISES.length-1]; }
		public static function get southMinSet():Number { return MOON_MIN_SETS[MOON_MIN_SETS.length-1]; }
	}
}

