App.Minigames.DoubleTapRace = {}
App.Minigames.DoubleTapRace.Templates = {
  main_view: '''
    <div class="score">Ready</div>
    <div class="racetrack">
      <div class="progress">
        <div class="runner-lane"></div>
        <div class="runner-lane"></div>
        <div class="runner-lane"></div>
        <div class="runner-lane"></div>
      </div>
      <div class="finish"></div>
    </div>
    <div class="btn">Left!</div>
    <div class="btn">Right!</div>
  '''
  player_view: '''
    <div class="runner">
      <div class="runner-body" id="body-<%= player.id %>" style="background-color: <%= player.color %>;"></div>
      <div class="left-foot" id="left-<%= player.id %>" style="background-color: <%= player.color %>;"></div>
      <div class="right-foot" id="right-<%= player.id %>" style="background-color: <%= player.color %>;"></div>
    </div>
  '''
}
