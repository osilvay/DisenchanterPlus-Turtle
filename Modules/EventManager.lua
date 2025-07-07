---@class DP_EventManager
local DP_EventManager = DP_ModuleLoader:CreateModule("DP_EventManager")
_DP_EventManager = {}

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

---@type DP_Timers
local DP_Timers = DP_ModuleLoader:ImportModule("DP_Timers")

---@type DP_DisenchanterProcess
local DP_DisenchanterProcess = DP_ModuleLoader:ImportModule("DP_DisenchanterProcess")

_DP_EventManager.ProcessTimer = "DisenchanterPlusProcessTimer"
_DP_EventManager.DisenchantTimer = "DisenchanterPlusDisenchantTimer"
_DP_EventManager.IsMovingTimer = "DisenchanterPlusIsMovingTimer"

function DP_EventManager.Initialize()
  DP_Print("DP_EventManager.Initialize")

  DP_EventManager:DatabaseSetup()
  DisenchanterPlusFu.updateStatusIcon()

  DisenchanterPlus:RegisterEvent("LOOT_OPENED", DP_EventManager.LootOpened)
  DisenchanterPlus:RegisterEvent("LOOT_CLOSED", DP_EventManager.LootClosed)
  DisenchanterPlus:RegisterEvent("LOOT_SLOT_CLEARED", DP_EventManager.LootSlotCleared)
  DisenchanterPlus:RegisterEvent("BAG_UPDATE", DP_EventManager.BagUpdate)

  local interval = _AP_Database.GetCharValue("updateTime") or 60
  DP_Timers:Register(_DP_EventManager.ProcessTimer, interval, true, nil, DP_DisenchanterProcess.Process)
  DP_Timers:Register(_DP_EventManager.DisenchantTimer, 3.8, false, 1, DP_DisenchanterProcess.Disenchanted)
  DP_Timers:Register(_DP_EventManager.IsMovingTimer, 0.2, false, nil, _DP_MainWindow.isMoving)

  _AP_Database.SetCharValue("temporalIgnoredItems", {})
  if _AP_Database.GetCharValue("permanentIgnoredItems") == nil then
    _AP_Database.SetCharValue("permanentIgnoredItems", {})
  end
  _AP_Database.SetCharValue("permanentIgnoredItems", {})
end

function DP_EventManager:LootOpened()
end

function DP_EventManager:LootClosed()
end

function DP_EventManager:LootSlotCleared()
end

function DP_EventManager:BagUpdate(event, bagID)
  DP_DisenchanterProcess.Process()
end

function DP_EventManager:DatabaseSetup()
  --DP_Print("DP_EventManager:DatabaseSetup")
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
  DisenchanterPlus.info = info

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

  DisenchanterPlusDB["realms"][realmKey]["version"] = DisenchanterPlus.addonVersion
  DisenchanterPlusDB["realms"][realmKey]["chars"][charKey] = true
  DisenchanterPlusDB["chars"][charKey].info = info
end
