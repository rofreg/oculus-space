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
        socket.emit('player added')
      )

  clientInit: (io) ->
    this.socket = io.connect("/#{@id}", {name: 'kyle'})
    this.socket.on 'player added', ->
      console.log 'player added'

class App.Player
  constructor: (@name) ->

class App.Minigame

if module?
  module.exports = App
else
  window.App = App
