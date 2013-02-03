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
                <img src="http://cdn1.iconfinder.com/data/icons/32-soft-media-icons--Vol-2/33/user.png">
              </div>
              <%= player.name %>
            <% } %>
          </li>
        <% } %>
      <% }) %>
    </ul>
    Ready to start playing?<br>
    <button>Let&rsquo;s go!</button>
  '''

  intro: '''
    <h1>Let's get started!</h1>
    Here are the players:
    <ul>
      <% _.each(players, function(player){ %>
        <li>
          <strong><%= player.name %></strong>
        </li>
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
  '''
}
