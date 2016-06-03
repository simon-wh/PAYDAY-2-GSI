if not GSI then
    _G.GSI = ModCore:new(ModPath .. "main_config.xml")
    local self = GSI

    self.IntergrationPath = "GSI"

    self.HooksDirectory = "Hooks/"
    self.ClassDirectory = "Classes/"

    self.Classes = {
        "GSICommunicator.lua"
    }

    self.Hooks = {
        --["core/lib/utils/game_state_machine/coregamestatemachine"] = "CoreGameStateMachine.lua"
        ["lib/units/beings/player/playerbase"] = "PlayerBase.lua",
        ["lib/units/beings/player/huskplayerbase"] = "HuskPlayerBase.lua",
        ["lib/units/beings/player/playerdamage"] = "PlayerDamage.lua",
        ["lib/units/beings/player/huskplayermovement"] = "HuskPlayerMovement.lua",
        ["lib/units/beings/player/playerinventory"] = "PlayerInventory.lua",
        ["lib/managers/hudmanagerpd2"] = "HudManagerPD2.lua",
        ["lib/managers/hudmanager"] = "HudManager.lua",
        ["lib/managers/playermanager"] = "PlayerManager.lua",
        ["lib/managers/criminalsmanager"] = "CriminalsManager.lua",
        ["lib/managers/groupaimanager"] = "GroupAIManager.lua",
        ["lib/managers/group_ai_states/groupaistatebase"] = "GroupAiStateBase.lua",
        ["lib/managers/group_ai_states/groupaistatebesiege"] = "GroupAiStateBesiege.lua",
        ["lib/managers/menumanager"] = "MenuManager.lua"
    }

    self.managers = {}

    self.Intergrations = {}
end

if RequiredScript then
    local requiredScript = RequiredScript:lower()
    if GSI.Hooks[requiredScript] then
        dofile( GSI.ModPath .. GSI.HooksDirectory .. GSI.Hooks[requiredScript] )
    end
end

--Need to use _init as init is used by ModuleBase class
function GSI:_init()
    log("GSI init")

    if not file.DirectoryExists(self.IntergrationPath) then
        os.execute("mkdir " .. self.IntergrationPath)
    end

    for _, class in pairs(self.Classes) do
        dofile(self.ModPath .. self.ClassDirectory .. class)
    end

    self:LoadIntergrations()

    self.managers.Communicator = GSICommunicator:new()
end

function GSI:LoadIntergrations()
    local files = file.GetFiles(self.IntergrationPath)
    if files then
        for _, config_file in pairs(files) do
            local cfile_split = string.split(config_file, "%.")
            local cfile = io.open(self.IntergrationPath .. "/" .. config_file, 'r')
            local data
            if cfile_split[#cfile_split] == "xml" then
                data = ScriptSerializer:from_custom_xml(cfile:read("*all"))
            else
                data = json.custom_decode(cfile:read("*all"))
            end

            self:LoadIntergrationConfig(data)
        end
    end
end

function GSI:LoadIntergrationConfig(data)
    table.insert(self.Intergrations, {
        uri = data.uri,
        name = data.name
    })
end

if not GSI.setup then
    GSI:_init()
    GSI.setup = true
end

if Global.load_level and not GSI.LoadedLevelData then
    GSI.managers.Communicator:SetVariable("level", "level_id", Global.level_data.level_id)
    --local level_tweak = tweak_data.levels[Global.level_data.level_id] or {}
    --if level_tweak.name_id then
        --GSI.managers.Communicator:SetVariable("level", "level_name", managers.localization:text(level_tweak.name_id))
    --end
    GSI.LoadedLevelData = true
end

local load_game_settings = function()
    local data = Global.game_settings
    GSI.managers.Communicator:SetVariable("lobby", "difficulty", data.difficulty)
    GSI.managers.Communicator:SetVariable("lobby", "permission", data.permission)
    GSI.managers.Communicator:SetVariable("lobby", "team_ai", data.team_ai)
    GSI.managers.Communicator:SetVariable("lobby", "minimum_level", data.reputation_permission)
    GSI.managers.Communicator:SetVariable("lobby", "drop_in", data.drop_in_allowed)
    GSI.managers.Communicator:SetVariable("lobby", "kick_option", data.kick_option)
    GSI.managers.Communicator:SetVariable("lobby", "job_plan", data.job_plan)
    GSI.managers.Communicator:SetVariable("lobby", "cheater_auto_kick", data.auto_kick)
    GSI.managers.Communicator:SetVariable("lobby", "singleplayer", data.single_player)
end

if Global.game_settings and not GSI.LoadedGameSettings then
    load_game_settings()
    GSI.LoadedGameSettings = true
end

if setup and not GSI.SetSetupData then --Uses not not to ensure the value ends up as a boolean
    GSI.managers.Communicator:SetVariable("game", "is_start_menu", not not setup.IS_START_MENU)

    GSI.SetSetupData = true
end

--[[if GSI.SetSetupData and GSI.LoadedGameSettings and GSI.LoadedLevelData then
    GSI.managers.Communicator:SendMessage()
end]]--

if Hooks then
    Hooks:Add("GameSetupUpdate", "GSIGameSetupUpdate", function( t, dt )
        for _, manager in pairs(GSI.managers) do
            if manager.update then
                manager:update(t, dt)
            end
        end
    end)

    -- Not working currently
    --[[if GameStateMachine then
        Hooks:PostHook(GameStateMachine, "_do_state_change", function(self)
            --Set state param
            GSI.managers.Communicator:SetVariable("game", "state", self._current_state)
        end)
    end]]

    --[[if game_state_machine then
        game_state_machine.__do_state_change = game_state_machine.__do_state_change or game_state_machine._do_state_change

        function game_state_machine:_do_state_change()
            self:__do_state_change()
            GSI.managers.Communicator:SetVariable("game", "state", self._current_state)
        end
    end]]
    if NetworkPeer then
        Hooks:PostHook(NetworkPeer, "destroy", function(self)
            GSI.managers.Communicator:RemoveSubTable("players/" .. self:id())
        end)

        Hooks:PostHook(NetworkPeer, "set_profile", function(self, level, rank)
            GSI.managers.Communicator:SetVariable("players/" .. self:id(), "level", level)
            GSI.managers.Communicator:SetVariable("players/" .. self:id(), "rank", rank)
        end)

        Hooks:PostHook(NetworkPeer, "set_rank", function(self, rank)
            GSI.managers.Communicator:SetVariable("players/" .. self:id(), "rank", rank)
        end)

        Hooks:PostHook(NetworkPeer, "set_level", function(self, level)
            GSI.managers.Communicator:SetVariable("players/" .. self:id(), "level", level)
        end)
    end

    if MenuCallbackHandler then
        Hooks:PostHook(MenuCallbackHandler, "update_matchmake_attributes", function(self)
            load_game_settings()
        end)
    end
    if CoreEnvironmentControllerManager then
        Hooks:PostHook( CoreEnvironmentControllerManager, "set_post_composite", "GSISetPostComposite", function(self, t, dt)
            if managers.network:session() then
                local id = managers.network:session():local_peer():id()
                if 0 < self._current_flashbang then
                    GSI.managers.Communicator:SetVariable("players/" .. id, "flashbang_amount", math.min(self._current_flashbang, 1))
                else
                    GSI.managers.Communicator:SetVariable("players/" .. id, "flashbang_amount", nil)
                end
            end
        end )
    end
end
