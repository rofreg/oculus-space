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
        <div class="runner" style="left: <%= player.dist + 20 %>px">
          <div class="runner-body" id="body-<%= player.id %>" style="background-color: <%= player.color %>;"></div>
          <div class="left-foot" id="left-<%= player.id %>" style="background-color: <%= player.color %>;"></div>
          <div class="right-foot" id="right-<%= player.id %>" style="background-color: <%= player.color %>;"></div>
        </div>
      </div>
    <% }) %>
  '''
}
