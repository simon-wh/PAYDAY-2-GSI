local update_state = function(self)
    if #self._open_menus == 0 and not self._is_start_menu then
        GSI.managers.Communicator:SetVariable("game", "state", "ingame")
    elseif #self._open_menus > 0 then
        local menu = self._open_menus[#self._open_menus].name
        if menu == "mission_end_menu" then
            menu = menu .. (managers.job:stage_success() and "_success" or "_failure")
        end
        GSI.managers.Communicator:SetVariable("game", "state", menu)
    else
        GSI.managers.Communicator:SetVariable("game", "state", "none")
    end
end

Hooks:PostHook(MenuManager, "activate", "GSIGameStateMenuActivate", function(self)
    update_state(self)
end)

Hooks:PostHook(MenuManager, "deactivate", "GSIGameStateMenuDeactivate", function(self)
    update_state(self)
end)
