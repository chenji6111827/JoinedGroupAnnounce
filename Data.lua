local Addon = select(2, ...)

local Data = Addon.Data

-- teleportList

---map IDs at: https://wago.tools/db2/MapChallengeMode
---ID = { SpellID , MapID }
---C_ChallengeMode.GetMapUIInfo(id) can get
--   1. name: string
--   2. id: number
--   3. timeLimit: number
--   4. texture: number?
--   5. backgroundTexture: number
--   6. mapID: number
--C_ChallengeMode.GetMapTable -Get Current Season Map List IDs
Data.teleportList = {
    -- Midnight
    [557] = { SpellID = 1254400, MapID = 2805 }, -- Windrunner Spire风行者之塔
    [558] = { SpellID = 1254572, MapID = 2811 }, -- Magisters' Terrace魔导师平台
    [560] = { SpellID = 1254559, MapID = 2874 }, -- Maisara Caverns迈萨拉洞窟
    [559] = { SpellID = 1254563, MapID = 2915 }, -- Nexus-Point Xenas节点希纳斯
    -- The war within
    [500] = { SpellID = 445443, MapID = 2648 },  -- The Rookery
    [499] = { SpellID = 445444, MapID = 2649 },  -- Priory of the Sacred Flame
    [504] = { SpellID = 445441, MapID = 2651 },  -- Darkflame Cleft
    [501] = { SpellID = 445269, MapID = 2652 },  -- The Stonevault
    [503] = { SpellID = 445417, MapID = 2660 },  -- Ara-Kara, City of Echoes
    [506] = { SpellID = 445440, MapID = 2661 },  -- Cinderbrew Meadery
    [505] = { SpellID = 445414, MapID = 2662 },  -- The Dawnbreaker
    [502] = { SpellID = 445416, MapID = 2669 },  -- City of Threads
    [525] = { SpellID = 1216786, MapID = 2773 }, -- Operation: Floodgate
    [542] = { SpellID = 1237215, MapID = 2830 }, -- Eco-Dome Al'dani

    -- Dragonflight
    [403] = { SpellID = 393222, MapID = 2451 }, -- Uldaman: Legacy of Tyr
    [401] = { SpellID = 393279, MapID = 2515 }, -- The Azure Vault
    [400] = { SpellID = 393262, MapID = 2516 }, -- The Nokhud Offensive
    [404] = { SpellID = 393276, MapID = 2519 }, -- Neltharus
    [405] = { SpellID = 393267, MapID = 2520 }, -- Brackenhide Hollow
    [399] = { SpellID = 393256, MapID = 2521 }, -- Ruby Life Pools
    [402] = { SpellID = 393273, MapID = 2526 }, -- Algeth'ar Academy
    [406] = { SpellID = 393283, MapID = 2527 }, -- Halls of Infusion
    [464] = { SpellID = 424197, MapID = 2579 }, --Dawn of the Infinite: Murozond's Rise 永恒黎明：姆诺兹多的崛起
    [463] = { SpellID = 424197, MapID = 2579 }, -- Dawn of the Infinite: Galakrond's Fall 永恒黎明：迦拉克隆的陨落

    -- Shadowlands
    [380] = { SpellID = 354469, MapID = 2284 }, -- Sanguine Depths
    [381] = { SpellID = 354466, MapID = 2285 }, -- Spires of Ascension
    [376] = { SpellID = 354462, MapID = 2286 }, -- The Necrotic Wake
    [378] = { SpellID = 354465, MapID = 2287 }, -- Halls of Atonement
    [379] = { SpellID = 354463, MapID = 2289 }, -- Plaguefall
    [375] = { SpellID = 354464, MapID = 2290 }, -- Mists of Tirna Scithe
    [377] = { SpellID = 354468, MapID = 2291 }, -- De Other Side
    [382] = { SpellID = 354467, MapID = 2293 }, -- Theater of Pain
    [391] = { SpellID = 367416, MapID = 2441 }, -- Tazavesh: Streets of Wonder
    [392] = { SpellID = 367416, MapID = 2441 }, -- Tazavesh: So'leah's Gambit

    -- Battle For Azeroth
    [244] = { SpellID = 424187, MapID = 1763 },                                                        -- Atal'Dazar
    [245] = { SpellID = 410071, MapID = 1754 },                                                        -- Freehold
    [353] = { SpellID = UnitFactionGroup("player") == "Alliance" and 445418 or 464256, MapID = 1822 }, -- The Ruins of Lordaeron
    [247] = { SpellID = UnitFactionGroup("player") == "Alliance" and 467553 or 467555, MapID = 1594 }, -- The Stormspire
    [251] = { SpellID = 410074, MapID = 1841 },                                                        -- The Underrot
    [248] = { SpellID = 424167, MapID = 1862 },                                                        -- Waycrest Manor
    [369] = { SpellID = 373274, MapID = 2097 },                                                        --Operation: Mechagon - Junkyard 麦卡贡行动 - 垃圾场
    -- [246] = { SpellID = XX, MapID = 1771 },  -- Tol Dagor 托尔达戈
    -- [249] = { SpellID = XX, MapID = 1762 },  -- Kings' Rest 诸王之眠
    -- [250] = { SpellID = XX, MapID = 1877 },   -- Temple of Sethraliss 塞塔里斯神庙
    -- [252] = { SpellID = XX, MapID = 1864 },  -- Shrine of the Storm 风暴神殿
    [370] = { SpellID = 373274, MapID = 2097 }, -- Operation: Mechagon - Workshop 麦卡贡行动 - 车间

    -- Legion
    -- [197] = { SpellID = XX, MapID = 1456 },  -- Eye of Azshara 艾萨拉之眼
    -- [207] = { SpellID = XX, MapID = 1493 },  -- Vault of the Wardens 守望者地窟
    -- [208] = { SpellID = XX, MapID = 1492 },  -- Maw of Souls 噬魂之喉
    -- [209] = { SpellID = XX, MapID = 1516 },  -- The Arcway 魔法回廊
    -- [233] = { SpellID = XX, MapID = 1677 },  -- Cathedral of Eternal Night 永夜大教堂
    -- [234] = { SpellID = XX, MapID = 1651 },  -- Return to Karazhan: Upper 重返卡拉赞（上层）
    [210] = { SpellID = 393766, MapID = 1571 },  -- Court of Stars
    [227] = { SpellID = 373262, MapID = 1651 },  -- Return to Karazhan
    [199] = { SpellID = 424153, MapID = 1501 },  -- Black Rook Hold
    [198] = { SpellID = 424163, MapID = 1466 },  -- Darkheart Thicket
    [206] = { SpellID = 410078, MapID = 1458 },  -- Neltharion's Lair
    [200] = { SpellID = 393764, MapID = 1477 },  -- Halls of Valor
    [239] = { SpellID = 1254551, MapID = 1753 }, -- Seat of the Triumvirate 执政团之座
    [583] = { SpellID = 1254551, MapID = 1753 }, -- Seat of the Triumvirate 执政团之座

    -- Warlords of Draenor
    [161] = { SpellID = 159898, MapID = 1209 }, -- Skyreach
    [165] = { SpellID = 159899, MapID = 1176 }, -- Shadowmoon Burial Grounds
    [166] = { SpellID = 159900, MapID = 1208 }, -- Grimrail Depot
    [168] = { SpellID = 159901, MapID = 1279 }, -- The Everbloom
    [169] = { SpellID = 159896, MapID = 1195 }, -- Iron Docks
    [164] = { SpellID = 159897, MapID = 1182 }, -- Auchindoun
    [163] = { SpellID = 159895, MapID = 1175 }, -- Bloodmaul Slag Mines
    [167] = { SpellID = 159902, MapID = 1358 }, -- Upper Blackrock Spire

    -- Mists of Pandaria
    [58] = { SpellID = 131206, MapID = 959 },  -- Shado-Pan Monastery
    [2] = { SpellID = 131204, MapID = 960 },   -- Temple of the Jade Serpent
    [56] = { SpellID = 131205, MapID = 961 },  -- Stormstout Brewery
    [57] = { SpellID = 131225, MapID = 962 },  -- Gate of the Setting Sun
    [60] = { SpellID = 131222, MapID = 994 },  -- Mogu'shan Palace
    [77] = { SpellID = 131231, MapID = 1001 }, -- Scarlet Halls
    [76] = { SpellID = 131232, MapID = 1007 }, -- Scholomance
    [59] = { SpellID = 131228, MapID = 1011 }, -- Siege of Niuzao Temple
    [78] = { SpellID = 131229, MapID = 1004 }, -- Scarlet Monastery

    -- Cataclysm
    [456] = { SpellID = 424142, MapID = 643 }, -- Throne of the Tides
    [438] = { SpellID = 410080, MapID = 657 }, -- The Vortex Pinnacle
    [507] = { SpellID = 445424, MapID = 670 }, --Grim Batol 格瑞姆巴托

    --	-- Wrath of the Lich King
    [556] = { SpellID = 1254555, MapID = 658 }, --Pit of Saron 萨隆矿坑
}
