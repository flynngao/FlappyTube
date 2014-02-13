DEBUG = false
SPEED = 100
GRAVITY = 20
SPAWN_RATE = 1 / 1200

HEIGHT = 480
WIDTH = 287
GAME_HEIGHT = 336
GROUND_HEIGHT = 64
GROUND_Y = HEIGHT - GROUND_HEIGHT

# Object
tube = null
birds = null
birddie = null
ground = null
bg = null
blood = null
bloods = null
# Game Flow
gameStart = false
gameOver  = false

# Game Texts
score = null
scoreText = null
instText = null
gameOverText = null

# Sounds
flapSnd = null
scoreSnd = null
hurtSnd = null
fallSnd = null
swooshSnd = null

floor = Math.floor

main = ->

    hitBirds = ->

      return

    createBirds = ->
     for i in [4...0]
        console.log i
      
        
      return

    flap = ->

      start() unless gameStart 

      unless gameOver
        tube.body.velocity.y = -100;
        tube.body.gravity.y = 0;

        tween = game.add.tween(tube.body.velocity).to(y:-20, 25, Phaser.Easing.Bounce.In,true);
        tween.onComplete.add ->
            tube.body.gravity.y = GRAVITY

        flapSnd.play()
      

      return

    start = ->

      gameStart = true

      # SPAWN tubeS!
      tubesTimer = game.time.events.loop 1 / SPAWN_RATE, createBirds
      scoreText.setText score
      return

    over = ->
      gameOver = true

      gameOverText.renderable = true

      return

    preload = ->
      assets = 
        image:
          "bg"     : 'res/bg.png'
          "birdy"  : 'res/birdy.png'
          "birddie": 'res/birddie.png'
          "g"      : 'res/g.png'
          "tube"   : 'res/tube.png'
        audio:
          "die"    : 'res/sfx_die.mp3'
          "hit"    : 'res/sfx_hit.mp3'
          "point"  : 'res/sfx_point.mp3'
          "flap"   : 'res/sfx_wing.mp3'
        spritesheet:
          "blood"  : ['res/blood.png',64, 64]



      Object.keys(assets).forEach (type) ->
        Object.keys(assets[type]).forEach (id) ->
          game.load[type].apply game.load, [id].concat(assets[type][id])
          return
        return
      return

    create = ->

      Phaser.Canvas.setSmoothingEnabled(game.context, false)
      game.stage.scaleMode = Phaser.StageScaleMode.SHOW_ALL
      game.stage.scale.setScreenSize(true)
      game.world.width = WIDTH
      game.world.height = HEIGHT


      # bg
      bg = game.add.tileSprite(0, 0,WIDTH,HEIGHT,'bg');

      # ground
      ground = game.add.tileSprite(0,GROUND_Y,WIDTH,GROUND_HEIGHT,'g');

      # Add Birds
      birds = game.add.group()
      birddie = game.add.group()

      tube  = game.add.sprite(0,0,"tube")
      tube.anchor.setTo(0.5 , 0.5)

      # Add sounds
      flapSnd = game.add.audio("flap")
      scoreSnd = game.add.audio("score")
      hurtSnd = game.add.audio("hurt")
      fallSnd = game.add.audio("fall")
      swooshSnd = game.add.audio("swoosh")

       #blood
      blood = game.add.sprite(100, 100, 'blood')
      

      

      #score
      scoreText = game.add.text(game.world.width / 2, game.world.height / 6, "",
        font: "10px \"sans\""
        fill: "#fff"
        stroke:"#bbb"
        strokeThickness:4
        align:"center")
      scoreText.anchor.setTo 0.5 , 0.5

      # Add game over text
      gameOverText = game.add.text(game.world.width / 2, game.world.height / 2, "",
          font: "16px \"Press Start 2P\""
          fill: "#fff"
          stroke: "#430"
          strokeThickness: 4
          align: "center"
      )
      gameOverText.anchor.setTo 0.5, 0.5
      gameOverText.scale.setTo 1, 1

      game.input.onDown.add flap

      reset()

      return

    update = ->
      if gameStart

        unless gameOver
            # Check game over
            game.physics.overlap tube, birddie, ->
              over()
              fallSnd.play()
            over() if not gameOver and tube.body.bottom >= GROUND_Y

            game.physics.overlap tube, birds, hitBirds

            # Scroll ground 
            ground.tilePosition.x -= game.time.physicsElapsed * SPEED / 2 unless gameOver
            bg.tilePosition.x -= game.time.physicsElapsed * SPEED unless gameOver


        else
            
            if tube.body.bottom >= GROUND_Y + 3
              tube.y = GROUND_Y - 13
              tube.body.velocity.y = 0
              tube.body.allowGravity = false
              tube.body.gravity.y = 0            

      return

    render = ->
      return

    reset = ->

      gameStart = false
      gameOver  = false

      score = 0
      birds.removeAll();
      createBirds();

      tube.reset game.world.width * 0.3, game.world.height /2


      return


    state =
      preload : preload
      create  : create
      update  : update
      render  : render

    game = new Phaser.Game(WIDTH, HEIGHT, Phaser.CANVAS, 'screem', state, false)
    

main()