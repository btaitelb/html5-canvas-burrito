Game = {}

$ ->
  Game.canvas = $("canvas")[0]
  Game.canvas.width = 700
  Game.canvas.height = 500
  Game.ctx = Game.canvas.getContext("2d")
  Game.ctx.fillRect(0, 0, Game.canvas.width, Game.canvas.height)
  Game.burrito =
    x: 100
    y: 100
    speed: 20
    load: ->
      @sprite = new Image()
      @sprite.src = "/assets/burrito.jpeg"
    render: ->
      Game.ctx.drawImage(@sprite, @x, @y)
    moveRight: ->
      @x = @x + @speed
    moveLeft: ->
      @x = @x - @speed
    moveTop: ->
      @y = @y - @speed
    moveDown: ->
      @y = @y + @speed

  Game.burrito.load()
  Game.mainLoop()

Game.mainLoop = ->
  Game.ctx.fillRect(0, 0, Game.canvas.width, Game.canvas.height)
  Game.burrito.render()
  window.setTimeout Game.mainLoop, 1000 / 60


Game.processKey = (e) ->
  if e.keyCode == 37
    Game.burrito.moveLeft()
  if e.keyCode == 38
    Game.burrito.moveTop()
  if e.keyCode == 39
    Game.burrito.moveRight()
  if e.keyCode == 40
    Game.burrito.moveDown()

window.addEventListener('keydown', Game.processKey, false)
