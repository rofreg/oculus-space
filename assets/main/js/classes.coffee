App = {}
App.metagames = []
App.players = []

class App.Metagame
  constructor: ->
    this.id = Math.random().toString(36).substring(2,6) # random hex id

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
    this.id = Math.random().toString(36).substring(2,6)  # random hex id

class App.Minigame

App.Utilities =
  checkOrientation: ->
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) and $(window).width() > $(window).height()
      alert('To play Mobile Party, you should use portrait orientation on your phone. (You may want to lock your phone in this orientation!)')
    
if module?
  module.exports = App
else
  window.App = App
