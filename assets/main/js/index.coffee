socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  socket.emit "new player", { name: form.elements["username"].value }
  socket.on "enter metagame", (data) ->
    if data.metagame_id?
      #App.metagame = data.metagame
      #socket.disconnect()
      App.metagame = new App.Metagame
      App.metagame.clientInit(io)
      console.log "Connecting to #{data.metagame_id}"
  false
