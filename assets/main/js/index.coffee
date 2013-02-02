socket = io.connect('/')

form = $("#user-form")
form.submit = ->
  player = new App.Player $("input[name='username']").val
  App.players.push player
  socket.emit "new player", { name: player.name }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      console.log "Connecting to #{data.metagame_id}"
      socket = io.connect("/#{data.metagame_id}")
  false
