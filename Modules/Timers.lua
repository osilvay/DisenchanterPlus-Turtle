---@class DP_Timers
local DP_Timers = DP_ModuleLoader:CreateModule("DP_Timers")

---@type DP_EventManager
local DP_EventManager = DP_ModuleLoader:ImportModule("DP_EventManager")

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

---@type DP_DisenchanterProcess
local DP_DisenchanterProcess = DP_ModuleLoader:ImportModule("DP_DisenchanterProcess")

local metro = AceLibrary("Metrognome-2.0")

function DP_Timers:Initialize()
  -- initializer timer
  if (not metro:MetroStatus("DisenchanterPlusInitializerTimer")) then
    metro:RegisterMetro("DisenchanterPlusInitializerTimer", DP_EventManager.Initialize, 1)
  end
  metro:Start("DisenchanterPlusInitializerTimer", 1)
end

---Start metro
---@param metroToStart string
---@param executions number|nil
function DP_Timers:Start(metroToStart, executions)
  if executions ~= nil then
    DP_Debug(string.format("Starting metro: %s with %s executions", metroToStart, tostring(executions)))
  end
  DP_Debug(string.format("Starting metro: %s", metroToStart))
  metro:Start(metroToStart, executions)
end

---Register metro
---@param metroToRegister string
---@param interval number
---@param autostart boolean
---@param executions number|nil
function DP_Timers:Register(metroToRegister, interval, autostart, executions)
  if (not metro:MetroStatus(metroToRegister)) then
    DP_Debug(string.format("Registering metro: %s each %s seconds", metroToRegister, tostring(interval)))
    metro:RegisterMetro(metroToRegister, DP_DisenchanterProcess.Process, interval)
  end
  if autostart then
    DP_Timers:Start(metroToRegister, executions)
  end
end

DP_Timers:Initialize()
