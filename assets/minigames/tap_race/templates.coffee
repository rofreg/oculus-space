App.Templates or= {}
App.Templates.TapRace =
  main_view: '''
    <table id='tap-board'>
      <tr> <td></td> <td></td> <td></td> <td></td> </tr>
      <tr> <td></td> <td></td> <td></td> <td></td> </tr>
      <tr> <td></td> <td></td> <td></td> <td></td> </tr>
      <tr> <td></td> <td></td> <td></td> <td></td> </tr>
    </table>
    <div id='tap-race-players'>
    </div>
  '''
  players_view: '''
    <table class='player-table'> 
      <tr>
        <% _.each(players, function(player){ %>
          <td>
            <table class='score-table' id='score-table-<%= player.id %>' style='background-color: <%= player.color %>;'>
              <tr> <td></td> <td></td> <td></td> <td></td> </tr>
              <tr> <td></td> <td></td> <td></td> <td></td> </tr>
              <tr> <td></td> <td></td> <td></td> <td></td> </tr>
              <tr> <td></td> <td></td> <td></td> <td></td> </tr>
            </table><br>
            <strong><%= player.name %></strong>
          </td>
        <% }) %>
      </tr>
    </table>
  '''
