class App.Minigames.Default
  constructor: ->
    this.id = Math.random().toString(36).substring(2,8)  # random hex id

  playersUpdated: ->
    
  receiveBroadcast: (event, data, player_id) ->

  broadcast: (event, data = {}) ->
    App.metagame.sendBroadcast(event, data)


