socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  App.player = new App.Player this.elements["username"].value
  App.players.push App.player
  socket.emit "new player", { player: App.player }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      App.currentMetagame = new App.Metagame
      App.currentMetagame.clientInit(io)
      console.log "Connecting to #{data.metagame_id}"
      # socket.disconnect()
  $("button").attr('disabled', 'disabled')
  false
