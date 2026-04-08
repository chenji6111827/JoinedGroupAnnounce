local addonName, Addon = ...
local ModulesConfig, DB
--
do
	Addon.Api = Addon.Api or {};
	Addon.L = setmetatable({}, {
		__index = function(t, key)
			if key then
				t[key] = tostring(key)
			end
			return tostring(key)
		end
	});
	Addon.Data = Addon.Data or {};
	ModulesConfig = {
		AutoKeyInsert = true,
		JoinedGroupAnnounce = true,
	};
end

local function GetDBValue(dbKey)
	return DB[dbKey]
end
Addon.GetDBValue = GetDBValue;

-- local function SetDBValue(dbKey, value, userInput)
-- 	if DB then
-- 		DB[dbKey] = value;
-- 	end
-- end

-- Addon.SetDBValue = SetDBValue;

-- local function GetDBBool(dbKey)
-- 	return DB[dbKey] == true
-- end
-- Addon.GetDBBool = GetDBBool;

-- local function FlipDBBool(dbKey)
-- 	SetDBValue(dbKey, not GetDBBool(dbKey), true);
-- end
-- Addon.FlipDBBool = FlipDBBool;


local function LoadData()
	JoinedGroupAnnounceDB = JoinedGroupAnnounceDB or {}
	DB = JoinedGroupAnnounceDB or {}

	local validKeys = {}

	for dbKey, _ in pairs(DB) do
		if ModulesConfig[dbKey] then
			validKeys[dbKey] = true
		else
			DB[dbKey] = nil
		end
	end

	for dbKey, value in pairs(ModulesConfig) do
		if not validKeys[dbKey] then
			DB[dbKey] = value
		end
	end
end




local function LoadAddon(_, name)
	if name == addonName then
		LoadData()
		do
			local function OpenCoolDownManager()
				if not InCombatLockdown() then
					---@diagnostic disable-next-line: undefined-global
					CooldownViewerSettings:ShowUIPanel()
				else
					Addon.Api:Print(GARRISON_LANDING_STATUS_MISSION_COMBAT)
				end
			end
			Addon.Api:RegisterSlashCommand("cds", OpenCoolDownManager)
		end
	end
end
EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", LoadAddon)

--********--

local function LoadModules()
	Addon.Core:InitializeModules()
end
EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", LoadModules)


--********--

local function UnLoadAddon()
	wipe(Addon)
	Addon = nil
end

EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGOUT", UnLoadAddon)
