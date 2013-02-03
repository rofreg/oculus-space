App.Metagame.Default = {}
App.Metagame.Default.Templates = {
  main_view: '''
    <div id="waiting_room"></div>
    <div id="intro"></div>
    <div id="pregame"></div>
    <div id="scoreboard"></div>
    <div id="next_game"></div>
    <div id="countdown"></div>
  '''

  waiting_room: '''
    <h1>Waiting for more players...</h1>
    <h4>
      <% if (players.length == 1) { %>
        You&rsquo;re all alone right now! :(
      <% } else if (players.length == 2) { %>
        Hooray, a friend has joined you!
      <% } else if (players.length == 3) { %>
        You&rsquo;ve got two friends to play with!
      <% } else if (players.length == 4) { %>
        Sweet, three other players! This should be fun.
      <% } else if (players.length == 5) { %>
        SO MANY PEOPLE. I&rsquo;M FEELING OVERWHELMED.
      <% } else if (players.length == 6) { %>
        Look at all these people! It&rsquo;s like the Brady Bunch in here.
      <% } else if (players.length > 6) { %>
        Y&rsquo;all ready to PARTY?!?!?
      <% } %>
    </h4>
    <ul class="player_blocks">
      <% _.each(players, function(player, index){ %>
        <% if (index <= 4 || players.length <= 5) { %>
          <li>
            <% if (index == 4 && players.length > 5) { %>
              <br><br>
              + <%= (players.length - 4) %> others
            <% } else { %>
              <div class="color" style="background: <%= player.color%>">
                <img src="http://cdn1.iconfinder.com/data/icons/gnome-desktop-icons-png/PNG/64/Gnome-Stock-Person-64.png">
              </div>
              <%= player.name %>
            <% } %>
          </li>
        <% } %>
      <% }) %>
    </ul>
    <div style="font-size: 24px">
      Ready to start playing?
    </div>
    <button>Let&rsquo;s go!</button>
  '''

  intro: '''
    <h1>Let's get started!</h1>
    <h4>Loading your first game...</h4>
    <img src="/assets/metagames/default/images/ajax.gif" style="margin: 40px 0 90px">
    <div class="next_game" style="display: none"></div>
  '''

  pregame: '''
    <h1><%= name %></h1>
    <div class="instructions">
      <h4>Instructions</h4>
      <%= instructions %>
    </div>
    <div style="font-size: 24px">
      Waiting for players...
    </div>
    <div class="ready-for-minigame">
      <% _.each(players, function(player){ %>
        <div class="player <%= player.ready ? "ready" : "" %>" style="background: <%= player.color %>">
          <%= player.ready ? "&#10003;" : "&times;" %>
        </div>
      <% }) %>
    </div>
    <% if (ready){ %>
      <button disabled='disabled'>Waiting...</button>
    <% } else { %>
      <button>I'm ready!</button>
    <% } %>
  '''

  countdown: '''
    Game starting in <span>3</span>...
  '''

  next_game_headers: ["Another game, coming up!","The battle rages on!","Ready for more?"]

  next_game: '''
    <h1><%= App.Metagame.Default.Templates.next_game_headers[Math.floor(Math.random()*App.Metagame.Default.Templates.next_game_headers.length)] %></h1>
    <h4>Loading your next game...</h4>
    <img src="/assets/metagames/default/images/ajax.gif" style="margin: 40px 0 90px">
    <div class="next_game">
      <%= currentMinigame ? currentMinigame.constructor.NAME : "" %>
    </div>
  '''

  scoreboard: '''
    <h1>Scoreboard</h1>
    <table class="scoreboard">
      <tr>
        <th></th>
        <th class="name">Player</th>
        <th class="score">Total score</th>
        <th class="result">Result</th>
      </tr>
      <tbody>
        <% _.each(players, function(player, index){ %>
          <tr class="player_<%= index %>" data-id="<%= player.id %>">
            <td><div class="color" style="background: <%= player.color %>"></div></td>
            <td class="name"><%= player.name %></td>
            <td class="score"><span><%= player.score %></span> points</td>
            <td class="result">+ <%= player.minigame_score %></td>
          </tr>
        <% }) %>
      </tbody>
    </table>
  '''
}
