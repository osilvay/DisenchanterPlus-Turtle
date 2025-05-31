---@class DP_Timers
local DP_Timers = DP_ModuleLoader:CreateModule("DP_Timers")

---@type DP_EventManager
local DP_EventManager = DP_ModuleLoader:ImportModule("DP_EventManager")

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

local metro = AceLibrary("Metrognome-2.0")

function DP_Timers:Initialize()
  if (not metro:MetroStatus("BagCheckerTimer")) then
    metro:RegisterMetro("BagCheckerTimer", DP_BagsChecker.CheckBagItemProcess, 5)
  end
  if (not metro:MetroStatus("DisenchanterPlusInitializer")) then
    metro:RegisterMetro("DisenchanterPlusInitializer", DP_EventManager.Initialize, 1)
  end
  metro:Start("DisenchanterPlusInitializer", 1)
end

DP_Timers:Initialize()
