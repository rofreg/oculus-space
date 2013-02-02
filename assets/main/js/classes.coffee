App = {}
App.metagames = []
App.players = []

class App.Metagame
  constructor: ->
    this.id = 1   #Math.floor((Math.random()*10)+1)

  url: ->
    "/#{@id}"

  isAcceptingPlayers: ->
    true

  serverInit: (io) ->
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on('connection', (socket) =>
        socket.on 'player joining', this.addPlayer
      )

  addPlayer: (data) =>
    this.players.push(data.player)
    this.room.emit 'player list updated', this.players

  clientInit: (io) ->
    # create Metagame <div>
    this.el = $("<div>").addClass('active view').attr("id","metagame").text("test")
    $('.active.view').removeClass('active')
    $('body').append(this.el)
    App.Utilities.resizeViewport()

    # connect to server and listen for players
    this.socket = io.connect("/#{@id}")
    this.socket.emit('player joining', {player: App.player})
    this.socket.on 'player list updated', (players) =>
      this.players = players
      this.drawPlayerList()

  drawPlayerList: =>
    console.log(this.players)
    this.el.html(JSON.stringify(this.players))

class App.Player
  constructor: (@name) ->
    this.id = Math.random().toString(36).substring(2,8)  # random hex id

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
