HuskPlayerBase._orig = {}

HuskPlayerBase._orig.post_init = HuskPlayerBase.post_init

function HuskPlayerBase:post_init()
    self._orig.post_init(self)
    local id = self:PeerID()
    GSI.managers.Communicator:SetVariable("players/" .. id, "name", self:nick_name())
    GSI.managers.Communicator:SetVariable("players/" .. id, "steamid", self:SteamID())
    GSI.managers.Communicator:SetVariable("players/" .. id, "is_local", false)
    GSI.managers.Communicator:SetVariable("players/" .. id, "character", managers.criminals:character_name_by_peer_id(id))
end

function HuskPlayerBase:PeerID()
    local peer = managers.network:session():peer_by_unit(self._unit)
    return peer and peer:id() or -1
end

function HuskPlayerBase:SteamID()
    local peer = managers.network:session():peer_by_unit(self._unit)
    return peer and peer:user_id() or -1
end

--[[HuskPlayerBase._orig.pre_destroy = HuskPlayerBase.pre_destroy

function HuskPlayerBase:pre_destroy(unit)
    self._orig.pre_destroy(self, unit)
    GSI.managers.Communicator:RemoveSubTable("players/" .. self:PeerID())
end]]--
