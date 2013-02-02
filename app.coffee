app = require('express')()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

server.listen(80)

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

App = {}
App.metagames = []
App.players = []

class Metagame
  id: ->
    Math.floor((Math.random()*10)+1)

  url: ->
    "/#{@id}"

class Player
  constructor: (@name) ->

io.sockets.on 'connection', (socket) ->
  socket.on 'new player', (data) ->
    player = data
    #add player to global collection
    App.players.push player

    #find game
    game = null
    for metagame in App.metagames
      if metagame.isAcceptingPlayers()
        game = metagame
        break

    if !game #still haven't found a game for them
      game = new App.Metagame
      App.metagames.push game

    socket.emit 'enter metagame', {metagame: metagame}

  socket.on 'my other event', (data) ->
    console.log(data)
