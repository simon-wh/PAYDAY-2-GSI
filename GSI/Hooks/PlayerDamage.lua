PlayerDamage._orig = PlayerDamage._orig or {}

PlayerDamage._orig.update_downed = PlayerDamage._orig.update_downed or PlayerDamage.update_downed

function PlayerDamage:update_downed(t, dt)
	local ret = self._orig.update_downed(self, t, dt)
	if self._downed_timer then
	    local id = managers.network:session():local_peer():id()
	    local timer = math.round(self._downed_timer)
	    GSI.managers.Communicator:SetVariable("players/" .. id, "down_time", timer)
	end
	return ret
end
