Server = {}

class Server.Metagame

  constructor: (@id) ->
  colors: [
    '#ff0000', #red
    '#ff6600', #orange
    '#ffe500', #yellow
    '#00cc00', #green
    '#0033cc', #blue
    '#9900cc', #purple
    '#ff00cc', #pink
  ]

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    null

  minigames: [
    {
      'name': 'TapRace'
      'src': "/assets/minigames/tap_race.js"
    }
  ]

  init: (io) =>
    console.log "New metagame with id #{this.id}"
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on 'connection', (socket) =>
      socket.on 'players: player joining', (data) => this.addPlayer(data.name, socket.id)
      socket.on 'minigame: done loading', => this.minigameDoneLoading(socket.id)
      socket.on 'minigame: gameover', (data) => this.gameover(data.score, socket.id)

  addPlayer: (name, id) =>
    this.colorCount = 0 if not this.colorCount
    this.players.push({name: name, id: id, color: this.colors[this.colorCount++ % this.colors.length], score: 0})
    this.sendPlayerList()
    if true #this.players.length >= 2
      this.loadRandomGame()

  removePlayer: (id) =>
    for index, player of this.players
      if (player.id == id)
        this.players.splice(index, 1)
        this.sendPlayerList()

  sendPlayerList: =>
    this.room.emit 'players: list updated', this.players

  isAcceptingPlayers: =>
    true

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    return null

  minigameDoneLoading: (id) =>
    #set this player to ready
    this.getPlayer(id).ready = true
    if this.allPlayersReady()
      this.start()

  allPlayersReady: => #server side check
    for player in this.players
      if !player.ready
        return false
    return true

  start: =>
    this.room.emit('minigame: start')

  loadRandomGame: =>
    this.loadGame(Math.floor(this.minigames.length * Math.random()))
    
  loadGame: (index) =>
    this.currentMinigameIndex = index
    for player in this.players
      player.ready = false
    this.room.emit 'minigame: load', {minigame: this.minigames[index]}

  gameover: (score, id) =>
    this.getPlayer(id).score = score
    this.sendPlayerList()


module.exports = Server.Metagame
