window.App =
  room: null,
  data: {},
  useRift: true,
  controllerConnected: false
  
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
  $('.room').text(App.room);

socket.on "room: data", (data) ->
  App.controllerConnected = true
  $('#hud .controller .disconnected, .overlay').fadeOut(250);
  $('#hud .controller .connected').fadeIn(250);
  App.data = data
  for key, value of data
    # console.log("#{key} = #{value}")
    if typeof value == "number"
      if App.recalibration and App.recalibration[key]
        App.data[key] -= App.recalibration[key]
        value -= App.recalibration[key]
      $("##{key}").text(value.toFixed(2))
    else
      $("##{key}").text(value)

socket.on "fire", (data) ->
  App.fire()

socket.on "boost", (data) ->
  clearInterval(App.speedAdjustment)
  if (data.on)
    window.App.speedAdjustment = setInterval ->
      App.speed = Math.max(1.7, App.speed)
      App.speed = Math.min(3.5, App.speed + 0.2)
    , 50
  else
    window.App.speedAdjustment = setInterval ->
      App.speed = Math.min(2.8, App.speed)
      App.speed = Math.max(1.0, App.speed - 0.2)
    , 50

socket.on "server: controller disconnected", (data) ->
  $('#hud .controller .disconnected, .overlay').fadeIn(250);
  $('#hud .controller .connected').fadeOut(250);
  App.controllerConnected = false

document.addEventListener 'keydown', (event) ->
  if event.keyCode == 68
    $('.debug').toggle()
  else if event.keyCode == 82 and App.data
    # window.App.bodyAngle = -Math.PI / 2
    # window.App.bodyVerticalAngle = 0
    App.recalibration = {
      cX: App.data.cX,
      cY: App.data.cY,
      cZ: App.data.cZ,
      viewAngle: App.viewAngle,
      bodyAngle: App.bodyAngle,
      bodyVerticalAngle: App.bodyVerticalAngle
    }
  else if event.keyCode == 87
    App.speed += 0.2
  else if event.keyCode == 83
    App.speed = Math.max(App.speed - 0.2, 0)
  else if event.keyCode == 65
    App.fire()
