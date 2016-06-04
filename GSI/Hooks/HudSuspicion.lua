HUDSuspicion._orig = {}

HUDSuspicion._orig.hide = HUDSuspicion.hide

function HUDSuspicion:hide()
    self._orig.hide(self)
    GSI.managers.Communicator:SetVariable("players/" .. peer_id, "suspicion", 0)
end
