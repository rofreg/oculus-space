App =
  Metagames:
    Default: {}

class App.Metagames.Default.Parent

  constructor: (id) ->
    this.id or= Math.random().toString(36).substring(2,6)

  url: =>
    "/#{@id}"

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    null

  allMinigames: [
    {
      'name': 'TapRace'
      'src': "/assets/minigames/tap_race.js"
    }
  ]

  minigames: [
    {
      'name': 'TapRace'
      'src': "/assets/minigames/tap_race.js"
    }
  ]


class App.Metagames.Default.Server extends App.Metagames.Default.Parent

  init: (io) =>
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on 'connection', (socket) =>
      socket.on 'players: player joining', this.addPlayer
      socket.on 'minigame: done loading', this.minigameDoneLoading
      socket.on 'minigame: gameover', this.gameover

  isAcceptingPlayers: =>
    true

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
      this.loadGame(0)

  allPlayersReady: => #server side check
    for player in this.players
      if !player.ready
        return false
    return true

  start: =>
    this.room.emit('minigame: start')

  loadGame: (index) =>
    this.currentMinigame = index
    for player in this.players
      player.ready = false
    this.room.emit 'minigame: load', {src: this.minigames[index].src}

  gameover: (data) =>
    this.getPlayer(data.player.id).score = data.score

class App.Metagames.Default.Client extends App.Metagames.Default.Parent

  init: (io) ->
    # create Metagame <div>
    this.el = $("<div>").addClass('active view').attr("id","metagame")
    $('.active.view').removeClass('active').hide()
    $('body').append(this.el)

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

  gameover: (minigame) ->
    this.getPlayer(App.player.id).score = minigame.score
    this.socket.emit 'minigame: gameover',
      player: App.player
      score: minigame.score
    this.drawPlayerList()
    

if module?
  module.exports = App.Metagames.Default
else
  window.App = App
