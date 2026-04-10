local Addon = select(2, ...)

local L = Addon.L
local Api = Addon.Api
local Data = Addon.Data
local Core = Addon.Core
local UiElement = {}





local function JoinedGroupAnnounce()
    if not UiElement.frame then
        UiElement.frame = CreateFrame("Frame", nil, UIParent,
            "JoinAlertTemplate")
    end
    local frame = UiElement.frame
    frame:ClearAllPoints()
    frame:SetPoint(
        JoinedGroupAnnounceDB.positions.point,
        UIParent,
        JoinedGroupAnnounceDB.positions.relativePoint,
        JoinedGroupAnnounceDB.positions.x,
        JoinedGroupAnnounceDB.positions.y
    )


    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relativePoint, x, y = self:GetPoint()
        x = math.floor(x + 0.5)
        y = math.floor(y + 0.5)
        JoinedGroupAnnounceDB.positions.point = point
        JoinedGroupAnnounceDB.positions.relativePoint = relativePoint
        JoinedGroupAnnounceDB.positions.x = x
        JoinedGroupAnnounceDB.positions.y = y
    end)


    frame:Hide()
    frame:SetTitle(L["JoinFrameTitle"])

    --for testing
    -- do
    --     frame:Show()
    --     local button = frame.teleportButton
    --     button:Show()
    --     button:SetText(GetRealZoneText(2441))
    --     button:SetTexture(select(5, Api.GetMapUIInfo(391)))
    --     button:SetTooltipText(Api:GetTeleportToolTipTextFromSpellID(367416))
    --     button.bgImage:SetTexCoord(0.1, 0.72, 0.1, 0.65)
    --     button:SetAttribute("type", "spell")
    --     button:SetAttribute("spell", 367416)
    -- end
    EventRegistry:RegisterFrameEventAndCallback("LFG_LIST_APPLICATION_STATUS_UPDATED",
        function(_, resultid, status, _, GroupTitle)
            if not resultid or not (status == 'inviteaccepted') then return end

            local info = C_LFGList.GetSearchResultInfo(resultid)
            if not info or not info.activityIDs or #info.activityIDs == 0 then return end

            local activityID = nil
            for _, id in pairs(info.activityIDs) do
                activityID = id
                break
            end

            if not activityID then return end


            local activityInfo = C_LFGList.GetActivityInfoTable(activityID) or "Unknown activity"
            local groupTitle   = GroupTitle or ""
            local name         = activityInfo.fullName
            local mapID        = activityInfo.mapID
            local nameAndTitle = name .. " " .. groupTitle
            frame.text:SetText(nameAndTitle)
            frame:Show()

            local isKeyStone = activityInfo.difficultyID == 8
            local button = frame.teleportButton

            if isKeyStone then
                for mapChallengeModeID, mapInfo in pairs(Data.teleportList) do
                    if mapInfo.MapID == mapID then
                        button:SetAttribute("type", "spell")
                        button:SetAttribute("spell", mapInfo.SpellID)
                        button:SetTooltipText(Api:GetTeleportToolTipTextFromSpellID(mapInfo.SpellID))

                        local texture = select(5, Api.GetMapUIInfo(mapChallengeModeID))
                        button:SetTexture(texture)
                        button.bgImage:SetTexCoord(0.1, 0.72, 0.1, 0.65)

                        local instanceName = Api.GetRealZoneText(mapID)
                        button:SetText(instanceName)

                        button:Show()
                        break
                    end
                end
            else
                C_Timer.After(3, function() frame:Hide() end)
            end


            local function Say()
                if IsInGroup() then
                    local safeMessage = nameAndTitle:gsub("|K.-|k", "")
                    Api.SendChatMessage(JOIN .. safeMessage, "PARTY")
                else
                    print(">>>> " .. JOIN .. nameAndTitle)
                end
            end


            C_Timer.After(2, Say)
        end)
end




local function EnableModule(state)
    if state then
        JoinedGroupAnnounce()
    else
        Core:ClearTable(UiElement)
    end
end


do
    local moduleData = {
        name = L["JoinedGroupAnnounceName"],
        dbKey = "JoinedGroupAnnounce",
        description = L["JoinedGroupAnnounceDescription"],
        toggleFunc = EnableModule,
    };

    Core:AddModule(moduleData);
end
