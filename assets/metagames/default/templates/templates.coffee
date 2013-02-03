App.Metagame.Default = {}
App.Metagame.Default.Templates = {
  main_view: '''
    <div id="waiting_room"></div>
    <div id="intro"></div>
    <div id="pregame"></div>
    <div id="scoreboard"></div>
    <div id="countdown"></div>
  '''

  waiting_room: '''
    <h1><%= players.length %> player<%= players.length > 1 ? "s" : "" %> in your party</h1>
    <ul>
      <% _.each(players, function(player){ %>
        <li><%= player.name %></li>
      <% }) %>
    </ul>
    waiting for more players...<br>
    <button>Start!</button>
  '''

  intro: '''
    <h1>Let's get started!</h1>
    Here are the players:
    <ul>
      <% _.each(players, function(player){ %>
        <li><strong><%= player.name %></strong></li>
      <% }) %>
    </ul>
    Get ready for your first game!
  '''

  pregame: '''
    <h1>Instructions for <%= name %></h1>
    <div>
      <%= instructions %>
    </div>
    <ul>
      <% _.each(players, function(player){ %>
        <li>
          <% if (player.ready) { %>
            <strong><%= player.name %> is ready!</strong>
          <% } else { %>
            Waiting for <%= player.name %>...
          <% } %>
        </li>
      <% }) %>
    </ul>
    <button>I'm ready!</button>
  '''

  countdown: '''
    Game starting in <span>3</span>...
  '''

  scoreboard: '''
    <h1>Scoreboard</h1>
    <ul>
      <% _.each(players, function(player){ %>
        <li><%= player.name %>: <%= player.score %> points</li>
      <% }) %>
    </ul>
    waiting for more players...<br>
    <button>Start!</button>
  '''
}
