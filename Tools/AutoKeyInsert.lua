local Addon = select(2, ...)

local L = Addon.L
local Api = Addon.Api
local Core = Addon.Core

local UiElement = {}

--auto slotting the keystone
local function Slotting()
    if not UiElement.keystoneText then
        UiElement.keystoneText = ChallengesKeystoneFrame:CreateFontString(nil, nil, "Fancy14Font")
        UiElement.keystoneText:SetPoint("BOTTOM", ChallengesKeystoneFrame, "BOTTOM", 0, 180)
        UiElement.keystoneText:SetSize(300, 30)
        UiElement.keystoneText:SetJustifyH("CENTER")
    end
    UiElement.keystoneText:SetText("")
    local instanceID = select(8, Api.GetInstanceInfo())
    if Api.GetOwnedKeystoneMapID() == instanceID then
        for bagIndex = 0, 4 do
            local slots = Api.GetContainerNumSlots(bagIndex)
            for currentSlot = 1, slots do
                local itemLink = Api.GetContainerItemLink(bagIndex, currentSlot)
                if itemLink and itemLink:find("Hkeystone", nil, true) then
                    UiElement.keystoneText:SetText(L["keystoneAutoSlotFrame"])
                    Api:Print(L["keystoneAutoSlotMessage"]:format(itemLink))
                    if not Api.HasSlottedKeystone() then
                        Api.PickupContainerItem(bagIndex, currentSlot)
                        Api.SlotKeystone()
                        CloseAllBags()
                        if Api.IsInGroup("PARTY") then
                            Api.SendChatMessage(L["I'm Preparing to slot key"]:format(itemLink), "PARTY")
                        end
                        return
                    end
                end
            end
        end
    end
end

local function CreateButton(self, text, point, offsetX, offsetY, template, cooldownTime)
    local button = CreateFrame("Button", nil, self, template)
    local x, y = self.StartButton:GetSize() and self.StartButton:GetSize() or 100, 30
    button:SetSize(x, y)
    button:SetText(text)
    button:SetPoint(point, self.StartButton and self.StartButton or UIParent, point, offsetX, offsetY)
    button:RegisterForClicks("AnyDown")

    local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    cooldown:SetAllPoints()

    cooldown:SetScript("OnShow", function()
        button:SetEnabled(false)
    end)
    cooldown:SetScript("OnHide", function()
        if UnitIsGroupLeader("player") or not IsInGroup() then
            button:SetEnabled(true)
        end
    end)

    if UnitIsGroupLeader("player") or not IsInGroup() then
        button:SetEnabled(true)
    else
        button:SetEnabled(false)
    end

    button.cooldownTime = cooldownTime or 0
    button.cooldown = cooldown

    return button
end


local function CountDown()
    if UiElement.countDownButton then
        return
    end

    UiElement.countDownButton = CreateButton(ChallengesKeystoneFrame, COUNTDOWN, "LEFT", -100, 0, "UIPanelButtonTemplate",
        5)
    local function OnClick(self, button)
        if button == "LeftButton" then
            C_PartyInfo.DoCountdown(6)
            self.cooldown:SetCooldown(GetTime(), self.cooldownTime)
        elseif button == "RightButton" then
            C_PartyInfo.DoCountdown(10)
            self.cooldown:SetCooldown(GetTime(), 10)
        end
    end
    UiElement.countDownButton:SetScript("OnClick", OnClick)
end




local function ReadyCheck()
    if UiElement.readyCheckButton then
        return
    end
    UiElement.readyCheckButton = CreateButton(ChallengesKeystoneFrame, CRF_READY_CHECK, "RIGHT", 100, 0,
        "UIPanelButtonTemplate", 5)
    local function OnClick(self, button)
        if button == "LeftButton" then
            DoReadyCheck()
            self.cooldown:SetCooldown(GetTime(), self.cooldownTime)
        elseif button == "RightButton" then
            C_PartyInfo.DoCountdown(10)
            self.cooldown:SetCooldown(GetTime(), 10)
        end
    end
    UiElement.readyCheckButton:SetScript("OnClick", OnClick)
end



local handle1
local function AutoKeyInsert()
    local function Invoke()
        Slotting()
        local function DelayInvoke()
            CountDown()
            ReadyCheck()
        end
        C_Timer.After(0.5, DelayInvoke)
    end
    handle1 = EventRegistry:RegisterFrameEventAndCallbackWithHandle("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN", Invoke)
end

local function EnableModule(state)
    if state then
        AutoKeyInsert()
    else
        handle1.Unregister()
        Core:ClearTable(UiElement)
    end
end


do
    local moduleData = {
        name = L["AutoKeyInsertName"],
        dbKey = "AutoKeyInsert",
        description = L["AutoKeyInsertDescription"],
        toggleFunc = EnableModule,
    };

    Core:AddModule(moduleData);
end
