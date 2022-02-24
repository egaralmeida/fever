package  
{
	import org.flixel.*;
	
	/**
	 * An Offender of the Kingdom
	 * @author Egar Almeida
	 */
	public class Offender extends Npc
	{
		// Asset Embedding
		[Embed(source = 'res/malo.png')] private var imgClass:Class;
		
		public function Offender() 
		{
			// Load Art Asset
			loadGraphic(imgClass, true, true, 25, 25, false);
			
			autoJump = true;

		}
		
		override public function update():void
		{			
			// If I have reached my destiny... joy.
			if (inDestiny)
			{
				// Determine my escape route
				if (Math.round(Utils.rnd(0, 1)) == 0)
					GameState.main.princessFriends.resetFirstAvail(GameState.main.OFFENDER_LEFT_X, GameState.main.OFFENDER_LEFT_Y);
				else
					GameState.main.princessFriends.resetFirstAvail(GameState.main.OFFENDER_RIGHT_X, GameState.main.OFFENDER_RIGHT_Y);
				
				// Dissapear	
				kill();
			}
			
			// NPC Update
			super.update();
		}
		
		override public function reset(X:Number, Y:Number):void
		{

			moveToAPoint(GameState.main.CASTLE_DOOR_X, GameState.main.CASTLE_DOOR_Y);

			super.reset(X, Y);
		}
		
	}

}