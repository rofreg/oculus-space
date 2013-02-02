module.exports = require('/assets/main/js/classes.coffee')

socket = io.connect('/')

form = document.getElementById("user-form")
form.onsubmit = ->
  socket.emit "new player", { name: form.elements["username"].value }
  socket.on "enter metagame", (data) ->
    console.log(data)
  false
