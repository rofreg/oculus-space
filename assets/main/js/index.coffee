socket = io.connect('/')

form = $("#user-form")
form.submit = ->
  player = new App.Player $("input[name='username']").val
  App.players.push player
  socket.emit "new player", { name: App.player }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      App.metagame = new App.Metagame
      App.metagame.clientInit(io)
      console.log "Connecting to #{data.metagame_id}"
      # socket.disconnect()
  $("button").attr('disabled', 'disabled')
  false
