App.Templates or= {}
App.Templates.TapRace =
  main_view: '''
    <h1 class='score'>
      0
    </h1>
    <a class='btn' href='#'>Run!</a>
    <div id='tap-race-players'>
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
