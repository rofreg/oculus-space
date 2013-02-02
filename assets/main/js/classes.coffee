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
        socket.on 'player added', (data) =>
          socket.broadcast.emit 'player added', data
          if true#this.players.length >= 2
            this.start(socket)
      )

  start: (socket) ->
    #pick minigame
    this.currentMinigame = new App.Minigame
    socket.emit 'load minigame', {src: this.currentMinigame.src}
    #send minigame to all clients, wait for response

  clientInit: (io) ->
    this.socket = io.connect("/#{@id}")
    this.socket.emit('player added', {player: App.player.name})
    this.socket.on 'player added', ->
      console.log 'player added'

    this.socket.on 'load minigame', (data) ->
      console.log data

class App.Player
  constructor: (@name) ->

class App.Minigame
  src: "/assets/minigames/default.js"

if module?
  module.exports = App
else
  window.App = App
