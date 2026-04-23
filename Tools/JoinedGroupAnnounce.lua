local Addon = select(2, ...)

local L = Addon.L
local Api = Addon.Api
local Data = Addon.Data
local Core = Addon.Core
local UiElement = {}

local SharedData = {
    currentGroupName = nil,
    lastJoinedResultID = nil
}

local function LFGApplicationsStatus()
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
        function(_, resultid, newStatus, oldStatus, GroupTitle)
            if not resultid then return end
            local info = C_LFGList.GetSearchResultInfo(resultid)
            if not info or not info.activityIDs or #info.activityIDs == 0 then
                return
            end

            local activityID   = info.activityIDs[1]
            local activityInfo = C_LFGList.GetActivityInfoTable(activityID) or
                { fullName = "Unknown activity", mapID = 0 }
            local groupTitle   = GroupTitle or info.name or ""
            local name         = activityInfo.fullName or "Unknown activity"
            local mapID        = activityInfo.mapID or 0
            local nameAndTitle = name .. " " .. groupTitle


            if newStatus == 'inviteaccepted' then
                frame.text:SetText(nameAndTitle)
                frame:Show()

                local isKeyStone = activityInfo.difficultyID == 8
                local button = frame.teleportButton

                if isKeyStone then
                    for mapChallengeModeID, mapInfo in pairs(Data.teleportList) do
                        if mapInfo.MapID == mapID then
                            button:SetAttribute("type", "spell")
                            button:SetAttribute("spell", mapInfo.SpellID)
                            button.spellID = mapInfo.SpellID
                            button:HookScript("OnEnter",
                                function(self) self:SetTooltipText(Api:GetTeleportToolTipTextFromSpellID(self.spellID)) end)

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
                    local channel = IsInRaid() and "RAID" or "PARTY"
                    local safeMessage = nameAndTitle:gsub("|K.-|k", "")
                    Api.SendChatMessage(string.format("%s %s", LFG_LIST_APP_INVITE_ACCEPTED, safeMessage), channel)
                end

                C_Timer.After(2, Say)
            elseif newStatus == 'declined_full' then
                Api:Print(string.format("|cFFFF0000>>>> %s|r",
                    string.format(LFG_LIST_APP_DECLINED_FULL_MESSAGE, nameAndTitle)))
            elseif newStatus == 'declined' then
                Api:Print(string.format("|cFFFF0000>>>> %s|r", string.format(LFG_LIST_APP_DECLINED_MESSAGE, nameAndTitle)))
            end
        end)
end

local function LFGApplicantInfo()
    local processedApplicants = {}


    EventRegistry:RegisterFrameEventAndCallback("LFG_LIST_APPLICANT_LIST_UPDATED",
        function(newPendingEntry, _)
            if not C_LFGList.HasActiveEntryInfo() or IsInRaid() then
                return
            end

            if newPendingEntry then
                local applicants = C_LFGList.GetApplicants()
                if not applicants or #applicants == 0 then
                    processedApplicants = {}
                    return
                end

                for _, applicantID in ipairs(applicants) do
                    local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)

                    if applicantInfo then
                        if processedApplicants[applicantID] then
                            return
                        end

                        local numMembers = applicantInfo.numMembers or 1
                        local comment = applicantInfo.comment or ""

                        processedApplicants[applicantID] = true

                        Api:Print(string.format(L["LFG APPLYING NUMBERS"], numMembers))
                        PlaySound(8959)

                        for i = 1, numMembers do
                            local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel, factionGroup, raceID, specID, isLeaver =
                                C_LFGList.GetApplicantMemberInfo(applicantID, i)

                            if name then
                                local roles = {}
                                if tank then table.insert(roles, TANK) end
                                if healer then table.insert(roles, HEALER) end
                                if damage then table.insert(roles, DAMAGER) end
                                local roleStr = #roles > 0 and table.concat(roles, "/") or LFG_TYPE_NONE

                                Api:Print("---")
                                Api:Print(SHOW_PLAYER_NAMES .. "：" .. name)
                                Api:Print(CLASS .. "：" .. localizedClass)
                                Api:Print(ROLE .. "：" .. roleStr)
                                Api:Print(string.format(CHARACTER_LINK_ITEM_LEVEL_TOOLTIP, itemLevel or 0))
                                Api:Print(string.format(DUNGEON_SCORE_LINK_RATING, dungeonScore or 0))
                                Api:Print(string.format(LEVEL_GAINED, level or 0))
                            end
                        end

                        Api:Print(string.format(L["Comment"], comment ~= "" and comment or LFG_TYPE_NONE))
                        Api:Print("----")
                    end
                end
            end
        end)

    EventRegistry:RegisterFrameEventAndCallback("LFG_LIST_APPLICANT_UPDATED",
        function(applicantID)
            local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)

            if applicantInfo then
                local status = applicantInfo.applicationStatus or "unknown"

                if status ~= "applied" and status ~= "invited" then
                    processedApplicants[applicantID] = nil
                end
            end
        end)
end






local function EnableModule(state)
    if state then
        LFGApplicationsStatus()
        LFGApplicantInfo()
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
