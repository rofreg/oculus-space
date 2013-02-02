module.exports = require('/assets/main/js/classes.coffee')

socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  player = new Player(form.elements["username"].value)
  App.players.push player
  socket.emit "new player", { name: player.name }
  socket.on "enter metagame", (data) ->
    console.log(data)
  false
