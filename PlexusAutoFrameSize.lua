local Plexus = _G.Plexus
local select = select
local max = max --luacheck: ignore 113
local ceil = ceil --luacheck: ignore 113
local GetNumSubgroupMembers = GetNumSubgroupMembers --luacheck: ignore 113
local GetNumGroupMembers = GetNumGroupMembers --luacheck: ignore 113
local GetRaidRosterInfo = GetRaidRosterInfo --luacheck: ignore 113
local InCombatLockdown = InCombatLockdown --luacheck: ignore 113
local IsInRaid = IsInRaid --luacheck: ignore 113

local PlexusAutoFrameSize = Plexus:NewModule("PlexusAutoFrameSize", "AceBucket-3.0", "AceTimer-3.0")
local PlexusFrame = Plexus:GetModule("PlexusFrame")

PlexusAutoFrameSize.defaultDB = {
    width = {
        One = 60,
        Two = 55,
        Three = 75,
        Four = 80,
        Five = 60,
        Six = 50,
        Seven = 40,
        Eight = 37,
    },
    height = {
        One = 60,
        Two = 55,
        Three = 75,
        Four = 80,
        Five = 60,
        Six = 50,
        Seven = 40,
        Eight = 37,
    },
}

local function getRaidSize()
    local maxGroups = 1
    local raidSize = GetNumGroupMembers()

    if raidSize > 0 then
        maxGroups = ceil(raidSize / 5)
        if IsInRaid() then
            for i = 1, raidSize do
                local group = select(3, GetRaidRosterInfo(i))
                maxGroups = max(maxGroups, group)
            end
        end
    elseif GetNumSubgroupMembers() > 0 then
        maxGroups = 1
    end

    return maxGroups
end

function PlexusAutoFrameSize:OnInitialize()
    self.super.OnInitialize(self)
end

function PlexusAutoFrameSize:OnEnable()
    local opt = Plexus.options.args
    opt["PlexusAutoFrameSize"] = {
        type = "group",
        name = "PlexusAutoFrameSize",
        desc = "PlexusAutoFrameSize",
        childGroups = "tab",
        args = {
            width = {
                name = "Width",
                order = 1,
                type = "group",
                args = {
                    One = {
                        name = "One Group",
                        desc = "",
                        order = 1, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Two = {
                        name = "Two Groups",
                        desc = "",
                        order = 2, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Three = {
                        name = "Three Groups",
                        desc = "",
                        order = 3, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Four = {
                        name = "Four Groups",
                        desc = "",
                        order = 4, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Five = {
                        name = "Five Groups",
                        desc = "",
                        order = 5, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Six = {
                        name = "Six Groups",
                        desc = "",
                        order = 6, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Seven = {
                        name = "Seven Groups",
                        desc = "",
                        order = 7, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Eight = {
                        name = "Eight Groups",
                        desc = "",
                        order = 8, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                },
            },
            height = {
                name = "Height",
                order = 2,
                type = "group",
                args = {
                    One = {
                        name = "One Group",
                        desc = "",
                        order = 1, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Two = {
                        name = "Two Groups",
                        desc = "",
                        order = 2, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Three = {
                        name = "Three Groups",
                        desc = "",
                        order = 3, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Four = {
                        name = "Four Groups",
                        desc = "",
                        order = 4, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Five = {
                        name = "Five Groups",
                        desc = "",
                        order = 5, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Six = {
                        name = "Six Groups",
                        desc = "",
                        order = 6, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Seven = {
                        name = "Seven Groups",
                        desc = "",
                        order = 7, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                    Eight = {
                        name = "Eight Groups",
                        desc = "",
                        order = 8, width = "double",
                        type = "range", min = 10, max = 100, step = 1,
                    },
                },
            },
        },
    }

  self.super.OnEnable(self)

  self:RegisterMessage("Plexus_EnteringCombat", "InCombat")
  self:RegisterMessage("Plexus_LeavingCombat", "OutofCombat")

end

local function CheckRoster() --luacheck: ignore 211
    if InCombatLockdown() then
        PlexusFrame:CancelAllTimers()
        return
    end
    local height
    local width

    local maxGroups = getRaidSize()
    if maxGroups == 1 then
        height = PlexusAutoFrameSize.db.profile.height.One
        width = PlexusAutoFrameSize.db.profile.width.One
    end
    if maxGroups == 2 then
        height = PlexusAutoFrameSize.db.profile.height.Two
        width = PlexusAutoFrameSize.db.profile.width.Two
    end
    if maxGroups == 3 then
        height = PlexusAutoFrameSize.db.profile.height.Three
        width = PlexusAutoFrameSize.db.profile.width.Three
    end
    if maxGroups == 4 then
        height = PlexusAutoFrameSize.db.profile.height.Four
        width = PlexusAutoFrameSize.db.profile.width.Four
    end
    if maxGroups == 5 then
        height = PlexusAutoFrameSize.db.profile.height.Five
        width = PlexusAutoFrameSize.db.profile.width.Five
    end
    if maxGroups == 6 then
        height = PlexusAutoFrameSize.db.profile.height.Six
        width = PlexusAutoFrameSize.db.profile.width.Six
    end
    if maxGroups == 7 then
        height = PlexusAutoFrameSize.db.profile.height.Seven
        width = PlexusAutoFrameSize.db.profile.width.Seven
    end
    if maxGroups == 8 then
        height = PlexusAutoFrameSize.db.profile.height.Eight
        width = PlexusAutoFrameSize.db.profile.width.Eight
    end

    if PlexusFrame.db.profile.frameWidth ~= width or  PlexusFrame.db.profile.frameHeight ~= height then
        PlexusFrame.db.profile.frameWidth = width
        PlexusFrame.db.profile.frameHeight = height
        PlexusFrame:ResizeAllFrames()
        PlexusFrame:UpdateAllFrames()
    end

end

local function OutofCombat() --luacheck: ignore 211

    if not InCombatLockdown() then
        if not PlexusAutoFrameSize.CheckRosterTimer or PlexusAutoFrameSize.CheckRosterTimer == 0 then
            PlexusAutoFrameSize.CheckRosterTimer = PlexusFrame:ScheduleRepeatingTimer("CheckRoster", 2)
        end
    end

end

local function InCombat() --luacheck: ignore 211

    if InCombatLockdown() then
        PlexusFrame:CancelAllTimers()
    end

end

