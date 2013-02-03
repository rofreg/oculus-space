class App.Metagame
  @TEMPLATES = "/assets/metagames/default/templates/templates.js"
  @STYLESHEET = "/assets/metagames/default/css/metagame.css"

  constructor: (@id) ->

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    null

  minigames: []

  init: (io, name) =>
    $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
    $.getScript(this.constructor.TEMPLATES).done (script, textStatus) =>
      console.log "New metagame with id #{this.id}"
      # create Metagame <div>
      this.el = $("<div>").addClass('active view').attr("id","metagame")
      $('.active.view').removeClass('active').hide()
      $('body').append(this.el)

      # connect to server and listen for players
      this.socket = io.connect("/#{@id}")
      this.socket.emit 'players: player joining', {name: name}
      console.log 'sending JOINING'

      this.socket.on 'players: list updated', (players) =>
        this.players = players
        this.drawPlayerList()

      this.socket.on 'minigame: load', this.minigameLoad

      this.socket.on 'minigame: start', =>
        setTimeout this.currentMinigame.start, 5000
        console.log "Starting #{this.currentMinigame.constructor.NAME} in 5 seconds!"

  drawPlayerList: =>
    console.log(this.players)
    this.el.html(_.template(App.Metagame.Default.Templates.main_view, {players: this.players}))

  minigameLoad: (data) =>
    #display loading.gif
    console.log(data)
    if this.minigames[data.minigame.name]
      this.currentMinigame = new this.minigames[data.minigame.name]
      this.el.find("#instructions").html(this.currentMinigame.constructor.INSTRUCTIONS)
      this.playerReady()
    else
      $.getScript(data.minigame.src).done (script, textStatus) =>
        #remove loading.gif
        this.currentMinigame = new this.minigames[data.minigame.name]
        this.el.find("#instructions").html(this.currentMinigame.constructor.INSTRUCTIONS)
        this.playerReady()

  addMinigame: (minigame) ->
    this.minigames[minigame.NAME] = minigame

  playerReady: ->
    this.ready = true
    this.socket.emit 'metagame: player ready'
      
  gameover: (minigame) ->
    this.socket.emit 'minigame: gameover',
      score: minigame.score
