Game = {}

$ ->
  Game.canvas = $("canvas")[0]
  Game.canvas.width = 700
  Game.canvas.height = 500
  Game.ctx = Game.canvas.getContext("2d")
  Game.ctx.fillRect(0, 0, Game.canvas.width, Game.canvas.height)
  Game.KEY_LEFT = 37
  Game.KEY_UP = 38
  Game.KEY_RIGHT = 39
  Game.KEY_DOWN = 40
  Game.keysDown = []
  Game.isGameOver = false
  Game.bird =
    x: 100
    y: 100
    speedX: 0
    speedY: 0
    accelX: 0
    accelY: 0
    currentSpriteFrame: 0.0
    load: ->
      @sprites = []
      for i in [0..11]
        @sprites[i] = new Image()
        @sprites[i].src = "/assets/bird_#{i}.png"
      @currentSprite = @sprites[0]
    render: ->
      Game.ctx.drawImage(@currentSprite, @x, @y)
    accelRight: (dt)->
      @accelX += 50.0*dt
      @accelX = 5 if @accelX > 5
    accelLeft: (dt)->
      @accelX -= 50.0*dt
      @accelX = -5 if @accelX < -5
    accelTop: (dt)->
      @accelY -= 50.0*dt
      @accelY = 5 if @accelY > 5
    accelDown: (dt)->
      @accelY += 50.0*dt
      @accelY = -5 if @accelY < -5
    update: (dt)->
      @speedX += @accelX * dt * 0.5
      @speedY += @accelY * dt * 0.5

      @speedX = Math.min(@speedX, 60)
      @speedX = Math.max(@speedX, -60)
      @speedY = Math.min(@speedY, 60)
      @speedY = Math.max(@speedY, -60)

      @x += @speedX * dt
      @y += @speedY * dt

      if @x > 700 || @x < 0 || @y > 500 || @y < 0
        Game.gameOver()

      speed = Math.sqrt(@speedX*@speedX + @speedY*@speedY)
      @currentSpriteFrame += dt * speed / 2.0
      @currentSpriteFrame = 0 if @currentSpriteFrame > 11
      @currentSprite = @sprites[Math.floor(@currentSpriteFrame)]

  Game.update = (dt)->
    # if user is pressing right arrow
    # increment the right arrow speed
    # update the burrito based on the speed
    if Game.keysDown[Game.KEY_LEFT]
      Game.bird.accelLeft(dt)
    if Game.keysDown[Game.KEY_UP]
      Game.bird.accelTop(dt)
    if Game.keysDown[Game.KEY_RIGHT]
      Game.bird.accelRight(dt)
    if Game.keysDown[Game.KEY_DOWN]
      Game.bird.accelDown(dt)

    Game.bird.update(dt)


  Game.render = ()->
    Game.ctx.fillStyle = "rgb(255,255,255)"
    Game.ctx.fillRect(0, 0, Game.canvas.width, Game.canvas.height)
    Game.bird.render()

  Game.lastUpdatedAt = Date.now()

  # this is the main loop
  Game.mainLoop = ->
    now = Date.now()
    dt = (now - Game.lastUpdatedAt) / 1000.0
    Game.update(dt)
    Game.render()
    Game.lastUpdatedAt = now

    if Game.isGameOver
      Game.gameOver()
    else
      requestAnimationFrame(Game.mainLoop)

  Game.gameOver = ->
    Game.ctx.fillStyle = "rgb(255,30,30)"
    Game.ctx.fillRect(0, 0, Game.canvas.width, Game.canvas.height)
    Game.isGameOver = true
    $('h1').text('You Suck!')
    img = new Image()
    img.src = "/assets/skull.png"
    Game.ctx.drawImage(img, 100, 0)

  Game.processKeyDown = (e) ->
    Game.keysDown[e.keyCode] = true
  Game.processKeyUp = (e) ->
    Game.keysDown[e.keyCode] = false

  window.addEventListener('keydown', Game.processKeyDown, false)
  window.addEventListener('keyup', Game.processKeyUp, false)

  Game.bird.load()
  Game.mainLoop()

