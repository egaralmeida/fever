package 
{
	import org.flixel.*;
	
	/**
	 * The Princess
	 * @author Egar Almeida
	 */
	public class Princess extends FlxSprite
	{
		[Embed(source = 'res/princess.png')] private var imgClass:Class;
		
		public const STATE_IDLE:uint = 0;
		public const STATE_KISSING:uint = 1;
		
		public var state:uint = 0;
		
		private var heartsReleased:Boolean = false;
		
		public function Princess(X:Number, Y:Number)
		{
			loadGraphic(imgClass, false, true, 25, 25, false);
			x = X;
			y = Y;
		
			addAnimation("Idle", [1], 0, false);
			addAnimation("Kissing", [2, 2, 2, 2, 2, 0, 0, 0], 4, true);
		}
		
		override public function update():void
		{
			// Looks away from the king
			if (GameState.main.player.x > x)
				facing = LEFT;
			else
				facing = RIGHT;
			
			if (state == STATE_IDLE)
			{
				play("Idle");				
			}
			else if (state == STATE_KISSING)
			{
				play("Kissing");
				
				if (_curFrame == 5 && !heartsReleased)
				{
					if (facing == LEFT)
						GameState.main.particleHeart.setXSpeed( -150, -50);
					else
						GameState.main.particleHeart.setXSpeed(50, 150);

					GameState.main.particleHeart.at(this);
					GameState.main.particleHeart.start(true, 0, 50);
					
					heartsReleased = true;
				}
				else if (_curFrame == 7)
				{
					heartsReleased = false;
					state = STATE_IDLE;
				}
			}
			
			super.update();
		}
		
	}
	
}