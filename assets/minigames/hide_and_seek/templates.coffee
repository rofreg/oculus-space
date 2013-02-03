App.Templates or= {}
App.Templates.HideAndSeek =
  main: '''
    <div id='HAS-minigame'>
    </div>
  '''
  grid: '''
    <div class='notif'></div>
    <table id='HAS-grid'>
      <% forest_index = 0 %>
      <% for(var x = 0; x <= 3; x++) { %>
        <tr>
          <% for(var y = 0; y <= 3; y++) { %>
            <td id='HAS-cell-<%= x %>-<%= y %>' 
                class='HAS-cell HAS-row-<%= x %> HAS-col-<%= y %>'
                data-y=<%= y %>
                data-x=<%= x %>
            >
                <% if(grid[x][y].inspected) { %>
                  <% if (grid[x][y].players.length) { %>
                    <img src="<%= forests[forest_index] %>" />
                  <% } else { %>
                    <img src="<%= memes[x * 4 + y] %>" />
                  <% } %>
                <% } else if (!player.seeker) { %>
                  <% if (grid[x][y].players.length) { %>
                    <div class='color-fill' style="background: <%= grid[x][y].players[0].color %>;"></div>
                  <% } else { %>
                    ?
                  <% } %>
                <% } else { %>
                    ?
                <% } %>

                <% if (grid[x][y].players.length) { %>
                  <% forest_index++ %>
                <% } %>
            </td>
          <% } %>
        </tr>
      <% } %>
    </table>
  '''
  seekerIntro: '''
    <div class='HAS-intro'>
      <div class='title'>You're it! </div>
      <div class='explain'>Waiting for everyone else to hide...</div>
      <a href='#' class='confirm' style='display:none;'>Let's do it!</a>
    </div>
  '''
  hiderIntro: '''
    <div class='HAS-intro'>
      <div class='title'>Time to hide! </div>
      <div class='explain'>Click a cell on the next screen to hide in.</div>
      <a href='#' class='confirm'>Sounds Good</a>
    </div>
  '''

