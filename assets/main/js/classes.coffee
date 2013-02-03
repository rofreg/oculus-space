App =
  metagames: {}
  players: []
  minigames: {}
  Metagames: {}

#require Default.Parent, Default.Server, and Default.Client
App.Metagames.Default = require('./assets/metagames/default/default.coffee')

class App.Player
  constructor: (@name) ->
    this.id = Math.random().toString(36).substring(2,6)  # random hex id

App.Utilities =
  checkOrientation: ->
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) and $(window).width() > $(window).height()
      alert('To play Mobile Party, you should use portrait orientation on your phone. (You may want to lock your phone in this orientation!)')
    
if module?
  module.exports = App
else
  window.App = App
