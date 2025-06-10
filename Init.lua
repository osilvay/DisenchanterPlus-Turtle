local L = DisenchanterPlus.L
local dewdrop = AceLibrary:GetInstance("Dewdrop-2.0")
local ddframe

local options = {
  type = 'group',
  args = {
    show = {
      type = 'execute',
      name = L['show'],
      desc = L["Open main window"],
      func = function()
        _DP_MainWindow.showMainWindow()
      end
    },
    config = {
      type = 'execute',
      name = L['config'],
      desc = L["Open settings window"],
      func = function()
        DisenchanterPlus:OpenDropdownMenu()
      end
    },
    debug = {
      type = "text",
      name = "debug",
      desc = L["Enable/Disable debug"],
      get = function()
        local debug = DisenchanterPlus.db.profile.debug
        if debug == "on" then
          return "|c" .. DisenchanterPlus.onColor .. debug .. "|r"
        else
          return "|c" .. DisenchanterPlus.offColor .. debug .. "|r"
        end
      end,
      set = function(v)
        DisenchanterPlus.db.profile.debug = v
      end,
      validate = { "off", "on" },
      order = -2,
    }
  }
}

function DisenchanterPlus:OpenDropdownMenu()
  if not ddframe then
    ddframe = CreateFrame("Frame", nil, UIParent)
    ddframe:SetWidth(2)
    ddframe:SetHeight(2)
    ddframe:SetPoint("BOTTOMLEFT", GetCursorPosition())
    ddframe:SetClampedToScreen(true)
    dewdrop:Register(ddframe, 'dontHook', true, 'children', DisenchanterPlusFu.createDDMenu)
  end
  local x, y = GetCursorPosition()
  ddframe:SetPoint("BOTTOMLEFT", x / UIParent:GetScale(), y / UIParent:GetScale())
  dewdrop:Open(ddframe)
end

DisenchanterPlus:RegisterChatCommand({ "/DisenchanterPlus", "/dplus" }, options, "DISENCHANTERPLUS")
