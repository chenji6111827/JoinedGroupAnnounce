local Addon = select(2, ...)

local Api = Addon.Api
local L = Addon.L

--Wow Api
Api.GetSpellCooldown = C_Spell.GetSpellCooldown
Api.GetSpellName = C_Spell.GetSpellName
Api.IsSpellInSpellBook = C_SpellBook.IsSpellInSpellBook
Api.IsSpellKnownOrInSpellBook = C_SpellBook.IsSpellKnownOrInSpellBook
Api.GetInstanceInfo = GetInstanceInfo
Api.GetOwnedKeystoneMapID = C_MythicPlus.GetOwnedKeystoneMapID
Api.GetContainerNumSlots = C_Container.GetContainerNumSlots
Api.GetContainerItemLink = C_Container.GetContainerItemLink
Api.HasSlottedKeystone = C_ChallengeMode.HasSlottedKeystone
Api.PickupContainerItem = C_Container.PickupContainerItem
Api.SlotKeystone = C_ChallengeMode.SlotKeystone
Api.SendChatMessage = C_ChatInfo.SendChatMessage
Api.IsInGroup = IsInGroup
Api.GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
Api.GetRealZoneText = GetRealZoneText
Api.GetSpellLink = C_Spell.GetSpellLink


--Api By Self
--- Add print message to chat window
function Api:Print(msg)
    if not msg or type(msg) ~= "string" then return end
    local message = self:SetColorText("FFFF7F07", L["JoinFrameTitle"]) .. tostring(msg)
    DEFAULT_CHAT_FRAME:AddMessage(message)
    DEFAULT_CHAT_FRAME:ScrollToBottom()
end

--- Sets colored text with hex color code
--- @param colorHexCode string Hex color code in format RRGGBB or AARRGGBB (e.g., "F77700" or "FFF77700")
function Api:SetColorText(colorHexCode, text)
    if not colorHexCode or type(colorHexCode) ~= "string" then
        error("SetColorText: colorHexCode must be a string")
    end

    colorHexCode = colorHexCode:gsub("^#", "")

    if not string.match(colorHexCode, "^[%x][%x][%x][%x][%x][%x]$") and
        not string.match(colorHexCode, "^[%x][%x][%x][%x][%x][%x][%x][%x]$") then
        error("SetColorText: colorHexCode must be in format RRGGBB or AARRGGBB")
    end

    if #colorHexCode == 6 then
        colorHexCode = "FF" .. colorHexCode
    end

    return string.format("|c%s%s|r", colorHexCode, text)
end

function Api:GetTeleportToolTipTextFromSpellID(spellID)
    if spellID == 0 then
        return ""
    end

    if not Api.IsSpellKnownOrInSpellBook(spellID) then
        return SPELL_FAILED_NOT_KNOWN
    end

    local cd = Api.GetSpellCooldown(spellID)
    local spellName = Api.GetSpellName(spellID)

    if cd.startTime > 0 and cd.duration > 0 then
        local remainingSeconds = (cd.startTime + cd.duration) - GetTime()
        local hours = math.floor(remainingSeconds / 3600)
        remainingSeconds = remainingSeconds % 3600
        local minutes = math.floor(remainingSeconds / 60)
        return L["Teleport On Cooldown"]:format(spellName, hours, minutes)
    else
        return L["Teleport Ready"]:format(spellName)
    end
end

function Api:RegisterSlashCommand(slash, func)
    if type(slash) ~= "string" or type(func) ~= "function" then
        return
    end
    local cmd = slash:upper()
    if not SlashCmdList[cmd] then
        SlashCmdList[cmd] = func
    end
    local maxNum = 1
    while _G["SLASH_" .. cmd .. maxNum] do
        maxNum = maxNum + 1
    end
    _G["SLASH_" .. cmd .. maxNum] = "/" .. slash
end
