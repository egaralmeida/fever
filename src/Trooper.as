package  
{
	
	import org.flixel.*;
	
	/**
	 * An Agent of the Kingdom
	 * @author Egar Almeida
	 */
	public class Trooper extends Npc
	{
		// Asset Embedding
		[Embed(source = 'res/tropa.png')] private var imgClass:Class;
		
		public function Trooper() 
		{
			// Load Art Asset
			loadGraphic(imgClass, true, true, 25, 25, false);
			
			// Behavior
			autoJump = true;
		}
		
		override public function update():void
		{
						
			// NPC Update
			super.update();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			changeWalkingSpeed(100);
			moveToAPoint(X, Y);

			super.reset(GameState.main.CASTLE_DOOR_X, GameState.main.CASTLE_DOOR_Y);
		}
		
	}

}