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
      this.el = $("<div>").addClass('active view').attr("id","metagame").hide()
      this.el.html _.template(App.Metagame.Default.Templates.main_view)
      $('body').append(this.el)
      $('.active.view').removeClass('active').fadeOut()
      this.el.fadeIn()

      # connect to server and listen for players
      this.socket = io.connect("/#{@id}")

      # join the list of players
      this.socket.emit 'players: player joining', {name: name}

      # update the list of players/scores
      this.socket.on 'players: list updated', (players) =>
        this.players = players
        this.updateWaitingRoom()
        this.updateInstructions()
        this.updateScoreboard()
        this.currentMinigame.playersUpdated() if this.currentMinigame?

      # metagame
      this.socket.on 'metagame: start', this.metagameStart

      # minigames
      this.socket.on 'minigame: load', this.minigameLoad
      this.socket.on 'minigame: start', =>
        this.minigameCountdown()

      this.socket.on 'broadcast', this.receiveBroadcast

  updateWaitingRoom: =>
    # render the metagame window
    this.el.find('#waiting_room').html(
      _.template(App.Metagame.Default.Templates.waiting_room,
      {players: this.players})
    )

    # start metagame by clicking "start"
    this.el.find('#waiting_room button').click =>
      if this.players.length < 1
        alert("You need at least two people to play!")
      else
        this.socket.emit 'metagame: start'

  metagameStart: =>
    this.el.find('#intro').html(
      _.template(App.Metagame.Default.Templates.intro,
      {players: this.players})
    )
    this.el.find('#waiting_room').slideUp(500)
    setTimeout((=> this.el.find('#intro').slideUp(1000)), 1500)
    
  updateInstructions: =>
    # render the instructions screen
    if this.currentMinigame
      this.el.find('#pregame').html(_.template(App.Metagame.Default.Templates.pregame, {
        name: this.currentMinigame.constructor.NAME,
        instructions: this.currentMinigame.constructor.INSTRUCTIONS,
        players: this.players
      }))
      this.el.find('#pregame button').click => this.playerReady()

  updateScoreboard: =>
    # render the scoreboard screen
    this.el.find('#scoreboard').html(
      _.template(App.Metagame.Default.Templates.scoreboard,
      {players: this.players})
    )

  minigameCountdown: =>
    console.log "Starting #{this.currentMinigame.constructor.NAME} in 2 seconds!"
    this.el.find('#countdown').html(_.template(App.Metagame.Default.Templates.countdown),{}).show()
    setTimeout (=> this.el.find('#countdown span').text("1")), 1000
    setTimeout (=> this.el.find('#countdown span').text("0")), 2000
    setTimeout (=> this.el.fadeOut()), 2000
    setTimeout this.currentMinigame.start, 2500

  minigameLoad: (data) =>
    console.log("LOADING MINIGAME: #{data.minigame.name}")
    this.el.find('#instructions').show()
    if this.minigames[data.minigame.name]
      this.currentMinigame = new this.minigames[data.minigame.name]
      this.currentMinigame.init()
      this.updateInstructions()
    else
      $.getScript(data.minigame.src).done (script, textStatus) =>
        this.currentMinigame = new this.minigames[data.minigame.name]
        this.currentMinigame.init()
        this.updateInstructions()

  minigameShowInstructions: =>
    this.updateInstructions()

  addMinigame: (minigame) =>
    this.minigames[minigame.NAME] = minigame

  playerReady: =>
    this.ready = true
    this.socket.emit 'metagame: player ready'
      
  gameover: (minigame) ->
    this.socket.emit 'minigame: gameover',
      score: minigame.score

  sendBroadcast: (event, data) ->
    this.socket.emit 'broadcast',
      _event: event
      _data: data

  receiveBroadcast: (data) =>
    if this.currentMinigame?
      this.currentMinigame.receiveBroadcast data._event, data._data, data._player_id
