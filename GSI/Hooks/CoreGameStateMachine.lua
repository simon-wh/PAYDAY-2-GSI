if CoreGameStateMachine then
    GameStateMachine = CoreGameStateMachine.GameStateMachine
    GameStateMachine._orig = {}

    GameStateMachine._orig._do_state_change = GameStateMachine._do_state_change

    function GameStateMachine:_do_state_change()
        self._orig:_do_state_change()
        GSI.managers.Communicator:SetVariable("game", "state", self._current_state)
    end
end
