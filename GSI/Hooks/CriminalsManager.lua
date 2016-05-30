function CriminalsManager:character_data_by_panel_id(panel_id)
	for id, data in pairs(self._characters) do
		if data.taken and data.data.panel_id == panel_id then
			return data
		end
	end
end

function CriminalsManager:peer_id_by_panel_id(panel_id)
    local data = self:character_data_by_panel_id(panel_id)
    return data and data.peer_id or nil
end
