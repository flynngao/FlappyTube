DEBUG = false
SPEED = 0
GRAVITY = 0

HEIGHT = 480
WIDTH = 287

tube = null
birds = null



main = ->
    preload = ->
      assets = 
        image:
          "bg" : 'res/bg.png'


      Object.keys(assets).forEach (type) ->
        Object.keys(assets[type]).forEach (id) ->
          game.load[type].apply game.load, [id].concat(assets[type][id])
          return
        return
      return

    create = ->
      game.add.sprite(0, 0, 'bg');
      return

    state =
      preload : preload
      create  : create

    game = new Phaser.Game(WIDTH, HEIGHT, Phaser.CANVAS, 'screem', state, false)
    

main()