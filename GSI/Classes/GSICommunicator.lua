GSICommunicator = GSICommunicator or class()

GSICommunicator.MessageInterval = 30
GSICommunicator.QueuedMessageInterval = 0.1
GSICommunicator.Timeout = 60

GSICommunicator.ProviderDetails = {
    name = "PAYDAY 2",
    appid = 218620,
    version = Application:version(),
    steamid = Steam:userid(),
    timestamp = 0,
    local_peer_id = 0
}

GSICommunicator.StoredDetails = {
    level = {
        phase = "undefined"
    },
    previous = {}
}

function GSICommunicator:init()
    Http:set_timeout(20)
end

GSICommunicator._queued_message = false
function GSICommunicator:QueueMessage()
    if not self._queued_message then
        self._last_message_tick = t
        self._queued_message = true
    end
end

GSICommunicator._tick = 0
GSICommunicator._last_message_tick = 0
function GSICommunicator:update(t, dt)
    self._tick = t
    if #GSI.Intergrations == 0 then
        return
    end

    if self._queued_message and t - self._last_message_tick > self.QueuedMessageInterval then
        self._last_message_tick = t
        self:SendMessage(t)
        self._queued_message = false
        return
    end

    if t - self._last_message_tick > self.MessageInterval then
        self._last_message_tick = t
        self:SendMessage(t)
    end
end

function GSICommunicator:SendMessage()
    local message_data = {
        provider = table.merge(self.ProviderDetails, {timestamp = self._tick, local_peer_id = managers.network:session() and managers.network:session():local_peer():id() or -1})
    }
    table.merge(message_data, self.StoredDetails)

    local encoded = json.custom_encode(message_data)
    --log(tostring(encoded))
    for _, inter in pairs(GSI.Intergrations) do
        if not inter.unreach_t or self._tick - inter.unreach_t >= self.Timeout then
            --dohttpreq(inter.uri .. "/" .. BeardLib.Utils.UrlEncode(encoded))
            Http:get(function(success, data)
                if not success then
                    inter.unreachable = true
                    inter.unreach_t = self._tick
                else
                    inter.unreachable = false
                end
            end,
            inter.uri, "/", {}, tostring(encoded))
        end
    end

    self.StoredDetails.previous = {}
end

function GSICommunicator:RemoveSubTable(group, tbl)
    tbl = tbl or self.StoredDetails

    if string.find(group, "/") then
        local sub_tbl = tbl
        local split = string.split(group, "/")
        local final_split = table.remove(split)
        for _, split_part in pairs(split) do
            if sub_tbl[split_part] then
                sub_tbl = sub_tbl[split_part]
            else
                return
            end
        end
        sub_tbl[final_split] = nil
    else
        tbl[group] = nil
    end

    if tbl == self.StoredDetails then
        self:RemoveSubTable(group, self.StoredDetails.previous)
    end
end

function GSICommunicator:GetSubTable(tbl, group)
    if not tbl then return {} end
    if string.find(group, "/") then
        local sub_tbl = tbl
        local split = string.split(group, "/")
        for _, split_part in pairs(split) do
            sub_tbl[split_part] = sub_tbl[split_part] or {}
            sub_tbl = sub_tbl[split_part]
        end
        return sub_tbl
    else
        tbl[group] = tbl[group] or {}
        return tbl[group]
    end
end

function GSICommunicator:SetVariable(group, param, value)
    local tbl = self:GetSubTable(self.StoredDetails, group)
    local prev_tbl = self:GetSubTable(self.StoredDetails.previous, group)
    local diff = false

    if tbl[param] ~= value then
        prev_tbl[param] = tbl[param]
        diff = true
    end

    tbl[param] = value

    if diff then
        --log(tostring(group) .. "|" .. tostring(param) .. "|" .. tostring(value))
        self:QueueMessage()
    end
end
