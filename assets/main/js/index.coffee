socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  player = new Player(form.elements["username"].value)
  App.players.push player
  socket.emit "new player", { name: player.name }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      console.log "Connecting to #{data.metagame_id}"
      socket = io.connect("/#{data.metagame_id}")
  false
