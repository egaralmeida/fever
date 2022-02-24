package  
{
	import org.flixel.*;
	
	/**
	 * NPC Base Class
	 * @author Egar Almeida
	 */
	public class Npc extends Character
	{
		// Movement
		static public const WALK_LEFT:int = -1;
		static public const WALK_STOP:int = 0;
		static public const WALK_RIGHT:int = 1;
		
		/**
		 * If activated, the character will automatically jump when stuck.
		 * If not, he will stop trying to move.
		 */
		public var autoJump:Boolean = false;
		
		// Internal behavior control
		private static const FIGHTING_HIT_TIME:Number = 0.25;
		
		private var xOrigin:Number = 0;
		private var yOrigin:Number = 0;
		private var xDestiny:Number = 0;
		private var yDestiny:Number = 0;
		
		private var movingToAPoint:Boolean = false;
		
		private var fighting:Boolean = false;
		private var fightingHitTimer:Number = 0;
		
		public var inDestiny:Boolean = false;
		
		public function Npc()
		{
			// Initial Parameters
			health = 100;
			fixed = false;
		
			// Calculate Movement Bounds 
			changeWalkingSpeed();
			changeGravity();
			changeJumpForce();

			// Set animations
			addAnimation("Idle", [2], 0, false);
			addAnimation("Falling", [9], 0, false);
			addAnimation("Jumping", [8], 0, false);
			addAnimation("Walking", [0, 1, 2, 3, 4, 3, 2, 1], 6, true);
			addAnimation("WalkingFast", [0, 1, 2, 3, 4, 3, 2, 1], 16, true);
			addAnimation("Fighting", [5, 6, 7, 6, 5], 10, true);
		}
		
		public function moveToAPoint(xDest:Number = 0, yDest:Number = 0):void
		{
			// Save values
			xDestiny = xDest;
			yDestiny = yDest;
			
			movingToAPoint = true;
		}
		
		/**
		 * Fight!
		 * I wanna see some guts spilled!
		 * @param	myEnemy
		 * @param	myDices
		 */
		public function fight(myEnemy:FlxObject, diceAmmount:uint = 1):void
		{
			if(myEnemy.exists)
			{
				if (!fighting)
				{
					cancelAll();
					fighting = true;
				}
				
				if(fighting)
				{
					fightingHitTimer += FlxG.elapsed;
					if (fightingHitTimer >= FIGHTING_HIT_TIME)
					{
						fightingHitTimer -= FIGHTING_HIT_TIME;
						
						myEnemy.hurt(Utils.throwDice(diceAmmount));
					}
				}
			}
			if(!myEnemy.exists)
			{
				fightStop();
				if (!inDestiny)
					movingToAPoint = true;
			}

		}
		
		/**
		 * Stop Fighting!
		 * Violence solves nothing!
		 */
		public function fightStop():void
		{
			fighting = false;
		}
		
		/**
		 * Cancel everything.
		 */
		public function cancelAll():void
		{
			walk(WALK_STOP);
			fightStop();
			movingToAPoint = false;
		}
		
		/**
		 * Update!
		 */
		override public function update():void
		{
			// Animate
			animate();
			
			// Update movement
			updateMovement();
			
			// Sprite update
			super.update();
		}
		
		/**
		 * Animates the character according to it's movement.
		 */
		public function animate():void
		{
			if (velocity.y > 0)
				play("Falling");
			else if (velocity.y < 0)
				play("Jumping");
			else if (velocity.x != 0)
				play(walkingAnimation);
			else
			{
				if(!fighting)
					play("Idle");
				else
					play("Fighting");
			}
		}
		
		/**
		 * Updates the character's movement according to his current state
		 */
		public function updateMovement():void
		{
			// Moving to a point
			if (movingToAPoint)
			{
				// Determine direction
				if (x > xDestiny)
					walk(WALK_LEFT);
				else if (x < xDestiny)
					walk(WALK_RIGHT);
				
				// Have I reached my destination?
				if (x == xDestiny || Utils.getDistance(x, y, xDestiny, y) <= 1)
				{
					movingToAPoint = false;
					inDestiny = true;
					walk(WALK_STOP);
				}
			}
				
			// If I'm stuck...
			if ((walkingDirection != WALK_STOP) && velocity.x == 0 && onFloor)
			{
				// ... I'll jump if I must.
				if (autoJump)
				{
					if (!fighting)
						jump();
				}
				// Otherwise I'll just stop trying to move.
				else
					walk(WALK_STOP);
			}
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			xOrigin = X;
			yOrigin = Y;
			health = 100;
			super.reset(X, Y);
		}
		
		override public function hurt(Damage:Number):void
		{
			trace("I have been damaged by " + Damage + " points! My health is " + health);
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			cancelAll();
			inDestiny = false;
			super.kill();
		}
	
	}
}