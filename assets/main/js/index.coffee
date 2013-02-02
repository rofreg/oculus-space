socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  player = new App.Player this.elements["username"].value
  App.players.push player
  socket.emit "new player", { name: player.name }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      #App.metagame = data.metagame
      #socket.disconnect()
      App.metagame = new App.Metagame
      App.metagame.clientInit(io)
      console.log "Connecting to #{data.metagame_id}"
  false
