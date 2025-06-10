---@class DP_EventManager
local DP_EventManager = DP_ModuleLoader:CreateModule("DP_EventManager")

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

---@type DP_Timers
local DP_Timers = DP_ModuleLoader:ImportModule("DP_Timers")

function DP_EventManager.Initialize()
  DP_Debug("Event manager initialized")
  DisenchanterPlusFu.updateStatusIcon()

  DisenchanterPlus:RegisterEvent("PLAYER_TARGET_CHANGED", DP_EventManager.PlayerTargetChanged)
  DisenchanterPlus:RegisterEvent("LOOT_OPENED", DP_EventManager.LootOpened)
  DisenchanterPlus:RegisterEvent("LOOT_CLOSED", DP_EventManager.LootClosed)
  DisenchanterPlus:RegisterEvent("LOOT_SLOT_CLEARED", DP_EventManager.LootSlotCleared)
  DisenchanterPlus:RegisterEvent("BAG_UPDATE", DP_EventManager.BagUpdate)

  local interval = tonumber(DisenchanterPlus.db.profile.updateTime) or 60
  DP_Timers:Register("DisenchanterPlusProcessTimer", interval, true, nil)
  --DP_BagsChecker:GetItemFromBags()
end

DP_Target = {}
---Player target changed event
function DP_EventManager:PlayerTargetChanged()
  local name = UnitName("target")
  local level = UnitLevel("target")
  if name == nil or level == nil then return end

  local className, r, g, b, classColor
  local difficultColor = GetCreatureDifficultyColor(level)

  if UnitIsPlayer("target") then
    className = UnitClass("target")
    r, g, b, classColor = GetClassColor(className)
  elseif UnitCanAttack("player", "target") then
    className = "Enemy"
    classColor = "ffcc7777"
  else
    className = "NPC"
    classColor = "ff77cc77"
  end

  if name ~= nil then
    DP_Target = {
      name = level,
      level = level,
      class = className,
    }
    DP_Debug("Target changed: |c" .. difficultColor .. level .. "|r |cffb5d0de" .. name .. "|r |c" .. classColor .. className .. "|r")
  end
end

function DP_EventManager:LootOpened()
end

function DP_EventManager:LootClosed()
end

function DP_EventManager:LootSlotCleared()
end

function DP_EventManager:BagUpdate()
end
