local Addon = select(2, ...)

local Api = Addon.Api


local Core = {}
Core.modules = {}
Addon.Core = Core


function Core:InitializeModules()
    local enabled
    for _, moduleData in pairs(self.modules) do
        enabled = Addon.GetDBValue(moduleData.dbKey)
        if enabled and moduleData.toggleFunc then
            Api:Print(string.format("Loading modules:%s", moduleData.name))
            moduleData.toggleFunc(enabled)
        end
    end
end

function Core:AddModule(moduleData)
    self.modules[moduleData.dbKey] = moduleData
end

-- function Core:GetModule(name)
--     if not self.modules[name] then
--         print("Module <" .. name .. "> does not exist.")
--         return
--     end

--     return self.modules[name]
-- end

-- function Core:ToggleModule(name)
--     local module = Core:GetModule(name)
--     if not module then
--         return
--     end

--     local enabled = not Addon.GetDBValue(module.dbKey)
--     Addon.SetDBValue(module.dbKey, enabled)

--     if module.toggleFunc then
--         module.toggleFunc(enabled)
--     end
-- end

-- function Core:SetModuleState(name, state)
--     local module = Core:GetModule(name)
--     if not module then
--         return
--     end

--     Addon.SetDBValue(module.dbKey, state)

--     if module.toggleFunc then
--         module.toggleFunc(state)
--     end
-- end


function Core:ClearTable(t)
    local function Clear()
        if t then
            for _, element in pairs(t) do
                if element.Hide then
                    element:Hide()
                end
                if element.GetObjectType and element:GetObjectType() == "Frame" then
                    element:Hide()
                end
                if type(element) == "table" then
                    Core:ClearTable(element)
                end
            end
            wipe(t)
        end
    end
    EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGOUT", Clear)
end
