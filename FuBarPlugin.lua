if not DisenchanterPlus then return end

---@type DP_Timers
local DP_Timers = DP_ModuleLoader:ImportModule("DP_Timers")

local dewdrop = AceLibrary("Dewdrop-2.0")
local tablet = AceLibrary("Tablet-2.0")

local L = DisenchanterPlus.L

DisenchanterPlusFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")
DisenchanterPlusFu:RegisterDB("DisenchanterPlusDB")
DisenchanterPlusFu.hasIcon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_disabled"
DisenchanterPlusFu.defaultMinimapPosition = 180
DisenchanterPlusFu.clickableTooltip = true
DisenchanterPlusFu.hideWithoutStandby = true

local fuMenu = {
}

function DisenchanterPlusFu:OnClick()
  _DP_MainWindow.showMainWindow()
end

function DisenchanterPlusFu:OnTooltipUpdate()
  tablet:SetTitle("|cffe1e1e1Disenchanter|r|cffed6bffPlus|r |cff919191" .. DisenchanterPlus.version .. "|r")
  tablet:SetTitle(DisenchanterPlus.addonColoredName .. " " .. string.format("|c%s%s|r", DisenchanterPlus.versionColor,
    DisenchanterPlus.addonVersion .. "|r"))

  local category = tablet:AddCategory(
    "columns", 2,
    "justify", "LEFT",
    "justify2", "RIGHT",
    "hideBlankLine", true,
    "showWithoutChildren", false,
    "child_textR", 1,
    "child_textG", 1,
    "child_textB", 1
  )
  category:AddLine()
  category:AddLine(
    "text", L["Status"],
    "text2", DisenchanterPlusFu:GetStatus(),
    "func", DisenchanterPlusFu.changeStatus
  )
  category:AddLine(
    "text", L["Debug"],
    "text2", DisenchanterPlusFu:GetDebug(),
    "func", DisenchanterPlusFu.changeDebugMode
  )

  tablet:SetHint(L["Click to open the DisenchanterPlus frame."])
end

function DisenchanterPlusFu:OnMenuRequest(level, value, x, valueN_1, valueN_2, valueN_3, valueN_4)
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
  fuMenu = DisenchanterPlusFu.getMenu()
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
  --if not DisenchanterPlus.db.char then return string.format("|c%s%s|r", DisenchanterPlus.unknownColor, "-") end
  if _AP_Database.GetCharValue("debug") == nil then _AP_Database.SetCharValue("debug", "off") end
  if _AP_Database.GetCharValue("debug") == "on" then
    return string.format("|c%s%s|r", DisenchanterPlus.onColor, "on")
  end
  return string.format("|c%s%s|r", DisenchanterPlus.offColor, "off")
end

---Get addon status
function DisenchanterPlusFu:GetStatus()
  --if not DisenchanterPlus.db.char then return string.format("|c%s%s|r", DisenchanterPlus.unknownColor, "-") end
  if _AP_Database.GetCharValue("status") == nil then _AP_Database.SetCharValue("status", DISENCHANT_PROCESS_STATUS_DISABLED) end
  if _AP_Database.GetCharValue("status") == DISENCHANT_PROCESS_STATUS_RUNNING then
    return string.format("|c%s%s|r", DisenchanterPlus.onColor, DISENCHANT_PROCESS_STATUS_RUNNING)
  elseif _AP_Database.GetCharValue("status") == DISENCHANT_PROCESS_STATUS_PAUSED then
    return string.format("|c%s%s|r", DisenchanterPlus.pausedColor, DISENCHANT_PROCESS_STATUS_PAUSED)
  end
  return string.format("|c%s%s|r", DisenchanterPlus.offColor, DISENCHANT_PROCESS_STATUS_DISABLED)
end

---Change debug mode
function DisenchanterPlusFu.changeDebugMode()
  --if not DisenchanterPlus.db.char then return end
  if _AP_Database.GetCharValue("debug") == nil or _AP_Database.GetCharValue("debug") == "on" then
    _AP_Database.SetCharValue("debug", "off")
  elseif _AP_Database.GetCharValue("debug") == "off" then
    _AP_Database.SetCharValue("debug", "on")
  end
end

function DisenchanterPlusFu.changeStatus()
  _DP_MainWindow.togglStatusButton()
end

---Change status
function DisenchanterPlusFu.updateStatusIcon()
  local icon
  local currentStatus = _AP_Database.GetCharValue("status") or DISENCHANT_PROCESS_STATUS_DISABLED
  if currentStatus == DISENCHANT_PROCESS_STATUS_RUNNING then
    icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_running"
  elseif currentStatus == DISENCHANT_PROCESS_STATUS_PAUSED then
    icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_paused"
  else
    icon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus_disabled"
    _AP_Database.SetCharValue("status", DISENCHANT_PROCESS_STATUS_DISABLED)
  end
  DisenchanterPlusFu:SetIcon(icon)
end

---Open main window
function DisenchanterPlusFu.showMainWindow()
  DisenchanterPlus:ShowMainWindow()
end

function DisenchanterPlusFu:GetUpdateTime()
  return _AP_Database.GetCharValue("updateTime") or 5
end

function DisenchanterPlusFu.changeUpdateTime(type, key, value)
  _AP_Database.SetCharValue("updateTime", tonumber(value))
  DP_Timers:Stop(_DP_EventManager.ProcessTimer)
  DP_Timers:Start(_DP_EventManager.ProcessTimer)
end

---Get menu data
---@return table
function DisenchanterPlusFu.getMenu()
  return {
    ["L1"] = {
      {
        "text", "|cffe1e1e1Disenchanter|r|cffed6bffPlus|r|cff919191" .. DisenchanterPlus.version .. "|r",
        "isTitle", true
      },
      {},
      {
        "text", L["Status"] .. " : " .. DisenchanterPlusFu:GetStatus(),
        "notClickable", true,
      },
      {
        "text", L["Update time"] .. " : (|cFFFFE431" .. DisenchanterPlusFu:GetUpdateTime() .. ")|r",
        "tooltipTitle", L["Update time"],
        "tooltipText", L["Update time"],
        "hasArrow", true,
        "hasSlider", true,
        "sliderMin", 1,
        "sliderMax", 10,
        "sliderStep", 1,
        "sliderValue", DisenchanterPlusFu:GetUpdateTime(),
        "sliderFunc", DisenchanterPlusFu.changeUpdateTime,
        "sliderArg1", "set",
        "sliderArg2", "updateTime",
        "sliderArg3", self.name
      },
      {
        "text", L["Debug"] .. " : " .. DisenchanterPlusFu:GetDebug(),
        "notClickable", false,
        "func", DisenchanterPlusFu.changeDebugMode,
        "arg1", "toggle",
        "arg2", "debug"
      },
      --[[{
        "text", L["Open main window"],
        "notClickable", false,
        "func", DisenchanterPlusFu.showMainWindow,
      },]]
    },
  }
end
