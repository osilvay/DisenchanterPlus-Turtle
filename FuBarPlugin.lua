if not DisenchanterPlus then return end

local dewdrop = AceLibrary("Dewdrop-2.0")
local L = DisenchanterPlus.L

DisenchanterPlusFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")
DisenchanterPlusFu:RegisterDB("DisenchanterPlusDB")
DisenchanterPlusFu.hasIcon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus"
DisenchanterPlusFu.defaultMinimapPosition = 180
DisenchanterPlusFu.cannotDetachTooltip = true
DisenchanterPlusFu.independentProfile = true
DisenchanterPlusFu.hideWithoutStandby = true

local fuMenu = {
}

function DisenchanterPlusFu:OnMenuRequest(level, value, x, valueN_1, valueN_2, valueN_3, valueN_4)
  fuMenu = {
    ["L1"] = {
      {
        "text", L["Title"],
        "isTitle", true
      },
      {
        "text", L["Version"] .. " : " .. DisenchanterPlus.version,
        "notClickable", true
      },
      {},
      {
        "text", L["Status"] .. " : " .. DisenchanterPlusFu:GetStatus(),
        "notClickable", true,
      },
      {
        "text", L["Debug"] .. " : " .. DisenchanterPlusFu:GetDebug(),
        "notClickable", false,
        "func", DisenchanterPlusFu.changeDebugMode,
        "arg1", "toggle",
        "arg2", "debug"
      },
    },
  }
  DisenchanterPlusFu.updateStatusIcon()
  DisenchanterPlusFu.createDDMenu(level, value, true)
  if (level == 1) then
    dewdrop:AddLine()
  end
end

---Create Dropdown menu
---@param level string
---@param menu string
---@param skipfirst boolean
function DisenchanterPlusFu.createDDMenu(level, menu, skipfirst)
  if (level == 1) then
    for k, v in ipairs(fuMenu["L1"]) do
      if (k == 1 and not skipfirst or k > 1) then
        if (type(v) == "table") then
          dewdrop:AddLine(unpack(v))
        end
      end
    end
  end
end

---Get addon status
function DisenchanterPlusFu:GetDebug()
  if not DisenchanterPlus.db.profile then return string.format("|c%s%s|r", DisenchanterPlus.unknownColor, "-") end
  if DisenchanterPlus.db.profile.debug == nil then DisenchanterPlus.db.profile.debug = "off" end
  if DisenchanterPlus.db.profile.debug == "on" then
    return string.format("|c%s%s|r", DisenchanterPlus.onColor, "on")
  end
  return string.format("|c%s%s|r", DisenchanterPlus.offColor, "off")
end

---Get addon status
function DisenchanterPlusFu:GetStatus()
  if not DisenchanterPlus.db.profile then return string.format("|c%s%s|r", DisenchanterPlus.unknownColor, "-") end
  if DisenchanterPlus.db.profile.status == nil then DisenchanterPlus.db.profile.status = "stopped" end
  if DisenchanterPlus.db.profile.status == "running" then
    return string.format("|c%s%s|r", DisenchanterPlus.onColor, "running")
  elseif DisenchanterPlus.db.profile.status == "paused" then
    return string.format("|c%s%s|r", DisenchanterPlus.pausedColor, "paused")
  end
  return string.format("|c%s%s|r", DisenchanterPlus.offColor, "stopped")
end

---Change debug mode
function DisenchanterPlusFu.changeDebugMode()
  if not DisenchanterPlus.db.profile then return end
  if DisenchanterPlus.db.profile.debug == nil or DisenchanterPlus.db.profile.debug == "on" then
    DisenchanterPlus.db.profile.debug = "off"
  elseif DisenchanterPlus.db.profile.debug == "off" then
    DisenchanterPlus.db.profile.debug = "on"
  end
end

---Change status
function DisenchanterPlusFu.updateStatusIcon()
  local icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus"
  if DisenchanterPlus.db.profile.status == "running" then
    icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_running"
  elseif DisenchanterPlus.db.profile.status == "paused" then
    icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_paused"
  elseif DisenchanterPlus.db.profile.status == "stopped" then
    icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_disabled"
  end
  DisenchanterPlusFu:SetIcon(icon)
end
