package  
{
	import org.flixel.*;
	
	/**
	 * Avatar
	 * @author Egar Almeida
	 */
	public class Player extends Character
	{
		// Embed required art assets
		[Embed(source = 'res/rey.png')] private var imgClass:Class;
		[Embed(source = 'sfx/respawn3.mp3')] private var sfxRespawn:Class;
		
		// Constants
		private const TROOPER_CALLING_TIME:Number = 1.5;
		
		public var wavingFlag:Boolean = false;
		public var trooperCalling:Boolean = false;
		private var trooperCallingTimer:Number = 0;
		
		public function Player() 
		{
			// Load Art Assets
			loadGraphic(imgClass, true, true, 25, 50, true);
			
			// Enable antialiasing
			antialiasing = true;
			
			// Shrink bounding box
			width = 25;
			height = 25;
			
			// Offset bounding box
			offset.y = 25;
			
			// Enable collision response
			fixed = false;
			
			// Set movement variables
			changeWalkingSpeed(200, 8);
			
			// Set status variables
			health = 100;
			
			// Set animations
			addAnimation("Idle", [2], 0, false);
			addAnimation("Walking", [0, 1, 2, 3, 4, 3, 2, 1], 20, true);
			addAnimation("Jumping", [8], 0, false);
			addAnimation("Falling", [9], 0, false);
			addAnimation("Calling", [5, 6, 7, 6], 5, true);
		}
		
		/**
		 * Apply damage to the object.
		 * @param	Damage
		 */
		override public function hurt(Damage:Number):void
		{
			// Only receives damage if not flickering
			if(!flickering())
				super.hurt(Damage);
		}
		
		/**
		 * Kill the object.
		 */
		override public function kill():void
		{
			// Powerful explosion sound
			FlxG.play(GameState.sfxExplosion);
			FlxG.play(GameState.sfxExplosion);
			FlxG.play(GameState.sfxExplosion);

			// Flash and Quake (Dramatic!)
			FlxG.flash.start(0xffffffff, 0.5);
			FlxG.quake.start(0.02, 0.8);
			
			// Gibs
			GameState.main.particleHeart.at(this);
			GameState.main.particleHeart.start(true, 0, 50);
			
			super.kill();
		}
		
		/**
		 * Resets everything and positions the ship.
		 * @param	X
		 * @param	Y
		 */
		override public function reset(X:Number,Y:Number):void
		{
			velocity.x = velocity.y = 0;
			
			health = 100;
			lives--;
			
			// Play spawning sound
			FlxG.play(sfxRespawn, 1, false);
			
			super.reset(X, Y);
		}
		
		public function callTrooper():void
		{
			if (!trooperCalling)
			{
				trooperCalling = true;
				trooperCallingTimer = 0;
			}
		}
		
		public function unCallTrooper():void
		{
			if (trooperCalling)
			{
				trooperCalling = false;
				wavingFlag = false;
				trooperCallingTimer = 0;
			}
		}
	
		override public function update():void
		{
			//acceleration.x = 0;
			walk(WALK_STOP);
			
			// Act
			if (wavingFlag)
				callTrooper();
			else
				unCallTrooper();
				
			// Trooper control
			if (trooperCalling)
			{
				trooperCallingTimer += FlxG.elapsed;
				if (trooperCallingTimer >= TROOPER_CALLING_TIME)
				{
					trooperCallingTimer -= TROOPER_CALLING_TIME;
					GameState.main.troopers.resetFirstAvail(x, y);
					unCallTrooper();
				}
			}
				
			// Animate
			if (velocity.y > 0)
				play("Falling");
			else if (velocity.y < 0)
				play("Jumping");
			else if (velocity.x != 0)
				play("Walking");
			else
			{
				if(!wavingFlag)
					play("Idle");
				else
					play("Calling");
			}
				
			// Get and act to input
			if (FlxG.keys.pressed("A"))
				walk(WALK_LEFT);

			if (FlxG.keys.pressed("D"))
				walk(WALK_RIGHT);
			
			// Jump
			if (FlxG.keys.pressed("W"))
				jump();
				
			// Call for arms
			if (FlxG.keys.justPressed("SPACE") && onFloor)
				wavingFlag = !wavingFlag;
			
			// Cancel call if I move
			if (velocity.x != 0 || velocity.y != 0)
				wavingFlag = false;				
				
			// Update!
			super.update();
			
			// Confine to world's bounds
			confine(0, GameState.main.WORLD_WIDTH - width);

		}
	}

}