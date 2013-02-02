socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  socket.emit "new player", { name: form.elements["username"].value }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      console.log "Connecting to #{data.metagame_id}"
      socket = io.connect("/#{data.metagame_id}")
  false
