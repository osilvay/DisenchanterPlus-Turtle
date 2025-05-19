local L = DisenchanterPlus.L

local options = {
  type = 'group',
  args = {
    config = {
      type = 'execute',
      name = L['config'],
      desc = L["Shows the config window"],
      func = function() return end
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

DisenchanterPlus:RegisterChatCommand({ "/DisenchanterPlus", "/dplus" }, options, "DISENCHANTERPLUS")
