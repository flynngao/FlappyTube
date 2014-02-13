DEBUG = false
SPEED = 100
GRAVITY = 20

HEIGHT = 480
WIDTH = 287
GAME_HEIGHT = 336
GROUND_HEIGHT = 64
GROUND_Y = HEIGHT - GROUND_HEIGHT

tube = null
birds = null
ground = null
bg = null

gameStart = false
gameOver  = false
score = null
scoreText = null
instText = null
gameOverText = null

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
      return

    over = ->
      gameOver = true
      return

    preload = ->
      assets = 
        image:
          "bg"     : 'res/bg.png'
          "birdy"  : 'res/birdy.png'
          "g"      : 'res/g.png'
          "tube"   : 'res/tube.png'
        audio:
          "die"    : 'res/sfx_die.mp3'
          "hit"    : 'res/sfx_hit.mp3'
          "point"  : 'res/sfx_point.mp3'
          "flap"   : 'res/sfx_wing.mp3'


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

      tube  = game.add.sprite(0,0,"tube")
      tube.anchor.setTo(0.5 , 0.5)

      # Add sounds
      flapSnd = game.add.audio("flap")
      scoreSnd = game.add.audio("score")
      hurtSnd = game.add.audio("hurt")
      fallSnd = game.add.audio("fall")
      swooshSnd = game.add.audio("swoosh")

      game.input.onDown.add flap

      reset()

      return

    update = ->
      if gameStart

        # Scroll ground 
        ground.tilePosition.x -= game.time.physicsElapsed * SPEED / 2 unless gameOver
        bg.tilePosition.x -= game.time.physicsElapsed * SPEED unless gameOver

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