class App.Minigames.TapRace extends App.Minigames.Default
  @NAME: 'TapRace'
  @INSTRUCTIONS: 'TapRace is a fun game. Click link, plz.'
  @TEMPLATES = "/assets/minigames/tap_race/templates.js"
  @STYLESHEET = "/assets/minigames/tap_race/styles.css"

  init: ->
    this.score = 0
    this.players = App.metagame.players

    $.getScript(this.constructor.TEMPLATES).done (script, textStatus) =>

      this.el = $("<div>").addClass('active view').attr("id","metagame")
      this.el.html _.template App.Templates.TapRace.main_view
      this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view, {players: this.players}

  start: =>
    $('body').append(this.el)
    this.el.find(".btn").bind 'click', =>
      this.score++
      this.render()
      this.metagame.refreshPlayers()
    setTimeout(this.gameover, 5000)

  render: =>
    $('.score').text(this.score)

  gameover: =>
    App.metagame.gameover(this)

  receiveBroadcast: (data) =>
    if data.player_id? and data.name == 'score++'
      this.players
    console.log data

  playersUpdated: =>
    this.players = this.metagame.players
    this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view, {players: this.players}

App.metagame.addMinigame App.Minigames.TapRace
