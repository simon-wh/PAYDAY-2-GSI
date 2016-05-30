HUDManager._orig = HUDManager._orig or {}

HUDManager._orig.set_teammate_health = HUDManager._orig.set_teammate_health or HUDManager.set_teammate_health

function HUDManager:set_teammate_health(i, data)
    self._orig.set_teammate_health(self, i, data)
	local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/health", "current", data.current)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/health", "revives", data.revives)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/health", "total", data.total)
    end
end

HUDManager._orig.set_teammate_armor = HUDManager._orig.set_teammate_armor or HUDManager.set_teammate_armor

function HUDManager:set_teammate_armor(i, data)
    self._orig.set_teammate_armor(self, i, data)
	local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/armor", "current", data.current)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/armor", "max", data.max)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/armor", "total", data.total)
    end
end

HUDManager._orig.set_teammate_condition = HUDManager._orig.set_teammate_condition or HUDManager.set_teammate_condition

function HUDManager:set_teammate_condition(i, icon_data, text)
	self._orig.set_teammate_condition(self, i, icon_data, text)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id

    if panel._main_player and peer_id and icon_data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id, "is_swansong", icon_data == "mugshot_swansong")
    end
end

HUDManager._orig.set_teammate_ammo_amount = HUDManager._orig.set_teammate_ammo_amount or HUDManager.set_teammate_ammo_amount

function HUDManager:set_teammate_ammo_amount(id, selection_index, max_clip, current_clip, current_left, max)
	self._orig.set_teammate_ammo_amount(self, id, selection_index, max_clip, current_clip, current_left, max)
    local type = selection_index == 1 and "secondary" or "primary"
    local panel = self._teammate_panels[id]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/weapons/" .. type, "max_clip", max_clip)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/weapons/" .. type, "current_clip", current_clip)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/weapons/" .. type, "current_left", current_left)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/weapons/" .. type, "max", max)
    end
end

HUDManager._orig._set_teammate_weapon_selected = HUDManager._orig._set_teammate_weapon_selected or HUDManager._set_teammate_weapon_selected

function HUDManager:_set_teammate_weapon_selected(i, id, icon)
	self._orig._set_teammate_weapon_selected(self, i, id, icon)
    local type = id == 1 and "secondary" or "primary"
    local not_type = id == 1 and "primary" or "secondary"
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/weapons/" .. type, "is_selected", true)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/weapons/" .. not_type, "is_selected", false)
    end
end

HUDManager._orig.set_teammate_grenades = HUDManager._orig.set_teammate_grenades or HUDManager.set_teammate_grenades

function HUDManager:set_teammate_grenades(i, data)
    self._orig.set_teammate_grenades(self, i, data)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/grenades", "type", "equipment")
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/grenades", "count", data.amount)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/grenades", "id", data.icon)
    end
end

HUDManager._orig.set_teammate_grenades_amount = HUDManager._orig.set_teammate_grenades_amount or HUDManager.set_teammate_grenades_amount

function HUDManager:set_teammate_grenades_amount(i, data)
	self._orig.set_teammate_grenades_amount(self, i, data)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/grenades", "count", data.amount)
    end
end

HUDManager._orig.set_deployable_equipment = HUDManager._orig.set_deployable_equipment or HUDManager.set_deployable_equipment

function HUDManager:set_deployable_equipment(i, data)
    self._orig.set_deployable_equipment(self, i, data)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/deployable", "type", "equipment")
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/deployable", "count", data.amount)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/deployable", "id", data.icon)
    end
end

HUDManager._orig.set_teammate_deployable_equipment_amount = HUDManager._orig.set_teammate_deployable_equipment_amount or HUDManager.set_teammate_deployable_equipment_amount

function HUDManager:set_teammate_deployable_equipment_amount(i, index, data)
	self._orig.set_teammate_deployable_equipment_amount(self, i, index, data)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/deployable", "count", data.amount)
    end
end

HUDManager._orig.set_cable_tie = HUDManager._orig.set_cable_tie or HUDManager.set_cable_tie

function HUDManager:set_cable_tie(i, data)
    self._orig.set_cable_tie(self, i, data)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and data then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/cable_ties", "type", "equipment")
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/cable_ties", "count", data.amount)
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/cable_ties", "id", data.icon)
    end
end

HUDManager._orig.set_cable_ties_amount = HUDManager._orig.set_cable_ties_amount or HUDManager.set_cable_ties_amount

function HUDManager:set_cable_ties_amount(i, amount)
	self._orig.set_cable_ties_amount(self, i, amount)
    local panel = self._teammate_panels[i]
    local peer_id = panel._main_player and managers.network:session():local_peer():id() or panel._peer_id
    if not panel._ai and peer_id and amount then
        GSI.managers.Communicator:SetVariable("players/" .. peer_id .. "/items/cable_ties", "count", amount)
    end
end

HUDManager._orig.set_suspicion = HUDManager._orig.set_suspicion or HUDManager.set_suspicion

function HUDManager:set_suspicion(status)
	self._orig.set_suspicion(self, status)
    if managers.network:session() then
        local peer_id = managers.network:session():local_peer():id()
        if peer_id and status ~= nil then
            local amount = type(status) == "boolean" and (status and 1 or 0) or status
            
            GSI.managers.Communicator:SetVariable("players/" .. peer_id, "suspicion", amount)
        end
    end
end
