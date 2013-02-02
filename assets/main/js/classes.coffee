App = {}
App.metagames = []
App.players = []
App.minigames = []

class App.Metagame
  constructor: ->
    this.id = 2 #Math.floor((Math.random()*10)+1)

  url: ->
    "/#{@id}"

  isAcceptingPlayers: ->
    true

  serverInit: (io) ->
    this.room = io
      .of("/#{@id}")
      .on 'connection', (socket) =>
        socket.on 'player added', (data) =>
          socket.broadcast.emit 'player added', data
          if true#this.players.length >= 2
            this.loadFirstGame(socket)
        socket.on 'load minigame - done', (data) =>
          #set this player to ready
          for player in this.players
            if player.id == data.player.id
              player.ready = true
              break
          if this.allPlayersReady()
            this.start(socket)

  allPlayersReady: -> #server side check
    for player in this.players
      if !player.ready
        return false
    return true

  start: ->
    socket.broadbase.emit('start minigame')
    socket.emit('start minigame')

  loadFirstGame: (socket) ->
    #pick minigame
    this.currentMinigame = new App.Minigame
    for player in this.players
      player.ready = false
    socket.emit 'load minigame', {src: this.currentMinigame.src}

  clientInit: (io) ->
    this.socket = io.connect("/#{@id}")
    this.socket.emit('player added', {player: App.player.name})
    this.socket.on 'player added', ->
      console.log 'player added'

    this.socket.on 'start minigame', ->
      console.log 'start the minigame!!!'

    this.socket.on 'load minigame', (data) ->
      console.log data
      $.getScript(data.src).done (script, textStatus) ->
        #set self to loaded

  loadMinigame: (src) ->
    #display loading.gif
    $.getScript(data.src).done (script, textStatus) ->
      #remove loading.gif
      this.socket.emit('load minigame - done')
    

class App.Player
  constructor: (@name) ->

class App.Minigame
  src: "/assets/minigames/default.js"

if module?
  module.exports = App
else
  window.App = App
