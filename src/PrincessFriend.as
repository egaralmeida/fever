package  
{
	import org.flixel.*;
	
	/**
	 * An Friend of the Princess comes to visit
	 * @author Egar Almeida
	 */
	public class PrincessFriend extends Npc
	{
		// Sexy embedding
		[Embed(source = 'res/bolas.png')] private var imgClass:Class;
		
		// Quality time control
		private const HAPPY_TIME:Number = 5;
		private var happyTimeTimer:Number = 0;
		
		private var xDestiny:Number = 0;
		private var yDestiny:Number = 0;
		
		// The sign on the princess' bedroom door
		private var inBusiness:Boolean;
		
		public function PrincessFriend() 
		{
			// Load Art Ass
			loadGraphic(imgClass, true, true, 25, 25, false);
			
			// Naughty Behavior
			autoJump = true;
		}
		
		override public function update():void
		{
			if (inBusiness)
			{
				happyTimeTimer += FlxG.elapsed;
				if (happyTimeTimer >= HAPPY_TIME)
				{
					happyTimeTimer = 0;
					
					// Get tha hell outta there!
					visible = true;
					jump();
					moveToAPoint(xDestiny, yDestiny);
					
					// Don't forget the sign!
					inBusiness = false;
				}
			}
			
			if (inDestiny)
				kill();
		
			// Spread the news
			super.update();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			// Stretch ma'legs
			changeWalkingSpeed(150);
			changeJumpForce(400);
			
			// Mind the escape routes, just in case
			xDestiny = X;
			yDestiny = Y;
			
			// Put on the sign
			inBusiness = true;
			
			// Go in!
			visible = false;
			
			super.reset(GameState.main.CASTLE_DOOR_X, GameState.main.CASTLE_DOOR_Y);
		}
	}

}