console.log 'something'
App.Templates or= {}
App.Templates.TapRace =
  main_view: '''
    <div id='minigame' style='width:100%; height:100%;'>
      <h1>Tap Race</h1>
      <br>
      <br>
      <h2 class='score'>
        0
      </h2>
      <br>
      <a class='btn' href='#'>Run!</a>
      <div id='tap-race-players'>
      </div>
    </div>
  '''
  players_view: '''
    <table> 
      <tr>
        <% _.each(players, function(player){ %>
          <td><strong><%= player.name %></strong><br><%= player.score %> points</td>
        <% }) %>
      </tr>
    </table>
  '''
