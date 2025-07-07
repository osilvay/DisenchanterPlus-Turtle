DisenchanterPlus = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1", "AceConsole-2.0", "AceDB-2.0",
  "AceModuleCore-2.0", "AceDebug-2.0", "Metrognome-2.0")
DisenchanterPlus.L = AceLibrary("AceLocale-2.2"):new("DisenchanterPlus")

local defaults_realm = {
  chars = {},
  global = {},
  version = nil
}
local defaults_char = {
  debug = "off",
  status = "stopped",
  uncommon = false,
  rare = false,
  epic = false,
  updateTime = 4,
  temporalIgnoredItems = {},
  permanentIgnoredItems = {}
}
DISENCHANT_PROCESS_STATUS_RUNNING = "running"
DISENCHANT_PROCESS_STATUS_PAUSED = "paused"
DISENCHANT_PROCESS_STATUS_DISABLED = "disabled"
DISENCHANT_PROCESS_STATUS_PROCESSING = "processing"

---On intinialize
function DisenchanterPlus:OnInitialize()
  self:RegisterDB("DisenchanterPlusDB")

  self.errorColor = "FFFC6B6B"
  self.warnColor = "FFFFAD6E"
  self.infoColor = "FF86C9FC"
  self.debugColor = "FFFFFF67"
  self.logColor = "FFC1C1C1"
  self.timeColor = "FFB2FC86"
  self.onColor = "FF59EE49"
  self.offColor = "FFF44444"
  self.pausedColor = "FFFFE431"
  self.unknownColor = "FF919191"
  self.versionColor = "FF619191"
  self.textColor = "FFe1e1e1"
  self.addonColor = "FFED6BFF"
  self.addonName = "DisenchanterPlus"
  self.addonVersion = "0.0.1"
  self.addonColoredName = string.format("|c%sDisenchanter|r |c%sPlus|r", self.textColor, self.addonColor)

  local realmName = GetRealmName()
  local name = UnitName("player")
  local className, classFilename, classId = UnitClass("player")
  local raceName = UnitRace("player")
  local level = UnitLevel("player")
  local factionName = UnitFactionGroup("player")
  local locale = GetLocale()
  local charKey = name .. " of " .. realmName
  local realmKey = realmName .. " - " .. factionName
  local info = {
    realmName = realmName,
    name = name,
    level = level,
    className = className,
    classFilename = classFilename,
    classId = classId,
    raceName = raceName,
    factionName = factionName,
    locale = locale,
    characterKey = charKey,
    realmKey = realmKey
  }
  self.info = info

  if not DisenchanterPlusDB["realms"] then
    DisenchanterPlusDB["realms"] = {}
  end
  if not DisenchanterPlusDB["realms"][realmKey] then
    DisenchanterPlusDB["realms"][realmKey] = defaults_realm
  end

  if not DisenchanterPlusDB["chars"] then
    DisenchanterPlusDB["chars"] = {}
  end
  if not DisenchanterPlusDB["chars"][charKey] then
    DisenchanterPlusDB["chars"][charKey] = defaults_char
  end

  DisenchanterPlusDB["realms"][realmKey]["version"] = self.addonVersion
  DisenchanterPlusDB["realms"][realmKey]["chars"][charKey] = true
  DisenchanterPlusDB["chars"][charKey].info = info
end

---Print
---@param message string
---@param withoutHeader? boolean
function DisenchanterPlus:Print(message, withoutHeader)
  local finalMessage
  if withoutHeader then
    finalMessage = string.format("%s", tostring(message))
  else
    finalMessage = string.format("|c%sDP|r: %s", DisenchanterPlus.addonColor, tostring(message) or "nil")
  end

  DEFAULT_CHAT_FRAME:AddMessage(finalMessage)
end

function print(message)
  DP_Print(message)
end

function DP_Print(message)
  DisenchanterPlus:Print(message)
end

---Error message
function DisenchanterPlus:Error(message)
  DisenchanterPlus:Print(string.format("|c%s[ERROR]|r %s", DisenchanterPlus.errorColor, tostring(message)))
end

function DP_Error(message)
  DisenchanterPlus:Error(message)
end

---Warning message
function DisenchanterPlus:Warning(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[WARNING]|r %s", DisenchanterPlus.errorColor, tostring(message)))
  end
end

function DP_Warning(message)
  DisenchanterPlus:Warning(message)
end

---Info message
function DisenchanterPlus:Info(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[INFO]|r %s", DisenchanterPlus.errorColor, tostring(message)))
  end
end

function DP_Info(message)
  DisenchanterPlus:Info(message)
end

---Debug message
function DisenchanterPlus:Debug(message)
  if DisenchanterPlus:IsDebugEnabled() then
    if message == nil then message = 'nil' end
    DisenchanterPlus:Print(string.format("|c%s[DEBUG]|r %s", DisenchanterPlus.errorColor, tostring(message)))
  end
end

function DP_Debug(message)
  DisenchanterPlus:Debug(message)
end

---Log message
function DisenchanterPlus:Log(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[LOG]|r %s", DisenchanterPlus.errorColor, message))
  end
end

function DP_Log(message)
  DisenchanterPlus:Log(message)
end

---Log message
function DisenchanterPlus:Time(message)
  if DisenchanterPlus:IsDebugEnabled() then
    DisenchanterPlus:Print(string.format("|c%s[TIME]|r %d : %s ", DisenchanterPlus.timeColor, GetServerTime(), message))
  end
end

function DP_Time(message)
  DisenchanterPlus:Time(message)
end

function DisenchanterPlus:Dump(message)
  if DisenchanterPlus:IsDebugEnabled() then
    if message == nil then
      DisenchanterPlus:Print(string.format("|c%s[DUMP]|r : %s ", DisenchanterPlus.unknownColor, "nil"))
    end
    DisenchanterPlus:Print(string.format("|c%s[DUMP]|r : ", DisenchanterPlus.unknownColor))
    DisenchanterPlus:ComposeDump(message, 0)
  end
end

function DP_Dump(message)
  DisenchanterPlus:Dump(message)
end

---Compose dump
---@param o table
---@param iteration number
function DisenchanterPlus:ComposeDump(o, iteration)
  if o == nil then
    DisenchanterPlus:Print("nil", true)
  elseif type(o) == 'table' then
    DisenchanterPlus:Print(string.rep(" ", iteration) .. '{', true)
    for k, v in pairs(o) do
      DisenchanterPlus:Print(string.rep(" ", iteration) .. '[' .. k .. '] = ', true)
      DisenchanterPlus:ComposeDump(v, iteration + 2)
    end
    DisenchanterPlus:Print(string.rep(" ", iteration) .. '}', true)
  elseif type(o) == 'string' then
    DisenchanterPlus:Print(string.rep(" ", iteration) .. '"' .. tostring(o) .. '"', true)
  else
    DisenchanterPlus:Print(string.rep(" ", iteration) .. tostring(o), true)
  end
end

---Check debug enabled
function DisenchanterPlus:IsDebugEnabled()
  if _AP_Database.GetCharValue("debug") == "on" then
    return true
  end
  return false
end

---Get class color
---@param classFilename string
---@return number
---@return number
---@return number
---@return string
function GetClassColor(classFilename)
  local color = RAID_CLASS_COLORS[string.upper(classFilename)];
  if color then
    return color.r, color.g, color.b, color.colorStr;
  end
  return 1, 1, 1, "ffffffff";
end

function GetCreatureDifficultyColor(level)
  return GetRelativeDifficultyColor(UnitLevel("player"), level);
end

QuestDifficultyColors = {
  ["impossible"]    = "ffff3010",
  ["verydifficult"] = "ffff8040",
  ["difficult"]     = "ffffff00",
  ["standard"]      = "ff40c040",
  ["trivial"]       = "ff808080",
};

ItemQualityColors = {
  [0] = "ff9d9d9d",
  [1] = "ffffffff",
  [2] = "ff1eff00",
  [3] = "ff0070dd",
  [4] = "ffa335ee",
  [5] = "ffff8000",
  [6] = "ffe6cc80",
  [7] = "ffe6cc80",
  [8] = "ff00ccff"
}

function GetRelativeDifficultyColor(unitLevel, challengeLevel)
  local levelDiff = challengeLevel - unitLevel;
  --DP_Debug(tostring(levelDiff))

  if (levelDiff >= 5) then
    return QuestDifficultyColors["impossible"];
  elseif (levelDiff >= 3) then
    return QuestDifficultyColors["verydifficult"];
  elseif (levelDiff >= -2) then
    return QuestDifficultyColors["difficult"];
  elseif (levelDiff >= -8) then
    return QuestDifficultyColors["standard"];
  else
    return QuestDifficultyColors["trivial"];
  end
end
