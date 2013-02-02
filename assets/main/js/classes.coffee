App = {}
App.metagames = []
App.players = []
App.minigames = []

class App.Metagame
  constructor: ->
    this.id = 1   #Math.floor((Math.random()*10)+1)

  url: =>
    "/#{@id}"

  isAcceptingPlayers: =>
    true

  serverInit: (io) =>
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on 'connection', (socket) =>
      socket.on 'players: player joining', this.addPlayer
      socket.on 'minigame: done loading', this.minigameDoneLoading
      socket.on 'minigame: gameover', this.gameover

  gameover: (data) =>
    this.getPlayer(data.player.id).score = data.score

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    return null
    

  minigameDoneLoading: (data) =>
    #set this player to ready
    for player in this.players
      if player.id == data.player.id
        player.ready = true
        break
    if this.allPlayersReady()
      this.start()

  addPlayer: (data) =>
    this.players.push(data.player)
    this.room.emit 'players: list updated', this.players
    if true #this.players.length >= 2
      console.log 'LOADING GAME'
      this.loadFirstGame()

  allPlayersReady: => #server side check
    for player in this.players
      if !player.ready
        return false
    return true

  start: =>
    this.room.emit('minigame: start')

  loadFirstGame: =>
    #pick minigame
    this.currentMinigame = new App.Minigame
    for player in this.players
      player.ready = false
    this.room.emit 'minigame: load', {src: this.currentMinigame.src}

  clientInit: (io) ->
    # create Metagame <div>
    this.el = $("<div>").addClass('active view').attr("id","metagame").text("test")
    $('.active.view').removeClass('active')
    $('body').append(this.el)
    App.Utilities.resizeViewport()

    # connect to server and listen for players
    this.socket = io.connect("/#{@id}")
    this.socket.emit 'players: player joining', {player: App.player}

    this.socket.on 'players: list updated', (players) =>
      this.players = players
      this.drawPlayerList()

    this.socket.on 'minigame: load', this.minigameLoad

    this.socket.on 'minigame: start', ->
      App.minigames[0].start()

  drawPlayerList: =>
    console.log this
    console.log this.players
    this.el.html(JSON.stringify(this.players))

  minigameLoad: (data) =>
    #display loading.gif
    $.getScript(data.src).done (script, textStatus) =>
      #remove loading.gif
      this.ready = true
      this.socket.emit 'minigame: done loading', {player: App.player}

  clientGameover: (minigame) ->
    this.getPlayer(App.player.id).score = minigame.score
    this.socket.emit 'minigame: gameover',
      player: App.player
      score: minigame.score
    this.drawPlayerList()
    

class App.Player
  constructor: (@name) ->
    this.id = Math.random().toString(36).substring(2,8)  # random hex id

class App.Minigame
  constructor: ->
    console.log 'inserting minigame'
    this.id = Math.random().toString(36).substring(2,8)  # random hex id

  src: "/assets/minigames/default.js"

  start: =>
    console.log 'start me!'


App.Utilities =
  resizeViewport: ->
    windowSize = {
      width: $(window).width(),
      height: $(window).height()
    }

    # Find the currently active view and determine its dimensions
    view = $('body > div.view.active')
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
