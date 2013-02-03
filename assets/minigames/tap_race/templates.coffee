App.Templates or= {}
App.Templates.TapRace =
  main_view: '''
    <div class='top-half'>
      <table id='tap-board'>
        <tr> <td></td> <td></td> <td></td> <td></td> </tr>
        <tr> <td></td> <td></td> <td></td> <td></td> </tr>
        <tr> <td></td> <td></td> <td></td> <td></td> </tr>
        <tr> <td></td> <td></td> <td></td> <td></td> </tr>
      </table>
    </div>
    <div id='tap-race-players'>
    </div>
  '''
  players_view: '''
    <table class='player-table'> 
      <tr>
        <% _.each(players, function(player) { %>
          <% if(player.id != currentPlayerId) { %>
            <td class='player-td'>
              <div class='score-table-holder' id='score-table-holder-<%= player.id %>'>
                <table class='score-table' id='score-table-<%= player.id %>' style='background-color: <%= player.color %>;'>
                  <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                  <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                  <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                  <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                </table>
              </div>
              <span class='player-name'>
                <%= player.name %>
              </span>
            </td>
          <% } %>
        <% }) %>
      </tr>
    </table>
  '''
  done: '''
    <div class='score'><%= time %></div>
    <div class='explain'>
      seconds
    </div>
    <div class='else'>Waiting for others...</div>
  '''
  other_done: '''
    <div class='score'><%= time %></div>
    <div class='explain'>
      seconds
    </div>
  '''

