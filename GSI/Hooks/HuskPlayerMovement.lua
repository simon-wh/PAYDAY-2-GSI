HuskPlayerMovement._orig = HuskPlayerMovement._orig or {}

HuskPlayerMovement._orig.sync_movement_state = HuskPlayerMovement._orig.sync_movement_state or HuskPlayerMovement.sync_movement_state

function HuskPlayerMovement:sync_movement_state(state, down_time)
    self._orig.sync_movement_state(self, state, down_time)
    local id = self._unit:base():PeerID()
    GSI.managers.Communicator:SetVariable("players/" .. id, "state", state)
    if down_time then
        local timer = BeardLib.Utils.Math:Round(down_time, 2)
        GSI.managers.Communicator:SetVariable("players/" .. id, "down_time", timer)
    else
        GSI.managers.Communicator:SetVariable("players/" .. id, "down_time", nil)
    end
end
