local Addon = select(2, ...)

local L = Addon.L

local locale = GetLocale()

if locale == "enUS" then
    L["Teleport InCombat"] = "You can't teleport in combat"
    L["Teleport Ready"] = "Teleport |cFF00FF11%s|r Ready"
    L["Teleport On Cooldown"] = "Teleport spell '|cFFFFFFFF%s|r' is on cooldown, needs %d hours %d minutes to be ready."
    L["Teleporting"] = "Using %s to %s"
    L["keystoneAutoSlotFrame"] = "|Tinterface\\icons\\inv_misc_key_12:14:14|t Keystone Auto Inserted"
    L["keystoneAutoSlotMessage"] = "Automatically inserted %s into the keystone slot."
    L["JoinFrameTitle"] = "LFG Joined Announce"
    L["I'm Preparing to slot key"] = "I'm Preparing to slot %s"
    L["AutoKeyInsertName"] = "Auto Key Insert"
    L["AutoKeyInsertDescription"] =
    "When opening the key insertion interface, automatically insert the key and close all bag"
    L["JoinedGroupAnnounceName"] = "LFG Joined Announce"
    L["JoinedGroupAnnounceDescription"] =
    "LFG Joined Announce,when you joined a group that will popup a frame to show what you are doing"
    L["ChallengeFrameEnhanceName"] = "Challenge Frame Enhance"
elseif locale == "zhCN" then
    L["Teleport InCombat"] = "你不能在战斗中传送"
    L["Teleport Ready"] = "传送法术 |cFF00FF11%s|r 准备就绪"
    L["Teleport On Cooldown"] = "传送法术 '|cFFFFFFFF%s|r' 目前处于 |cFFFF4411冷却中|r ，还需 %d 小时 %d 分钟可用。"
    L["Teleporting"] = "正在施放 %s 前往：%s"
    L["keystoneAutoSlotFrame"] = "|Tinterface\\icons\\inv_misc_key_12:14:14|t 史诗钥石已自动插入"
    L["keystoneAutoSlotMessage"] = "已将 %s 自动插入。"
    L["JoinFrameTitle"] = "LFG 进组通报"
    L["I'm Preparing to slot key"] = "准备插入%s"
    L["AutoKeyInsertName"] = "自动插入钥匙"
    L["AutoKeyInsertDescription"] = "当打开插钥匙界面，自动插入钥匙和关闭背包"
    L["JoinedGroupAnnounceName"] = "LFG 进组通报"
    L["JoinedGroupAnnounceDescription"] = "LFG 进组通报，当加入一个队伍时，会弹出一个窗口显示你正在做什么"
    L["ChallengeFrameEnhanceName"] = "挑战地下城界面增强"
end
