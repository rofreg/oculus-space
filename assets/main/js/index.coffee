window.App =
  room: null,
  data: {},
  useRift: true
  
socket = io.connect('/')

socket.on "disconnect", (data) ->
  $('#disconnected').fadeIn(500)
  setTimeout "location.href = '/'", 4500

socket.on 'connect', () ->
  # immediately go create a room
  socket.emit 'init: add client'
  console.log "Establishing room..." 

socket.on "init: connected to room", (data) ->
  console.log "Connected to room: #{data.room}"
  App.room = data.room
  $('#room').text(App.room);

socket.on "room: data", (data) ->
  $('#hud .controller .disconnected').fadeOut(250);
  $('#hud .controller .connected').fadeIn(250);
  App.data = data
  for key, value of data
    # console.log("#{key} = #{value}")
    if typeof value == "number"
      $("##{key}").text(value.toFixed(2))
    else
      $("##{key}").text(value)
  # $('#data').html("x: #{data.controllerX.toFixed(2)}<br>x: #{data.controllerY.toFixed(2)}<br>z: #{data.controllerZ.toFixed(2)}")

socket.on "server: controller disconnected", (data) ->
  $('#hud .controller .disconnected').fadeIn(250);
  $('#hud .controller .connected').fadeOut(250);

document.addEventListener 'keydown', (event) ->
  if event.keyCode == 68
    $('.debug').toggle()