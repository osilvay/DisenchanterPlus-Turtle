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
  DP_Debug("Event manager initialized")
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
