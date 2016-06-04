GroupAIStateBase._orig = GroupAIStateBase._orig or {}

GroupAIStateBase._orig.set_assault_mode = GroupAIStateBase._orig.set_assault_mode or GroupAIStateBase.set_assault_mode

function GroupAIStateBase:set_assault_mode(enabled)
    self._orig.set_assault_mode(self, enabled)
    GSI.temp_storage._assault = enabled
    GSI:UpdateMapState()

end

GroupAIStateBase._orig.sync_assault_mode = GroupAIStateBase._orig.sync_assault_mode or GroupAIStateBase.sync_assault_mode

function GroupAIStateBase:sync_assault_mode(enabled)
    self._orig.sync_assault_mode(self, enabled)
    GSI.temp_storage._assault = enabled
    GSI:UpdateMapState()

end

GroupAIStateBase._orig._update_point_of_no_return = GroupAIStateBase._orig._update_point_of_no_return or GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(t, dt)
    self._orig._update_point_of_no_return(self, t, dt)
    GSI.temp_storage._point_of_no_return = self._point_of_no_return_timer > 0 and not self._is_inside_point_of_no_return
    if GSI.temp_storage._point_of_no_return then
        GSI.managers.Communicator:SetVariable("level", "no_return_timer", BeardLib.Utils.Math:Round(self._point_of_no_return_timer, 2))
    else
        GSI.managers.Communicator:SetVariable("level", "no_return_timer", nil)
    end

    GSI:UpdateMapState()
end

GroupAIStateBase._orig.set_whisper_mode = GroupAIStateBase._orig.set_whisper_mode or GroupAIStateBase.set_whisper_mode
function GroupAIStateBase:set_whisper_mode(enabled)
    self._orig.set_whisper_mode(self, enabled)
    GSI.temp_storage._whisper = enabled
    GSI:UpdateMapState()
end
