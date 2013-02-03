App.Metagame.Default = {}
App.Metagame.Default.Templates = {
  main_view: '''
    <h1><%= players.length %> player<%= players.length > 1 ? "s" : "" %> in your party</h1>
    <ul>
      <% _.each(players, function(player){ %>
        <li><%= player.name %>: <%= player.score %> points</li>
      <% }) %>
    </ul>
  '''
}