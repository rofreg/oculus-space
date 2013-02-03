class App.Minigames.Default
  constructor: ->
    this.id = Math.random().toString(36).substring(2,8)  # random hex id

  init: ->
    this.players = []
    for player in App.metagame.players
      new_player = jQuery.extend(true, {}, player)
      this.players.push new_player

  playersUpdated: ->
    
  receiveBroadcast: (event, data, player_id) ->

  broadcast: (event, data = {}) ->
    App.metagame.sendBroadcast(event, data)


