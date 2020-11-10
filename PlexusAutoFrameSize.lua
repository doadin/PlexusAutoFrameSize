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
    enable = false,
    width = {
        One = 60,
        Two = 50,
        Three = 40,
        Four = 30,
        Five = 30,
        Six = 30,
        Seven = 30,
        Eight = 30,
    },
    height = {
        One = 60,
        Two = 50,
        Three = 40,
        Four = 30,
        Five = 30,
        Six = 30,
        Seven = 30,
        Eight = 30,
    },
}

local options = {
    type = "group",
    name = "PlexusAutoFrameSize",
    desc = "PlexusAutoFrameSize",
    get = function(info)
        local k = info[#info]
        return PlexusAutoFrameSize.db.profile[k]
    end,
    set = function(info, v)
        local k = info[#info]
        PlexusAutoFrameSize.db.profile[k] = v
        PlexusAutoFrameSize:toggle()
    end,
    childGroups = "tab",
    args = {
        enable = {
            name = "Enable Auto Resizing Note: this will start right away make sure your sizes are right!",
            desc = "Enable Auto Resizing Note: this will start right away make sure your sizes are right!",
            order = 1, width = "double",
            type = "toggle",
        },
        width = {
            name = "Width",
            order = 1,
            type = "group",
            get = function(info)
                local k = info[#info]
                return PlexusAutoFrameSize.db.profile.width[k]
            end,
            set = function(info, v)
                local k = info[#info]
                PlexusAutoFrameSize.db.profile.width[k] = v
            end,
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
            get = function(info)
                local k = info[#info]
                return PlexusAutoFrameSize.db.profile.height[k]
            end,
            set = function(info, v)
                local k = info[#info]
                PlexusAutoFrameSize.db.profile.height[k] = v
            end,
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

(Plexus or PlexusFrame).options.args.PlexusAutoFrameSize = options;

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

  self.super.OnEnable(self)

  self:RegisterMessage("Plexus_EnteringCombat", "InCombat")
  --self:RegisterEvent("PLAYER_REGEN_DISABLED", "InCombat")
  self:RegisterMessage("Plexus_LeavingCombat", "OutofCombat")
  --self:RegisterEvent("PLAYER_REGEN_ENABLED", "InCombat")
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "EnterWorld")

end

function PlexusAutoFrameSize:EnterWorld(event, isLogin, isReload) --luacheck: ignore 212
    --print("EnterWorld")
    --print(event, isLogin, isReload)
    if isLogin then
        if not PlexusAutoFrameSize.db.profile.enable then self:CancelAllTimers() return end
        if PlexusAutoFrameSize.db.profile.enable then
            self:CancelAllTimers()
            self.CheckRosterTimer = self:ScheduleRepeatingTimer("CheckRoster", 2)
        end
    end
end

function PlexusAutoFrameSize:toggle()
    --print("toggle")
    if not PlexusAutoFrameSize.db.profile.enable then self:CancelAllTimers() return end
    if PlexusAutoFrameSize.db.profile.enable then
        self:CancelAllTimers()
        self.CheckRosterTimer = self:ScheduleRepeatingTimer("CheckRoster", 2)
    end
end

function PlexusAutoFrameSize:CheckRoster() --luacheck: ignore 212
    --print("Check roster Running")
    if not PlexusAutoFrameSize.db.profile.enable then return end

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

function PlexusAutoFrameSize:OutofCombat() --luacheck: ignore 212
    --print("Plexus_LeavingCombat")
    --print("OutofCombat: ", InCombatLockdown())
    if not PlexusAutoFrameSize.db.profile.enable then self:CancelAllTimers() return end
    --if InCombatLockdown() ~= 1 then
        --if not self.CheckRosterTimer or self.CheckRosterTimer == 0 then
            self:CancelAllTimers()
            self.CheckRosterTimer = self:ScheduleRepeatingTimer("CheckRoster", 2)
        --end
    --end

end

function PlexusAutoFrameSize:InCombat() --luacheck: ignore 212
    --print("Plexus_EnteringCombat")
    --print("InCombat: ", InCombatLockdown())

    --if InCombatLockdown() == 1 then
        self:CancelAllTimers()
    --end

end

