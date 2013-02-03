class App.Minigames.TapRace extends App.Minigames.Default
  @NAME: 'TapRace'
  @INSTRUCTIONS: 'TapRace is a fun game. Click link, plz.'
  @TEMPLATES = "/assets/minigames/tap_race/templates.js"
  @STYLESHEET = "/assets/minigames/tap_race/styles.css"

  init: ->
    super
    this.currentNumber = 1
    Array::shuffle = -> @sort -> 0.5 - Math.random()
    this.numbers = [1..16].shuffle()
    console.log this.numbers

    if !App.Templates.TapRace?
      $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
      $.getScript(this.constructor.TEMPLATES)

  start: =>
    this.startTime = new Date
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
        if that.currentNumber > 3#16
          that.done()

  render: ->
    this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view,
      players: this.players
      currentPlayerId: App.player_id

  done: ->
    #set self to done
    for player in this.players
      if player.id == App.player_id
        player.done = true

    this.endTime = new Date
    this.time = this.endTime - this.startTime
    this.broadcast('player: done', {time: this.time})
    half = this.el.find(".top-half")
    half.find("table").fadeOut 500, =>
      elem = _.template App.Templates.TapRace.done,
        time: this.time / 1000
      elem = $(elem)
      elem.hide()
      half.html elem
      elem.fadeIn 500
    #this.gameover()

  gameover: ->
    $(this.el).fadeOut()
    App.metagame.gameover(this)

  receiveBroadcast: (event, data, player_id) ->
    if player_id?
      if event == 'player: scored'
        for player in this.players
          if player.id == player_id
            table = this.el.find("#tap-race-players #score-table-#{player_id}")
            while data.number > player.currentNumber
              tds = table.find("td").not(".no-background")
              rand = Math.floor(Math.random() * tds.length)
              tds.eq(Math.floor(Math.random() * tds.length)).addClass('no-background')
              player.currentNumber++
              break
      else if event == 'player: done'
        for player in this.players
          if player.id == player_id
            player.done = true
            holder = this.el.find("#score-table-holder-#{player_id}")
            holder.find("table").fadeOut 500, =>
              elem = _.template App.Templates.TapRace.other_done,
                time: data.time / 1000
              elem = $(elem)
              elem.hide()
              holder.html elem
              elem.fadeIn 500
        if this.allPlayersDone()
          this.calculateScores()

  allPlayersDone: ->
    for player in this.players
      if !player.done
        return false
    return true
          
  calculateScores: ->
    for player in this.players
      player.score = Math.floor Math.random() * 50
    this.score = Math.floor Math.random() * 50
    this.gameover()
    

App.metagame.addMinigame App.Minigames.TapRace

