window.App.init = ->
  window.App.viewAngle     = -5 / Math.PI
  window.App.time          = Date.now()
  window.App.bodyAngle     = 0
  window.App.bodyAxis      = new THREE.Vector3(0, 1, 0)
  window.App.bodyPosition  = new THREE.Vector3(100, 15, 100)
  window.App.velocity      = new THREE.Vector3()

  App.initScene()
  App.initGeometry()
  App.initLights()
  
  oculusBridge = new OculusBridge({
    "debug" : true,
    "onOrientationUpdate" : (quatValues) ->
      # set debug display info
      for key, value of quatValues
        $("#o#{key.toUpperCase()}").text(value.toFixed(2))

      # Do first-person style controls (like the Tuscany demo) using the rift and keyboard.

      # TODO: Don't instantiate new objects in here, these should be re-used to avoid garbage collection.

      # make a quaternion for the the body angle rotated about the Y axis.
      quat = new THREE.Quaternion()
      quat.setFromAxisAngle(App.bodyAxis, App.bodyAngle)

      # make a quaternion for the current orientation of the Rift
      quatCam = new THREE.Quaternion(quatValues.x, quatValues.y, quatValues.z, quatValues.w)

      # multiply the body rotation by the Rift rotation.
      quat.multiply(quatCam)

      # Make a vector pointing along the Z axis and rotate it accoring to the combined look/body angle.
      xzVector = new THREE.Vector3(0, 0, 1)
      xzVector.applyQuaternion(quat)

      # Compute the X/Z angle based on the combined look/body angle.  This will be used for FPS style movement controls
      # so you can steer with a combination of the keyboard and by moving your head.
      # window.App.viewAngle = Math.atan2(xzVector.z, xzVector.x) + Math.PI

      # Apply the combined look/body angle to the camera.
      App.camera.quaternion.copy(quat)
    "onConfigUpdate"      : (config) ->
      App.riftCam.setHMD(config)
    "onConnect"           : ->
      $('#hud .oculus .disconnected').fadeOut(250)
      $('#hud .oculus .connected').fadeIn(250)
    "onDisconnect"        : ->
      $('#hud .oculus .disconnected').fadeIn(250)
      $('#hud .oculus .connected').fadeOut(250)
  })
  oculusBridge.connect()
  window.App.riftCam = new THREE.OculusRiftEffect(App.renderer);

window.App.initScene = ->
  window.App.clock = new THREE.Clock();
  mouse = new THREE.Vector2(0, 0);

  windowHalf = new THREE.Vector2(window.innerWidth / 2, window.innerHeight / 2);
  aspectRatio = window.innerWidth / window.innerHeight;
  
  window.App.scene = new THREE.Scene();  

  window.App.camera = new THREE.PerspectiveCamera(45, aspectRatio, 1, 10000);
  App.camera.useQuaternion = true;

  App.camera.position.set(100, 15, 100);
  App.camera.lookAt(App.scene.position);

  # Initialize the renderer
  window.App.renderer = new THREE.WebGLRenderer({antialias:true})
  App.renderer.setClearColor(0x000000)
  App.renderer.setSize(window.innerWidth, window.innerHeight)

  App.scene.fog = new THREE.Fog(0x000000, 300, 700)

  element = document.getElementById('viewport')
  element.appendChild(App.renderer.domElement)

  window.App.controls = new THREE.SpaceControls(App.camera)

window.App.initLights = ->
  ambient = new THREE.AmbientLight(0x222222)
  App.scene.add(ambient)

  window.App.headlights = new THREE.PointLight( 0xffffff, 0.4, 500 )
  App.headlights.position.set( 0, 0, 0 )
  App.scene.add(App.headlights)

# var floorTexture;
window.App.initGeometry = ->
  floorTexture = new THREE.ImageUtils.loadTexture( "/assets/textures/tile.jpg" )
  floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping;
  floorTexture.repeat.set( 50, 50 )
  floorTexture.anisotropy = 32

  floorMaterial = new THREE.MeshLambertMaterial( { map: floorTexture, transparent:true, opacity:0.60 } )
  floorGeometry = new THREE.PlaneGeometry(1000, 1000, 10, 10)
  floor = new THREE.Mesh(floorGeometry, floorMaterial)
  floor.rotation.x = -Math.PI / 2

  App.scene.add(floor)

  # add some boxes.
  window.App.boxes = [];
  boxTexture = new THREE.ImageUtils.loadTexture( "/assets/textures/blue_blue.jpg" )
  for i in [0..200]
    material = new THREE.MeshLambertMaterial({ emissive:0x000000, map: boxTexture, color: 0xffffff})
    
    height = Math.random() * 150+10
    width = Math.random() * 20 + 2
    
    box = new THREE.Mesh( new THREE.CubeGeometry(width, height, width), material)

    box.position.set(Math.random() * 1000 - 500, height/2 ,Math.random() * 1000 - 500)
    box.rotation.set(0, Math.random() * Math.PI * 2, 0)
    
    App.boxes.push(box)
    App.scene.add(box)

  material = new THREE.MeshLambertMaterial({
    color: 0x990000
  })
  window.App.ship = new THREE.Mesh( new THREE.CubeGeometry(1, 1, 1), material)
  App.ship.rotation.set(Math.PI / 4, Math.PI / 4, Math.PI / 4)
  App.ship.position.set(0,0,0);
  App.scene.add(App.ship)
  

window.App.updateInput = (delta) ->
  step        = 25 * delta;
  turn_speed  = (2 * delta) * Math.PI / 180

  # Update ship position
  App.bodyPosition.x += Math.cos(App.bodyAngle) * step;
  App.bodyPosition.z -= Math.sin(App.bodyAngle) * step;
  if App.data.cY
    App.bodyAngle -= App.data.cY * turn_speed
  
  # update the camera position when rendering to the oculus rift.
  if App.useRift
    App.camera.position.set(App.bodyPosition.x, App.bodyPosition.y, App.bodyPosition.z)
    App.ship.position.set(
      App.bodyPosition.x + Math.cos(App.bodyAngle) * 10,
      App.bodyPosition.y,
      App.bodyPosition.z - Math.sin(App.bodyAngle) * 10);
    App.headlights.position.set(App.bodyPosition.x, App.bodyPosition.y, App.bodyPosition.z)


window.App.animate = ->
  delta = App.clock.getDelta()
  App.time += delta;
  
  App.updateInput(delta);
  App.ship.rotation.x += delta * 1.0
  App.ship.rotation.y -= delta * 1.33
  App.ship.rotation.z += delta * 0.57

  requestAnimationFrame(App.animate)
  if App.useRift
    App.riftCam.render(App.scene, App.camera)
  else
    # App.controls.update()
    App.renderer.render(App.scene, App.camera)


window.onload = ->
  App.init()
  App.animate()