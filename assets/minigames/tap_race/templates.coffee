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
            <td class='player-td' style='width: <%= 100 / players.length %>%;' >
              <div class='score-table-holder' id='score-table-holder-<%= player.id %>'>
                <div>
                  <table class='score-table' id='score-table-<%= player.id %>' style='background-color: <%= player.color %>;'>
                    <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                    <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                    <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                    <tr> <td></td> <td></td> <td></td> <td></td> </tr>
                  </table>
                </div>
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
    <div>
      <div class='score'><%= time %></div>
      <div class='explain'>
        seconds
      </div>
      <div class='else'>Waiting for others...</div>
    </div>
  '''
  other_done: '''
    <div>
      <div class='score'><%= time %></div>
      <div class='explain'>
        seconds
      </div>
    </div>
  '''
  final: '''
    <div>
      <div class='place'>
        <% if(spot == 1) { %>
          1st
        <% } else if(spot == 2) { %>
          2nd
        <% } else if(spot == 3) { %>
          3rd
        <% } else { %>
          <%= spot %>th
        <% } %>
      </div>
    </div>
  '''
