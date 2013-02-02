App = {}
App.metagames = []
App.players = []

class App.Metagame
  constructor: ->
    this.id = 1#Math.floor((Math.random()*10)+1)

  url: ->
    "/#{@id}"

  isAcceptingPlayers: ->
    true

  serverInit: (io) ->
    this.room = io
      .of("/#{@id}")
      .on('connection', (socket) ->
        socket.on 'player added', (data) ->
          console.log data
          socket.broadcast.emit 'player added', data
      )

  clientInit: (io) ->
    this.socket = io.connect("/#{@id}")
    this.socket.emit('player added', {player: App.player.name})
    this.socket.on 'player added', ->
      console.log 'player added'

class App.Player
  constructor: (@name) ->

class App.Minigame

App.Utilities =
  resizeViewport: ->
    windowSize = {
      width: $(window).width(),
      height: $(window).height()
    }

    # Find the currently active view and determine its dimensions
    view = $('body > div.view.active');
    if view.length == 0
      return

    viewSize = {
      width: view.width(),
      height: view.height()
    }

    # Place all views in the middle of the screen
    view.css({
      position: 'absolute',
      top: '50%',
      left: '50%',
      marginTop: "-"+(viewSize.height / 2)+"px",
      marginLeft: "-"+(viewSize.width / 2)+"px"
    })

    # If item is wider than it is tall, ratio > 1
    windowSize.ratio = windowSize.width * 1.0 / windowSize.height
    viewSize.ratio = viewSize.width * 1.0 / viewSize.height
    viewport = document.querySelector("meta[name=viewport]")

    # Resize the mobile window to fit the active view (with letterboxing)
    if viewSize.ratio < windowSize.ratio
      # The view is taller/narrower than the window.
      # We'll need letterboxing on the left and right.
      viewport.setAttribute('content',
        'width='+(viewSize.height * windowSize.ratio)+', user-scalable=0')
    else
      # The view is shorter and fatter than the window.
      # We'll need letterboxing on top and bottom.
      viewport.setAttribute('content','width='+viewSize.width+', user-scalable=0')
    
if module?
  module.exports = App
else
  window.App = App
