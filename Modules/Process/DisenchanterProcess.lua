---@class DP_DisenchanterProcess
local DP_DisenchanterProcess = DP_ModuleLoader:CreateModule("DP_DisenchanterProcess")

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

local L = DisenchanterPlus.L
local _G = _G or getfenv()

function DP_DisenchanterProcess:Initialize()
end

function DP_DisenchanterProcess.Process()
  local status = DisenchanterPlus.db.profile.status
  if not status or status == DISENCHANT_PROCESS_STATUS_PAUSED or status == DISENCHANT_PROCESS_STATUS_DISABLED then return end

  DP_Debug("Process... : " .. status)
  local itemToDisenchant, totalNumItems = DP_BagsChecker.GetBagItemProcess()

  if itemToDisenchant == nil or totalNumItems == 0 then
    DP_Debug(string.format("Nothing to disenchant, waiting..."))
  else
    DP_Debug("Item : " .. itemToDisenchant.name .. ", Rest = " .. totalNumItems)
    DP_Debug("     : " .. itemToDisenchant.type .. " - " .. itemToDisenchant.subtype)
  end
end
