local options = {
  type = 'group',
  args = {
    show = {
      type = 'execute',
      name = L['show'],
      desc = L["Shows the UI"],
      func = function() return end
    },
    hide = {
      type = 'execute',
      name = L['hide'],
      desc = L["Hides the UI"],
      func = function() return end
    },
  }
}


DisenchanterPlus = LibStub("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1", "AceConsole-2.0", "AceDB-2.0", "AceModuleCore-2.0", "AceDebug-2.0", "Metrognome-2.0")
DisenchanterPlus:RegisterChatCommand({ "/DisenchanterPlus", "/dp" }, options)
DisenchanterPlus:RegisterDB("DisenchanterPlusDB")
DisenchanterPlus.version = "0.0.0.1"
DisenchanterPlus.addonColor = "ffed6bff"

local L = LibStub("AceLocale-2.2"):new("DisenchanterPlus")
