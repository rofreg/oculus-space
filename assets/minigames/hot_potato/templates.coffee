App.Templates or= {}
App.Templates.HotPotato =
  main_view: '''
    <div class="notice">START!</div>
    <div class="clock">10</div>
    <div class='others count_<%= players.length %>'>
      <% others = _.select(players, function(player){ return player.id != App.player_id }) %>
      <% _.each(others, function(player, index){ %>
        <% player.index = index %>
        <div class='person' data-id='<%= player.id %>'>
          <div class="head" style="background: <%= player.color %>"></div>
          <div class="body" style="background: <%= player.color %>"></div>
        </div>
      <% }) %>
    </div>
    <span class="bomb count_<%= players.length %>"></span>
    <% self = _.find(players, function(player){ return player.id == App.player_id }) %>
    <div class='person self' data-id='<%= self.id %>'>
      <div class="head" style="background: <%= self.color %>"></div>
      <div class="body" style="background: <%= self.color %>"></div>
    </div>
  '''