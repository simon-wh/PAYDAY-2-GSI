GroupAIManager._orig = GroupAIManager._orig or {}

GSI.temp_storage = GSI.temp_storage or {}

function GSI:UpdateMapState()
	local state_string = "loud"
	if GSI.temp_storage._whisper then
		state_string = "stealth"
	elseif GSI.temp_storage._phalanx then
		state_string = "winters"
	elseif GSI.temp_storage._assault then
		state_string = "assault"
	elseif GSI.temp_storage._point_of_no_return then
		state_string = "point_of_no_return"
	end

	GSI.managers.Communicator:SetVariable("level", "phase", state_string)

end
