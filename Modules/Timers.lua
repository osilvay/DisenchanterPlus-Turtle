---@class DP_Timers
local DP_Timers = DP_ModuleLoader:CreateModule("DP_Timers")

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

local metro = AceLibrary("Metrognome-2.0")

function DP_Timers:Initialize()
  if (not metro:MetroStatus("BagCheckerTimer")) then
    metro:RegisterMetro("BagCheckerTimer", DisenchanterPlus.CheckBags, 5)
  end
end
