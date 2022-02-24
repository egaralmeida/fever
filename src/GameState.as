package  
{
	import org.flixel.*;
	
	/**
	 * The Princes Has a Fever! (Prototype)
	 * @author Egar Almeida
	 */
	public class GameState extends FlxState
	{
		// Embed required assets
		[Embed(source = 'res/aim.png')] private var imgAim:Class;
		[Embed(source = 'res/corazones.png')] private var imgParticles:Class;
		
		[Embed(source = 'sfx/explosion1.mp3')] public static var sfxExplosion:Class;
		
		// Level assets
		[Embed(source = 'map/map2_floor.txt', mimeType = "application/octet-stream")] private static var mapLevel1_floors:Class;
		[Embed(source = 'map/map2_details.txt', mimeType = "application/octet-stream")] private static var mapLevel1_details:Class;
		[Embed(source = 'res/tiles.png')] private static var imgTile1:Class;
		[Embed(source = 'res/princess_fever_fondo.png')] private static var imgBg:Class;

		// Constants
		private const TIME_PLAYER_RESPAWN:Number = 3;

		public const WORLD_WIDTH:Number = 1000;
		public const WORLD_HEIGHT:Number = 400;
		
		private const WAVE_TIME:Number = 5;
		private const WAVE_SPAWNING_TIME:Number = 1.5;
		
		private const MAX_TROOPERS:Number = 10;
		private const MAX_OFFENDERS:Number = 5;
		private const MAX_PRINCESSFRIENDS:Number = 5;
		
		public const CASTLE_DOOR_X:uint = 500;
		public const CASTLE_DOOR_Y:uint = 222;
		public const OFFENDER_LEFT_X:uint = 10;
		public const OFFENDER_LEFT_Y:uint = 250;
		public const OFFENDER_RIGHT_X:uint = 990;
		public const OFFENDER_RIGHT_Y:uint = 250;
		
		// Declarations
		public static var main:GameState; 		// Holds the gamestate object

		public var background:FlxSprite;
		public var player:Player;
		public var princess:Princess;
		public var particleHeart:FlxEmitter;
		public var enemies:FlxGroup;
		public var troopers:FlxGroup;
		public var offenders:FlxGroup;
		public var princessFriends:FlxGroup;
		
		public var level1_floors:FlxTilemap;
		public var level1_details:FlxTilemap;
		
		private var playerRespawnTimer:Number = 0;
		private var enemyRespawnTimer:Number = 0;
		
		private var waveTimer:Number = 0;
		private var waveSpawningTimer:Number = 0;
		private var spawningWave:Boolean = false;
		private var spawningCounter:uint = 0;
		
		// Useful to access the gamestate from another class without
		// passing it as an argument.
		public function GameState()
		{
			main = this;
		}
		
		override public function create():void
		{
			// Create Level and Objects
			createLevel();
			createPlayer();
			createPrincess();
			createParticles();
			createOffenders();
			createTroopers();
			createPrincessFriends();
						
			// Load BG
			add(background = new FlxSprite(0, 0, imgBg));
			
			// Add everything in render order
			add(level1_floors);
			add(level1_details);
			add(princess);
			add(player);
			add(offenders);
			add(troopers);
			add(princessFriends);
			add(particleHeart);


			// Set camera
			FlxG.follow(player, 15);
			FlxG.followBounds(0, 0, WORLD_WIDTH, WORLD_HEIGHT);
			
			// Show the mouse
			FlxG.mouse.show(imgAim, 5, 5);
		}
		
		private function createLevel():void
		{
			level1_floors = new FlxTilemap();
			level1_floors.loadMap(new mapLevel1_floors, imgTile1, 25, 25);
			
			level1_details = new FlxTilemap();
			level1_details.loadMap(new mapLevel1_details, imgTile1, 25, 25);
		}
		
		private function createPlayer():void
		{
			player = new Player();
			player.reset(CASTLE_DOOR_X, CASTLE_DOOR_Y);
		}
		
		private function createPrincess():void
		{
			princess = new Princess(500, 178);
		}
		
		private function createTroopers():void
		{
			troopers = new FlxGroup();
			for (var i:Number = 0; i < MAX_TROOPERS; i++)
			{
				var trooper:Trooper = new Trooper();
				trooper.exists = false;
				troopers.add(trooper);
			}
		}
		
		private function createOffenders():void
		{
			offenders = new FlxGroup();
			for (var i:Number = 0; i < MAX_OFFENDERS; i++)
			{
				var offender:Offender = new Offender();
				offender.exists = false;
				offenders.add(offender);
			}
		}
		
		private function createPrincessFriends():void
		{
			princessFriends = new FlxGroup();
			for (var i:Number = 0; i < MAX_PRINCESSFRIENDS; i++)
			{
				var princessFriend:PrincessFriend = new PrincessFriend();
				princessFriend.exists = false;
				princessFriends.add(princessFriend);
			}
		}
		
		private function createParticles():void 
		{
			particleHeart = new FlxEmitter;
			particleHeart.delay = 1.5;
			particleHeart.setXSpeed(50, 150);
			particleHeart.setRotation(0, 0);
			particleHeart.gravity = -300;
			particleHeart.createSprites(imgParticles, 5, 0, true);
		}
		
		public function overlapsOffendersTroopers(offender:Offender, trooper:Trooper):void
		{
			offender.enemyCollision(trooper);
			offender.fight(trooper, 2);
			trooper.fight(offender, 6);
		}
		
		override public function update():void
		{
			// Debug Keys
			getDebugKeys();
			
			// Wave control
			waveControl();
			
			// Collision check
			checkCollisions();
			
			// Resurrect ship if dead
			if (player.dead && player.checkLives())
			{
				playerRespawnTimer += FlxG.elapsed;
				if (playerRespawnTimer >= TIME_PLAYER_RESPAWN)
				{
					playerRespawnTimer -= TIME_PLAYER_RESPAWN;
					player.reset(WORLD_WIDTH / 2, WORLD_HEIGHT / 2);
					
					// This smooths the camera movement when the player reappears
					FlxG.followLerp = 5;
				}
			}
			
			if (!player.flickering())
			{
				// When the player stops flickering, the camera movement is returned to normal
				FlxG.followLerp = 15;
			}
			
			super.update();
		}
		
		private function checkCollisions():void
		{
			// Check for overlapses
			FlxU.overlap(offenders, troopers, overlapsOffendersTroopers);
			
			// Check for collisions
			level1_floors.collide(player);
			level1_floors.collide(troopers);
			level1_floors.collide(offenders);
			level1_floors.collide(princessFriends);

		}
		
		private function getDebugKeys():void
		{
			if (FlxG.keys.justPressed("B"))
				FlxG.showBounds = !FlxG.showBounds;
				
			if (FlxG.keys.justPressed("X"))
			{	
				trace("king(" + player.x + ", " + player.y + ")");
				trace("mouse(" + FlxG.mouse.cursor.x + ", " + FlxG.mouse.cursor.y + ")");
			}
		}
		
		private function waveControl():void
		{
			if (!spawningWave)
			{
				waveTimer += FlxG.elapsed;
				if (waveTimer >= WAVE_TIME)
				{
					waveTimer -= WAVE_TIME;
					spawningWave = true;
				}
			}
			else
			{
				// The princess starts kissing
				//if (princess.state != princess.STATE_KISSING)
					princess.state = princess.STATE_KISSING;
				
				if (spawningCounter < MAX_OFFENDERS)
				{
					waveSpawningTimer += FlxG.elapsed;
					if (waveSpawningTimer >= WAVE_SPAWNING_TIME)
					{
						waveSpawningTimer -= WAVE_SPAWNING_TIME;
						if (Math.round(Utils.rnd(0, 1)) == 0)
						{
							if (offenders.resetFirstAvail(OFFENDER_LEFT_X, OFFENDER_LEFT_Y))
								spawningCounter++;
						}
						else
						{
							if (offenders.resetFirstAvail(OFFENDER_RIGHT_X, OFFENDER_RIGHT_Y))
								spawningCounter++;
						}
					}
				}
				else
				{
					spawningWave = false;
					spawningCounter = 0;
					waveTimer = 0;
					waveSpawningTimer = 0;
				}
			}
		}
		
	}

}