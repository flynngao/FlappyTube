DEBUG = false
SPEED = 160
GRAVITY = 600
SPAWN_RATE = 1 / 1200

HEIGHT = 480
WIDTH = 287
GAME_HEIGHT = 336
GROUND_HEIGHT = 64
GROUND_Y = HEIGHT - GROUND_HEIGHT
HARD = 500

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
birdsTimer = null
dieRate = null
# Game Texts
score = null
bestScore = 0
bestText = null
scoreText = null
instText = null
gameOverText = null
resetText = null
gameStartText = null
avoidText = null
board = null
# Sounds
flapSnd = null
scoreSnd = null
hurtSnd = null
fallSnd = null
swooshSnd = null

floor = Math.floor

main = ->

    hitBirds = (tube,bird)->

      bird.kill()

      score += 1
      bestScore = if score > bestScore then score else bestScore
      scoreText.setText score

      b = bloods.getFirstDead()
      b.reset(bird.body.x,bird.body.y)
      b.play('blood',20,false,true)
      hurtSnd.play()
      return

    createBirds = ->

      dieRate = score / HARD
      for i in [(parseInt(Math.random()*10)%4+8)...0]
        raceName = if Math.random() > dieRate then 'birdy' else 'birddie'
        race = if raceName == 'birdy' then birds else birddie
        bird = race.create(game.world.width-(Math.random()-0.5)*120, i * (35-(Math.random()-0.5)*5), raceName)
        bird.anchor.setTo 0.5, 0.5
        bird.body.velocity.x = -SPEED
      
        
      return

    flap = ->

      start() unless gameStart 

      unless gameOver
        tube.body.velocity.y = -200;
        tube.body.gravity.y = 0;

        tween = game.add.tween(tube.body.velocity).to(y:-280, 25, Phaser.Easing.Bounce.In,true);
        tween.onComplete.add ->
            tube.body.gravity.y = GRAVITY

        flapSnd.play()
      

      return

    start = ->
      gameStart = true
      gameStartText.renderable = false
      # SPAWN birds!
      birdsTimer = game.time.events.loop 1 / SPAWN_RATE, createBirds
      scoreText.setText score
      avoidText.renderable = false
      return

    over = ->
      gameOver = true

      gameOverText.renderable = true
      resetText.renderable = true
      board.renderable = true
      bestText.renderable = true
      bestText.setText bestScore
      bestText.x = 210
      bestText.y = 240
      scoreText.x = 210
      scoreText.y = 195

      document.getElementById('star').style.display = 'block';
      # Stop spawning tubes
      game.time.events.remove(birdsTimer)


      game.time.events.add 1000, ->
          game.input.onTap.addOnce ->
            reset()
      fallSnd.play()
      return

    preload = ->
      assets = 
        image:
          "bg"     : 'res/bg.png'
          "birdy"  : 'res/birdy.png'
          "birddie": 'res/birddie.png'
          "g"      : 'res/g.png'
          "tube"   : 'res/tube.png'
          "start"  : 'res/start.png'
          "reset"  : 'res/reset.png'
          "over"   : 'res/over.png'
          "board"  : 'res/board.png'
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
      scoreSnd = game.add.audio("point")
      hurtSnd = game.add.audio("hit")
      fallSnd = game.add.audio("die")     
      
      #bloods
      bloods = game.add.group()
      bloods.createMultiple(20,'blood')
      bloods.forEach((x)->
        x.anchor.x = 0.5
        x.anchor.y = 0.5
        x.animations.add('blood')
        return
        this)

      board = game.add.sprite(game.world.width / 2 ,game.world.height / 2.3,'board')
      board.anchor.setTo 0.5, 0.5
      board.scale.setTo 1, 1
      board.renderable = false

      #score
      scoreText = game.add.text(game.world.width / 2, game.world.height / 6, "",
        font: "20px \"sans\""
        fill: "#fff"
        stroke:"#bbb"
        strokeThickness:4
        align:"center")
      scoreText.anchor.setTo 0.5 , 0.5

      bestText = game.add.text(game.world.width / 2, game.world.height / 6, "",
        font: "20px \"sans\""
        fill: "#fff"
        stroke:"#bbb"
        strokeThickness:4
        align:"center")
      bestText.anchor.setTo 0.5 , 0.5
      bestText.renderable = false

      avoidText = game.add.text(game.world.width / 2, game.world.height / 2.7, "",
        font: "14px \"sans\""
        fill: "#fff"
        stroke:"#bbb"
        strokeThickness:4
        align:"center")
      avoidText.anchor.setTo 0.5 , 0.5
      avoidText.setText("Avoid this")

      gameStartText = game.add.sprite(game.world.width / 2, game.world.height / 2,'start')
      gameStartText.anchor.setTo 0.5, 0.5
      gameStartText.scale.setTo 1, 1
      # Add game over text
      gameOverText = game.add.sprite(game.world.width / 2, game.world.height / 4,'over')
      gameOverText.anchor.setTo 0.5, 0.5
      gameOverText.scale.setTo 1, 1
      gameOverText.renderable = false


      
      


      resetText = game.add.sprite(game.world.width/ 2, game.world.height / 1.5,'reset')
      resetText.anchor.setTo 0.5, 0.5
      resetText.scale.setTo 1, 1
      resetText.renderable = false

      # control
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

            game.physics.overlap tube, birds, hitBirds, null ,this

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
      gameOverText.renderable = false
      resetText.renderable = false
      gameStartText.renderable = true
      board.renderable = false
      bestText.renderable = false
      avoidText.renderable = true
      document.getElementById('star').style.display = 'none';
      score = 0
      scoreText.setText('Flappy Tube')
      scoreText.x = game.world.width / 2
      scoreText.y = game.world.height / 6
      birds.removeAll()
      tube.reset game.world.width * 0.25, game.world.height /2.3


      return


    state =
      preload : preload
      create  : create
      update  : update
      render  : render

    game = new Phaser.Game(WIDTH, HEIGHT, Phaser.CANVAS, 'screem', state, false)
    

main()