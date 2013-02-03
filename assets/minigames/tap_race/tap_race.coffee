class App.Minigames.TapRace extends App.Minigames.Default
  @NAME: 'TapRace'
  @INSTRUCTIONS: 'TapRace is a fun game. Click link, plz.'
  @TEMPLATES = "/assets/minigames/tap_race/templates.js"
  @STYLESHEET = "/assets/minigames/tap_race/styles.css"

  init: ->
    this.players = []
    for player in App.metagame.players
      new_player = jQuery.extend(true, {}, player)
      this.players.push new_player

    this.currentNumber = 1
    Array::shuffle = -> @sort -> 0.5 - Math.random()
    this.numbers = [1..16].shuffle()
    console.log this.numbers

    if !App.Templates.TapRace?
      $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
      $.getScript(this.constructor.TEMPLATES)

  start: =>
    for player in this.players
      player.currentNumber = 0

    this.el = $("<div>").attr("id":"tap-race-minigame")
    this.el.html _.template App.Templates.TapRace.main_view

    numbers = this.numbers
    tds = this.el.find("#tap-board td").each (i) ->
      $(this).text(numbers[i])

    this.render()
    $('body').append(this.el)
    that = this
    this.el.find("#tap-board td").bind "touchstart click", ->
      if parseInt($(this).text()) == that.currentNumber
        that.broadcast('player: scored', {number: that.currentNumber})
        that.currentNumber++
        $(this).text('')
        if that.currentNumber > 2#16
          that.showCongrats()

  render: ->
    this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view, {players: this.players}

  showCongrats: ->
    alert("congrats!")

  gameover: ->
    $(this.el).fadeOut()
    App.metagame.gameover(this)

  receiveBroadcast: (event, data, player_id) ->
    console.log data
    console.log player_id
    if player_id?
      for player in this.players
        if player.id == player_id
          table = this.el.find("#tap-race-players #score-table-#{player_id}")
          while data.number > player.currentNumber
            tds = table.find("td").not(".no-background")
            rand = Math.floor(Math.random() * tds.length)
            console.log rand
            console.log tds.eq(rand)
            tds.eq(Math.floor(Math.random() * tds.length)).addClass('no-background')
            player.currentNumber++
            break

App.metagame.addMinigame App.Minigames.TapRace

