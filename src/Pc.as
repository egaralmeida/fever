package  
{
	import org.flixel.*;
	
	/**
	 * PC Base Class
	 * @author Egar Almeida
	 */
	public class Pc extends FlxSprite
	{
		// Movement
		static public const WALK_LEFT:int = -1;
		static public const WALK_STOP:int = 0;
		static public const WALK_RIGHT:int = 1;
		
		/**
		 * Jumping force.
		 */
		public var jumpForce:Number = 400;
		
		/**
		 * The gravity acceleration for this character.
		 */
		public var gravityAcceleration:Number = 980;
		
		/**
		 * The walking speed of this object.
		 */
		public var walkSpeed:Number = 50;
		
		/**
		 * The factor by which this object decelerates
		 */
		public var walkDecelerationFactor:uint = 8;
		
		/**
		 * If activated, the character will automatically jump when stuck.
		 * If not, he will stop trying to move.
		 */
		public var autoJumpWhenStuck:Boolean = false;
		
		// Internal behavior control
		private static const FIGHTING_HIT_TIME:Number = 0.25;
		private static const AUTOJUMP_DELAY_TIME:Number = 0.1;
		
		private var xOrigin:Number = 0;
		private var yOrigin:Number = 0;
		private var xDestiny:Number = 0;
		private var yDestiny:Number = 0;
		
		private var walkingDirection:int = 0;
		private var movingToAPoint:Boolean = false;
		
		private var fighting:Boolean = false;
		private var fightingHitTimer:Number = 0;
		
		public var inDestiny:Boolean = false;
		
		private var autoJumpDelayTimer:Number = 0;
		
		public function Pc()
		{
			// Initial Parameters
			health = 100;
			fixed = false;
		
			// Calculate Movement Bounds 
			changeWalkingSpeed(walkSpeed, walkDecelerationFactor);
			changeGravity(gravityAcceleration);
			changeJumpForce(jumpForce);

			// Set animations
			addAnimation("Idle", [2], 0, false);
			addAnimation("Falling", [9], 0, false);
			addAnimation("Jumping", [8], 0, false);
			addAnimation("Walking", [0, 1, 2, 3, 4, 3, 2, 1], 6, true);
			addAnimation("Fighting", [5, 6, 7, 6, 5], 10, true);
		}
		
		/**
		 * Changes walking speed and deceleration factors.
		 * @param	newSpeed
		 * @param	newWalkDecelerationFactor
		 */
		public function changeWalkingSpeed(newSpeed:Number = 50, newWalkDecelerationFactor:uint = 8):void
		{
			walkSpeed = newSpeed;
			walkDecelerationFactor = newWalkDecelerationFactor;
			
			drag.x = walkSpeed * walkDecelerationFactor;
			maxVelocity.x = walkSpeed;
		}
		
		/**
		 * Changes gravity for this character.
		 * @param	newGravityAcceleration
		 */
		public function changeGravity(newGravityAcceleration:Number = 980):void
		{
			gravityAcceleration = newGravityAcceleration;
			acceleration.y = newGravityAcceleration;
		}
		
		/**
		 * Changes the jumping force for this character.
		 * @param	newJumpForce
		 */
		public function changeJumpForce(newJumpForce:Number = 400):void
		{
			jumpForce = newJumpForce;
			maxVelocity.y = jumpForce;
		}
		
		/**
		 * Jumps, unless he's on the air.
		 * @return true if he can jump, false otherwise.
		 */
		public function jump():Boolean
		{
			if (onFloor)
			{
				velocity.y = -jumpForce;
				return true;
			}
			else
				return false;
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
		public function fight(myEnemy:FlxObject, myDices:uint = 1):void
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
						
						myEnemy.hurt(throwDice(myDices));
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
		 * Throws a defined ammount of dice.
		 * @param	diceAmmount
		 * @return	The total value of dice thrown.
		 */
		public function throwDice(diceAmmount:uint = 1):uint
		{
			var dice:uint;
			for (var i:uint = 0; i < diceAmmount; i++)
			{
				dice += Math.round(Utils.rnd(1, 6));
			}
			
			return dice;
		}
		
		/**
		 * Walk left.
		 */
		public function walkLeft():void
		{
			walkingDirection = WALK_LEFT;
		}
		
		/**
		 * Walk right.
		 */
		public function walkRight():void
		{
			walkingDirection = WALK_RIGHT;
		}
		
		/**
		 * Stop walking.
		 */
		public function walkStop():void
		{
			walkingDirection = WALK_STOP;
		}
		
		/**
		 * Cancel everything.
		 */
		public function cancelAll():void
		{
			walkingDirection = WALK_STOP;
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
		 * Walk
		 */
		public function walk(whichSide:int = WALK_STOP):void
		{			
			if (whichSide == WALK_LEFT)
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if (whichSide == WALK_RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			else
			{
				velocity.x = 0;
				acceleration.x = 0;
			}
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
				play("Walking");
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
			// Walk
			walk(walkingDirection);
			
			// Moving to a point
			if (movingToAPoint)
			{
				// Determine direction
				if (x < xDestiny)
					walkingDirection = WALK_RIGHT;
				else if (x > xDestiny)
					walkingDirection = WALK_LEFT;
				
				// Have I reached my destination?
				if (x == xDestiny || Utils.getDistance(x, y, xDestiny, y) <= 1)
				{
					movingToAPoint = false;
					inDestiny = true;
					walkingDirection = WALK_STOP;
				}
			}
				
			// If I'm stuck...
			if ((walkingDirection != WALK_STOP) && velocity.x == 0 && onFloor)
			{
				// ...I'll wait a tiny moment...
				autoJumpDelayTimer += FlxG.elapsed;
				if (autoJumpDelayTimer >= AUTOJUMP_DELAY_TIME)
				{
					autoJumpDelayTimer -= FlxG.elapsed;
					
					// and I'll jump if I must.
					if (autoJumpWhenStuck)
					{
						if (!fighting)
							jump();
					}
					// Otherwise I'll just stop trying to move.
					else
						walkingDirection = WALK_STOP;
				}
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