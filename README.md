# Oculus Space

Oculus Space is a WebGL demo using both the Oculus Rift (optional, with oculus-bridge installed) and a smartphone as a gyroscopic motion controller. It was created in 24 hours for #HackThat in Providence, RI.

## How it works

Go to http://oculus-space.herokuapp.com to see it in action. You'll need a WebGL-capable browser (try Chrome), plus an iPhone to control your spaceship by tilting left, right, forwards, and backwards. (I hope to add Android support soon, but didn't have an Android device to test on during initial development.)

## How to run for development

* sudo npm install -g supervisor
* sudo npm install -g coffee-script
* sudo supervisor app.coffee
* coffee -c -w assets/

## Credits
Built by [@rofreg](http://twitter.com/rofreg) for the [HackThat hackathon](http://hack-that.com), November 2013.
Music is "Spacefighter" by cerror.
Ship texture by [FrostBo](http://frostbo.deviantart.com/art/Hull-Textures-pack-1-for-spaceship-286898019).
Code is heavily based on the OculusBridge [first-person example](http://instrument.github.io/oculus-bridge/examples/first_person.html).
You'll need the [oculus-bridge](https://github.com/Instrument/oculus-bridge) executable installed to enable Oculus Rift support.

## License

Oculus Space is released under a dual license. You may choose either the GPL or MIT license, depending on the project you are using it in and how you wish to use it. Have fun!
