class App.Minigames.TapRace extends App.Minigames.Default
  @NAME: 'TapRace'
  @INSTRUCTIONS: 'TapRace is a fun game. Click link, plz.'
  @TEMPLATES = "/assets/minigames/tap_race/templates.js"
  @STYLESHEET = "/assets/minigames/tap_race/styles.css"

  init: ->
    this.score = 0
    #$('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
    console.log this.contructor.TEMPLATES
    $.getScript(this.constructor.TEMPLATES).done (script, textStatus) =>
      this.el = _.template(App.Templates.TapRace.main_view, {players: this.players})

  start: =>
    this.el = _.template(App.Templates.TapRace.main_view, {players: this.players})
    $(".view").html(this.el)
    this.el.find(".btn").bind 'click', =>
      this.score++
      this.render()
      App.metagame.broadcast {name: "score++"}
    setTimeout(this.gameover, 5000)

  render: =>
    $('.score').text(this.score)

  gameover: =>
    App.metagame.gameover(this)

  receiveBroadcast: (data) =>
    #if data.player_id?
    console.log data

App.metagame.addMinigame App.Minigames.TapRace
