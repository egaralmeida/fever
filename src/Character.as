package  
{
	import org.flixel.*;
	
	/**
	 * Character Base Class
	 * @author Egar Almeida
	 */
	public class Character extends FlxSprite
	{
		// Movement
		public const WALK_LEFT:int = -1;
		public const WALK_STOP:int = 0;
		public const WALK_RIGHT:int = 1;
		
		/**
		 * Jumping force
		 */
		private var jumpForce:Number = 400;
		
		/**
		 * The gravity acceleration for this character
		 */
		private var gravityAcceleration:Number = 980;
		
		/**
		 * The walking speed of this object
		 */
		private var walkSpeed:Number = 50;
		
		/**
		 * The factor by which this object decelerates
		 */
		private var walkDecelerationFactor:uint = 8;
		
		/**
		 * The direction in which this character is walking
		 */
		protected var walkingDirection:int = 0;
		
		/**
		 * Ammount of lives for this character
		 */
		protected var lives:Number = 3;
		
		/**
		 * Which walking animation to use
		 */
		protected var walkingAnimation:String = "Walking";
		
		/**
		 * Whenever this character is colliding with an enemy this will be true
		 */
		protected var enemyColliding:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function Character()
		{
			// Calculate Movement Bounds 
			changeWalkingSpeed(walkSpeed, walkDecelerationFactor);
			changeGravity(gravityAcceleration);
			changeJumpForce(jumpForce);
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
			
			if (walkSpeed >= 100)
				walkingAnimation = "WalkingFast";
			else
				walkingAnimation = "Walking";
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
		
		/**
		 * Walk
		 * @param	direction	The direction
		 */
		public function walk(direction:int = 0):void
		{
			walkingDirection = direction;
			
			if (direction == WALK_LEFT)
			{
				facing = LEFT;
				acceleration.x -= drag.x;	
			}
			else if(direction == WALK_RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			else
				acceleration.x = 0;
		}
		
		/**
		 * Simple function that checks if I have enough lives left.
		 * @return True if I have any lives left.
		 */
		public function checkLives():Boolean
		{
			if (lives > 0)
				return true;
			else
				return false;
		}
		
		/**
		 * Overridable function. Sets enemy collision flag to true.
		 * @param	enemy
		 * @return
		 */
		public function enemyCollision(enemy:FlxObject):Boolean
		{
			enemyColliding = true;
			return true;
		}
		
		/**
		 * Update!
		 */
		override public function update():void
		{
			// Reset necessary flags
			resetFlags();
			
			// Sprite update
			super.update();
		}
		
		/**
		 * Resets flags
		 */
		private function resetFlags():void
		{
			enemyColliding = false;
		}
		
		/**
		 * Confines a character in a world
		 * @param	min
		 * @param	max
		 */
		public function confine(min:Number = 0, max:Number = 640):void
		{
			if (x > max)
			{
				velocity.x = 0;
				x = max;
			}
			else if (x < min)
			{
				velocity.x = 0;
				x = min;
			}
		}
	}
}