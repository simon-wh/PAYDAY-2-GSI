GroupAIStateBesiege._orig = GroupAIStateBesiege._orig or {}

GroupAIStateBesiege._orig.set_assault_endless = GroupAIStateBesiege._orig.set_assault_endless or GroupAIStateBesiege.set_assault_endless

function GroupAIStateBesiege:set_assault_endless(enabled)
    self._orig.set_assault_endless(self, enabled)
    GSI.temp_storage._phalanx = enabled
    GSI:UpdateMapState()
end
