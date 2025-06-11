---@class DP_DisenchanterProcess
local DP_DisenchanterProcess = DP_ModuleLoader:CreateModule("DP_DisenchanterProcess")

---@type DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:ImportModule("DP_BagsChecker")

---@type DP_MainWindow
local DP_MainWindow = DP_ModuleLoader:ImportModule("DP_MainWindow")

local L = DisenchanterPlus.L
local _G = _G or getfenv()
local processing = false
local itemToProcess = nil

function DP_DisenchanterProcess.Process()
  local status = DisenchanterPlus.db.profile.status
  if not status or status == DISENCHANT_PROCESS_STATUS_PAUSED or status == DISENCHANT_PROCESS_STATUS_DISABLED then return end

  if processing then
    DP_Debug("Already processing")
    return
  end

  DP_Debug("Process... : " .. status)
  local itemToDisenchant, totalNumItems = DP_BagsChecker.GetBagItemProcess()

  if itemToDisenchant == nil or totalNumItems == 0 then
    DP_Debug(string.format("Nothing to disenchant, waiting..."))
    DP_MainWindow:UpdateItemRemaining(0)
  else
    processing = true
    itemToProcess = itemToDisenchant

    DP_Debug("Item : " .. itemToDisenchant.name .. ", Rest = " .. totalNumItems)
    DP_Debug("     : " .. itemToDisenchant.type .. " - " .. itemToDisenchant.subtype)

    -- show window
    DP_MainWindow:ShowMainWindow()

    -- update items
    DP_MainWindow:UpdateItemSelected(itemToDisenchant)
    DP_MainWindow:UpdateDisenchantText(string.format("|c%s%s|r", DisenchanterPlus.onColor, L
    ["Item can be disenchanted."]))
    DP_MainWindow:UpdateItemRemaining(totalNumItems)

    -- enable buttons
    DP_MainWindow:ToggleIgnoreButton(true)
    DP_MainWindow:ToggleSkipButton(true)
    DP_MainWindow:ToggleProceedButton(true)
  end
end

---Get item to process
---@return table|nil
function DP_DisenchanterProcess.GetItemToProcess()
  return itemToProcess
end

---Remove item to process
function DP_DisenchanterProcess.RemoveItemToProcess()
  itemToProcess = nil
  processing = false
end
