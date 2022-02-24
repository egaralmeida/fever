package  
{
	/**
	 * Useful helpers
	 * @author Egar Almeida
	 */
	public class Utils
	{
		/**
		 * Returns a random Number of the specified interval.
		 * 
		 * @param	min				Smallest number to be returned
		 * @param	max				Largest number to be returned
		 * @return					The Number
		 */
		public static function rnd(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
		
		/**
		 * Returns a random, integer, number of the specified interval.
		 * 
		 * @param	min				Smallest number to be returned
		 * @param	max				Largest number to be returned
		 * @return					The Integer
		 */
		public static function rndInt(min:int, max:int):int
		{
			return Math.round(Math.random() * (max - min) + min);
		}
		
		/**
		 * Helper for timing control.
		 * 
		 * @author	Daniel Benmergui
		 * @param	added
		 * @param	total
		 * @return
		 */		
		public static function ratio(added:Number, total:Number):Number
		{
			var ratio:Number = added / total;
			
			ratio = Math.min(ratio, 1);
			ratio = Math.max(ratio, 0);
			
			return ratio;
		}
		
		/**
		 * Returns the distance between two points.
		 * 
		 * @param	x0				Origin point X
		 * @param	y0				Origin point Y
		 * @param	x1				Destiny point X
		 * @param	y1				Destiny point Y
		 * 
		 * @return					The distance.
		 */
		public static function getDistance(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			var xdist:Number =  Math.round(x1  - x0);
			var ydist:Number = Math.round(y1 - y0);
			var distance:Number = Math.round(Math.pow((xdist * xdist) + (ydist * ydist), 0.5));
			
			return distance;
		}
		
		/**
		 * Approaches an angle to another in increments of given degrees
		 * 
		 * @param	startAngle				Smallest number to be returned
		 * @param	endAngle				Largest number to be returned
		 * @param	increment				Increment degree
		 * 
		 * @return							The approximation to the angle in degrees.
		 */
		public static function nearAngle(startAngle:Number, endAngle:Number, increment:Number):Number
		{
			
			if (startAngle < endAngle && endAngle - startAngle > 180)
				startAngle += 360;
			
			if (startAngle > endAngle && startAngle - endAngle > 180)
			startAngle -= 360;
			
			if (startAngle < endAngle)
			{
				startAngle += increment;
				if (startAngle > endAngle) 
					startAngle = endAngle;
			}
			else
			{
				startAngle -= increment;
				if (startAngle < endAngle) 
					startAngle = endAngle;
			}

			if (startAngle < 0)
			{ 
				return startAngle + 360;
			}
			if (startAngle >= 360) 
			{
				return startAngle - 360;
			}
			
			return startAngle;
		}
		
		/**
		 * Returns the angle between two points taking the horizontal axis as base.
		 * 
		 * @param	x0				Origin point X
		 * @param	y0				Origin point Y
		 * @param	x1				Destiny point X
		 * @param	y1				Destiny point Y
		 *
		 * @return					The angle in degrees.
		 */
		public static function getAngle(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			return Math.atan2(y1 - y0, x1- x0) * 180 / Math.PI;
		}
		
		/**
		 * Returns the horizontal distance in pixels of a specified displacement.
		 * 
		 * @param	angle			Angle in degrees.
		 * @param	radius		    Radius in pixels
		 *
		 * @return					The distance in pixels. This is the same as cos(angle) * radius.
		 */
		public static function getDistX(angle:Number, radius:Number):Number
		{
			return Math.cos(angle * Math.PI / 180) * radius;
		}
		
		/**
		 * Returns the vertical distance in pixels of a specified displacement.
		 * 
		 * @param	angle			Angle in degrees.
		 * @param	radius		    Radius in pixels
		 *
		 * @return					The distance in pixels. This is the same as -sin(angle) * radius.
		 */
		public static function getDistY(angle:Number, radius:Number):Number
		{
			return -Math.sin(angle * Math.PI / 180) * radius;
		}
		
		/**
		 * Throws a defined ammount of dice.
		 * 
		 * @param	diceAmmount		How many dice will be thrown.
		 * @return					The total value of dice thrown.
		 */
		public static function throwDice(diceAmmount:uint = 1):uint
		{
			var dice:uint;
			for (var i:uint = 0; i < diceAmmount; i++)
			{
				dice += Math.round(rnd(1, 6));
			}
			
			return dice;
		}
		
		/**
		 * Transforms an RGB color into its Hex equivalent
		 * 
		 * @author	John del Rosario (http://blog.mindfock.com/)
		 * @param	r				Red Component (0 - 255)
		 * @param	g				Green Component (0 - 255)
		 * @param	b				Blue Component (0 - 255)
		 * @return					The hex value of the component
		 */
		public static function RGBToHex(r:uint, g:uint, b:uint):uint
		{
			var hex:uint = (r << 16 | g << 8 | b);
			return hex;
		}
		
		/**
		 * Transforms an hex color into RGB
		 * 
		 * @author	John del Rosario (http://blog.mindfock.com/)
		 * @param	hex				The hexadecimal value of the color
		 * @return					An array with the RGB components
		 */
		public static function HexToRGB(hex:uint):Array
		{
			var rgb:Array = [];

			var r:uint = hex >> 16 & 0xFF;
			var g:uint = hex >> 8 & 0xFF;
			var b:uint = hex & 0xFF;

			rgb.push(r, g, b);
			return rgb;
		}
		
		/**
		 * ...
		 * 
		 * @author	John del Rosario (http://blog.mindfock.com/)
		 * @param	r
		 * @param	g
		 * @param	b
		 * @return
		 */
		public static function RGBtoHSV(r:uint, g:uint, b:uint):Array
		{
			var max:uint = Math.max(r, g, b);
			var min:uint = Math.min(r, g, b);

			var hue:Number = 0;
			var saturation:Number = 0;
			var value:Number = 0;

			var hsv:Array = [];

			//get Hue
			if (max == min)
				hue = 0;
			else if(max == r)
				hue = (60 * (g-b) / (max-min) + 360) % 360;
			else if(max == g)
				hue = (60 * (b-r) / (max-min) + 120);
			else if(max == b)
				hue = (60 * (r-g) / (max-min) + 240);

			//get Value
			value = max;

			//get Saturation
			if(max == 0)
				saturation = 0;
			else
				saturation = (max - min) / max;

			hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
			return hsv;
		}
		
		/**
		 * ...
		 * @author	John del Rosario (http://blog.mindfock.com/)
		 * @param	h
		 * @param	s
		 * @param	v
		 * @return
		 */
		public static function HSVtoRGB(h:Number, s:Number, v:Number):Array
		{
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			var rgb:Array = [];

			var tempS:Number = s / 100;
			var tempV:Number = v / 100;

			var hi:int = Math.floor(h/60) % 6;
			var f:Number = h/60 - Math.floor(h/60);
			var p:Number = (tempV * (1 - tempS));
			var q:Number = (tempV * (1 - f * tempS));
			var t:Number = (tempV * (1 - (1 - f) * tempS));

			switch(hi){
				case 0: r = tempV; g = t; b = p; break;
				case 1: r = q; g = tempV; b = p; break;
				case 2: r = p; g = tempV; b = t; break;
				case 3: r = p; g = q; b = tempV; break;
				case 4: r = t; g = p; b = tempV; break;
				case 5: r = tempV; g = p; b = q; break;
			}

			rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
			return rgb;
		}

	}

}