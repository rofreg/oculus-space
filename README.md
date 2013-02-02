# Mobile Party

Mobile Party is a totally awesome JavaScript-based video game platform. Think Mario Party for mobile.

## How it works

### Matchmaking

Players enter a name and are automatically paired with other players waiting to play.

### Metagames

The Metagame tracks the overall "score" of a party as they play a series of Minigames. The default Metagame is just a simple scoreboard, but Metagames can be written to do all kinds of cool things!

### Minigames

Minigames include the following properties:

* **platform:** Limit this game to specific platforms. Accepted values are 'mobile', 'web', and 'all'. *(default: all)*
* **min\_players:** Minimum number of players required for this game. *(default: 2)*
* **max\_players:** Maximum number of players allowed for this game. *(default: 4)*
* **async:** Allow this game to be played regardless of any lag. *(default: false)*
* **max_lag:** Maximum allowed lag to play this game. *(default: 500)*
* **physical\_proximity\_required:** Require users to play in the same physical location. *(default: false)*

## Credits
Built by [@rofreg](http://twitter.com/rofreg), [@lizneu08](http://twitter.com/lizneu08), and [@kyletns](http://twitter.com/kyletns) for the [DowncityJS hackathon](http://downcityjs.com), February 2-3.