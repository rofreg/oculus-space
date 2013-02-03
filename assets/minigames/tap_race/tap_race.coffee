class App.Minigames.TapRace extends App.Minigames.Default
  @NAME: 'TapRace'
  @INSTRUCTIONS: 'TapRace is a fun game. Click link, plz.'
  @TEMPLATES = "/assets/minigames/tap_race/templates.js"
  @STYLESHEET = "/assets/minigames/tap_race/styles.css"

  init: ->
    this.score = 0
    this.players = []
    for player in App.metagame.players
      new_player = jQuery.extend(true, {}, player)
      new_player.score = 0
      this.players.push new_player

    $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
    $.getScript(this.constructor.TEMPLATES).done (script, textStatus) =>

      this.el = $("<div>").attr("id":"tap-race-minigame")
      this.el.html _.template App.Templates.TapRace.main_view
      this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view, {players: this.players}

  start: =>
    $('body').append(this.el)
    this.el.find(".btn").bind 'click', =>
      this.score++
      this.render()
      this.broadcast "updateScore"
    setTimeout((=> this.gameover()), 5000)

  render: ->
    $('.score').text(this.score)

  gameover: ->
    $(this.el).fadeOut()
    App.metagame.gameover(this)

  broadcast: (event, data = {}) ->
    App.metagame.sendBroadcast(event, data)
    
  receiveBroadcast: (event, data, player_id) ->
    if player_id?
      for player in this.players
        if player.id == player_id
          player.score++
          this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view, {players: this.players}
          break

App.metagame.addMinigame App.Minigames.TapRace
