App = {}
App.metagames = []

class App.Metagame
  constructor: (id) ->
    if id
      this.id = id
    else
      this.id = Math.random().toString(36).substring(2,6) # random hex id

  url: ->
    "/#{@id}"

  isAcceptingPlayers: ->
    true

  serverInit: (io) ->
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on('connection', (socket) =>
      console.log("GAME #{@id}: user connected: #{socket.id}")
      socket.on 'player joining', (data) => this.addPlayer(data.name, socket.id)
    )

  addPlayer: (name, id) =>
    this.players.push({name: name, id: id})
    this.sendPlayerList()

  removePlayer: (id) =>
    for index, player of this.players
      if (player.id == id)
        this.players.splice(index, 1);
        this.sendPlayerList()

  sendPlayerList: =>
    this.room.emit 'player list updated', this.players

  clientInit: (io, name) ->
    # create Metagame <div>
    this.el = $("<div>").addClass('active view').attr("id","metagame")
    $('.active.view').removeClass('active').hide()
    $('body').append(this.el)

    # connect to server and listen for players
    this.socket = io.connect("/#{@id}")
    this.socket.emit('player joining', {name: name})
    this.socket.on 'player list updated', (players) =>
      this.players = players
      this.drawPlayerList()

  drawPlayerList: =>
    console.log(this.players)
    this.el.html(JSON.stringify(this.players))

class App.Minigame

App.Utilities =
  checkOrientation: ->
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) and $(window).width() > $(window).height()
      alert('To play Mobile Party, you should use portrait orientation on your phone. (You may want to lock your phone in this orientation!)')
    
if module?
  module.exports = App
else
  window.App = App
