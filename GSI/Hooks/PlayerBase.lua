PlayerBase._orig = PlayerBase._orig or {}

PlayerBase._orig.post_init = PlayerBase._orig.post_init or PlayerBase.post_init

function PlayerBase:post_init()
    self._orig.post_init(self)
    local id = self:PeerID()
    GSI.managers.Communicator:SetVariable("players/" .. id, "name", self:nick_name())
    GSI.managers.Communicator:SetVariable("players/" .. id, "steamid", self:SteamID())
    GSI.managers.Communicator:SetVariable("players/" .. id, "is_local", true)
    GSI.managers.Communicator:SetVariable("players/" .. id, "character", managers.network:session():local_peer():character())
    GSI.managers.Communicator:SetVariable("players/" .. id, "rank", managers.experience:current_rank())
    GSI.managers.Communicator:SetVariable("players/" .. id, "level", managers.experience:current_level())
end

function PlayerBase:PeerID()
    return managers.network:session():local_peer():id()
end

function PlayerBase:SteamID()
    return managers.network:session():local_peer():user_id()
end

--[[PlayerBase._orig.pre_destroy = PlayerBase.pre_destroy

function PlayerBase:pre_destroy(unit)
    self._orig.pre_destroy(self, unit)

end]]--
