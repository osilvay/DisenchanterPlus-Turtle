DisenchanterPlus = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1", "AceConsole-2.0", "AceDB-2.0", "AceModuleCore-2.0", "AceDebug-2.0", "Metrognome-2.0")
DisenchanterPlus.L = AceLibrary("AceLocale-2.2"):new("DisenchanterPlus")

DisenchanterPlus.version = "0.0.0.1"
DisenchanterPlus.addonColor = "ffed6bff"
DisenchanterPlus.errorColor = "FFFC6B6B"
DisenchanterPlus.warnColor = "FFFFAD6E"
DisenchanterPlus.infoColor = "FF86C9FC"
DisenchanterPlus.debugColor = "FFFFFF67"
DisenchanterPlus.logColor = "FFC1C1C1"
DisenchanterPlus.timeColor = "FFB2FC86"
DisenchanterPlus.onColor = "FF46FF31"
DisenchanterPlus.offColor = "FFFF3131"
DisenchanterPlus.pausedColor = "FFFFE431"
DisenchanterPlus.unknownColor = "FF919191"

DisenchanterPlus:RegisterDB("DisenchanterPlusDB")
DisenchanterPlus:RegisterDefaults("profile", {
  debug = "off",
  status = "stopped"
})

---Print
function DisenchanterPlus:Print(message)
  local finalMessage = string.format("|c%sDP|r: %s", DisenchanterPlus.addonColor, message)
  DEFAULT_CHAT_FRAME:AddMessage(finalMessage)
end

---Error message
function DisenchanterPlus:Error(message)
  DisenchanterPlus:Print(string.format("|c%s[ERROR]|r %s", DisenchanterPlus.errorColor, message))
end

---Warning message
function DisenchanterPlus:Warning(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[WARNING]|r %s", DisenchanterPlus.errorColor, message))
  end
end

---Info message
function DisenchanterPlus:Info(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[INFO]|r %s", DisenchanterPlus.errorColor, message))
  end
end

---Debug message
function DisenchanterPlus:Debug(message)
  if DisenchanterPlus:IsDebugEnabled() then
    if message == nil then message = 'nil' end
    DisenchanterPlus:Print(string.format("|c%s[DEBUG]|r %s", DisenchanterPlus.errorColor, message))
  end
end

---Log message
function DisenchanterPlus:Log(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[LOG]|r %s", DisenchanterPlus.errorColor, message))
  end
end

---Log message
function DisenchanterPlus:Time(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[TIME]|r %d : %s ", DisenchanterPlus.timeColor, GetServerTime(), message))
  end
end

---Check debug enabled
function DisenchanterPlus:IsDebugEnabled()
  if DisenchanterPlus.db.profile.debug == "on" then
    return true
  end
  return false
end
