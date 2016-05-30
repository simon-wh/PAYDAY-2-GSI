PlayerManager._orig = PlayerManager._orig or {}

PlayerManager._orig.set_player_state = PlayerManager._orig.set_player_state or PlayerManager.set_player_state

function PlayerManager:set_player_state(state)
    self._orig.set_player_state(self, state)
    local id = managers.network:session():local_peer():id()
    GSI.managers.Communicator:SetVariable("players/" .. id, "state", self._current_state)

end
