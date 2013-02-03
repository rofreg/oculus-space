App.Minigames.DoubleTapRace = {}
App.Minigames.DoubleTapRace.Templates = {
  main_view: '''
    <div class="score">Distance: 0</div>
    <div class="progress"></div>
    <button type="button" class="active btn">Left!</button>
    <button type="button" class="btn">Right!</button>
  '''
  player_view: '''
    <% _.each(players, function(player){ %>
      <div class="runner-lane">
        <div class="runner" id="runner-<%= player.id %>" style="background-color: <%= player.color %>; left: <%= player.dist + 20%>px;"></div>
      </div>
    <% }) %>
  '''
}
