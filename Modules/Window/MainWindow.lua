---@class DP_MainWindow
local DP_MainWindow = DP_ModuleLoader:CreateModule("DP_MainWindow")
_DP_MainWindow = {}

---@type DP_DisenchanterProcess
local DP_DisenchanterProcess = DP_ModuleLoader:ImportModule("DP_DisenchanterProcess")

---@type DP_CommonFunctions
local DP_CommonFunctions = DP_ModuleLoader:ImportModule("DP_CommonFunctions")

local L = DisenchanterPlus.L
local QUALITY_TEXTURE_SELECTED = "Interface\\AddOns\\DisenchanterPlus-Turtle\\Images\\Qualities\\%s_selected"
local QUALITY_TEXTURE_NORMAL = "Interface\\AddOns\\DisenchanterPlus-Turtle\\Images\\Qualities\\%s"

---Close main window
function _DP_MainWindow.closeMainWindow()
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\CharacterSheetClose.ogg", "master")
  DisenchanterPlusHeaderFrame:Hide()
end

function DP_MainWindow:CloseMainWindow()
  if DisenchanterPlusHeaderFrame:IsShown() then
    DP_MainWindow:ToggleIgnoreButton(false)
    DP_MainWindow:ToggleSkipButton(false)
    DP_MainWindow:ToggleProceedButton(false)
    DP_DisenchanterProcess.RemoveItemToProcess()

    DP_MainWindow:UpdateItemRemaining(0)
    DP_MainWindow:UpdateDisenchantText(string.format("|c%s%s|r", DisenchanterPlus.errorColor,
      L["Waiting an item to disenchant..."]))

    DisenchanterPlusItemFrame_Texture:SetTexture("")
    DisenchanterPlusFrame_ItemName:SetText("")

    _DP_MainWindow.closeMainWindow()
  end
end

---Show main window
function _DP_MainWindow.showMainWindow()
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\CharacterSheetOpen.ogg", "master")
  DP_MainWindow:UpdateButtonStatus()
  DisenchanterPlusHeaderFrame:Show()
end

function DP_MainWindow:ShowMainWindow()
  if not DisenchanterPlusHeaderFrame:IsShown() then
    _DP_MainWindow.showMainWindow()
  end
end

function _DP_MainWindow.updateButtonStatus()
  DP_MainWindow:UpdateButtonStatus()
end

---Update button status
function DP_MainWindow:UpdateButtonStatus()
  local epic_status = DisenchanterPlus.db.profile.epic or false
  local rare_status = DisenchanterPlus.db.profile.rare or false
  local uncommon_status = DisenchanterPlus.db.profile.uncommon or false

  DP_MainWindow:CheckStatusButton()
  DP_MainWindow:CheckQualityButton(DisenchanterPlusHeaderFrame_QualityEpicButton, epic_status, "epic")
  DP_MainWindow:CheckQualityButton(DisenchanterPlusHeaderFrame_QualityRareButton, rare_status, "rare")
  DP_MainWindow:CheckQualityButton(DisenchanterPlusHeaderFrame_QualityUncommonButton, uncommon_status, "uncommon")
end

---Toggle epic button
function _DP_MainWindow.toggleEpicButton()
  local status = DisenchanterPlus.db.profile.epic
  if not status or status == false then
    DisenchanterPlus.db.profile.epic = true
  else
    DisenchanterPlus.db.profile.epic = false
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\ChatScrollButton.ogg", "master")
  DP_MainWindow:UpdateButtonStatus()
end

---Toggle rare button
function _DP_MainWindow.toggleRareButton()
  local status = DisenchanterPlus.db.profile.rare
  if not status or status == false then
    DisenchanterPlus.db.profile.rare = true
  else
    DisenchanterPlus.db.profile.rare = false
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\ChatScrollButton.ogg", "master")
  DP_MainWindow:UpdateButtonStatus()
end

---Toggle uncommon button
function _DP_MainWindow.toggleUncommonButton()
  local status = DisenchanterPlus.db.profile.uncommon
  if not status or status == false then
    DisenchanterPlus.db.profile.uncommon = true
  else
    DisenchanterPlus.db.profile.uncommon = false
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\ChatScrollButton.ogg", "master")
  DP_MainWindow:UpdateButtonStatus()
end

---Toggle ignore list
function _DP_MainWindow.toggleIgnoreListCheckButton()
  if DisenchanterPlusFrame_IgnoreListCheckButton:GetChecked() then
    PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\ChatScrollButton.ogg", "master")
    DisenchanterPlusIgnoreFrame:Show()
  else
    PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\TabChange.ogg", "master")
    DisenchanterPlusIgnoreFrame:Hide()
  end
end

---Check status button
function DP_MainWindow:CheckStatusButton()
  local currentStatus = DisenchanterPlus.db.profile.status
  if currentStatus == nil or (currentStatus ~= DISENCHANT_PROCESS_STATUS_RUNNING and
        currentStatus ~= DISENCHANT_PROCESS_STATUS_PAUSED and
        currentStatus ~= DISENCHANT_PROCESS_STATUS_DISABLED) then
    currentStatus = DISENCHANT_PROCESS_STATUS_DISABLED
    DisenchanterPlus.db.profile.status = currentStatus
  end

  if currentStatus == DISENCHANT_PROCESS_STATUS_RUNNING then
    DisenchanterPlusHeaderFrame_PlayButton:Hide()
    DisenchanterPlusHeaderFrame_PauseButton:Show()
  elseif currentStatus == DISENCHANT_PROCESS_STATUS_PAUSED or
      currentStatus == DISENCHANT_PROCESS_STATUS_DISABLED then
    DisenchanterPlusHeaderFrame_PlayButton:Show()
    DisenchanterPlusHeaderFrame_PauseButton:Hide()
  end
  DisenchanterPlusFu.updateStatusIcon()
end

---Toggle rare button
function _DP_MainWindow.togglStatusButton()
  local status = DisenchanterPlus.db.profile.status
  if not status or status == DISENCHANT_PROCESS_STATUS_PAUSED or status == DISENCHANT_PROCESS_STATUS_DISABLED then
    DisenchanterPlus.db.profile.status = DISENCHANT_PROCESS_STATUS_RUNNING
    _DP_MainWindow.startDisenchantProcess()
  elseif status == DISENCHANT_PROCESS_STATUS_RUNNING then
    DisenchanterPlus.db.profile.status = DISENCHANT_PROCESS_STATUS_PAUSED
    _DP_MainWindow.pauseDisenchantProcess()
  end
end

---Check quality button
---@param frame table
---@param status boolean
---@param quality string
function DP_MainWindow:CheckQualityButton(frame, status, quality)
  if not status or status == false then
    frame:SetNormalTexture(string.format(QUALITY_TEXTURE_NORMAL, quality))
  else
    frame:SetNormalTexture(string.format(QUALITY_TEXTURE_SELECTED, quality))
  end
end

---Show qualitry tooltip
---@param tooltipFrame table
---@param type string
function _DP_MainWindow.showQualityTooltip(tooltipFrame, type)
  if not L then return end
  tooltipFrame:SetOwner(this, "ANCHOR_LEFT", (this:GetWidth() / 2), 5)
  tooltipFrame:ClearLines();
  local typeString, status, statusString

  if type == "epic" then
    typeString = "|cffa335eeepic|r"
    status = DisenchanterPlus.db.profile.epic or false
  elseif type == "rare" then
    typeString = "|cff0070ddrare|r"
    status = DisenchanterPlus.db.profile.rare or false
  elseif type == "uncommon" then
    typeString = "|cff1eff00uncommon|r"
    status = DisenchanterPlus.db.profile.uncommon or false
  end

  if status then
    statusString = "|c" .. DisenchanterPlus.onColor .. "on|r"
  else
    statusString = "|c" .. DisenchanterPlus.offColor .. "off|r"
  end

  tooltipFrame:SetText(string.format(L["Scan %s : %s"], typeString, statusString))
  tooltipFrame:Show();
end

---Start disenchant process
function _DP_MainWindow.startDisenchantProcess()
  local currentStatus = DisenchanterPlus.db.profile.status
  if currentStatus ~= DISENCHANT_PROCESS_STATUS_RUNNING then
    DisenchanterPlus.db.profile.status = DISENCHANT_PROCESS_STATUS_RUNNING
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\ChatScrollButton.ogg", "master")
  DP_MainWindow:CheckStatusButton()
  DP_DisenchanterProcess.Process()
  --_DP_MainWindow.closeMainWindow()
end

---Pause disenchant process
function _DP_MainWindow.pauseDisenchantProcess()
  local currentStatus = DisenchanterPlus.db.profile.status
  if currentStatus ~= DISENCHANT_PROCESS_STATUS_PAUSED then
    DisenchanterPlus.db.profile.status = DISENCHANT_PROCESS_STATUS_PAUSED
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\TabChange.ogg", "master")
  DP_MainWindow:CheckStatusButton()
  --_DP_MainWindow.closeMainWindow()
end

---Disable disenchant process
function _DP_MainWindow.disableDisenchantProcess()
  local currentStatus = DisenchanterPlus.db.profile.status
  if currentStatus ~= DISENCHANT_PROCESS_STATUS_DISABLED then
    DisenchanterPlus.db.profile.status = DISENCHANT_PROCESS_STATUS_DISABLED
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\TabChange.ogg", "master")
  DP_MainWindow:CheckStatusButton()
  _DP_MainWindow.closeMainWindow()
end

function _DP_MainWindow.i18n(message)
  return L[message]
end

---Update item remaining
---@param numberOfItems any
function DP_MainWindow:UpdateItemRemaining(numberOfItems)
  local s = "|c" .. DisenchanterPlus.onColor .. "%s|r"
  if numberOfItems == nil or numberOfItems == 0 then
    s = "|c" .. DisenchanterPlus.unknownColor .. "%s|r"
  end
  DisenchanterPlusFrame_ItemsLeft:SetText(string.format(s, tostring(numberOfItems)))
end

---Update item selected
---@param itemSelected any
function DP_MainWindow:UpdateItemSelected(itemSelected)
  if not itemSelected then return end

  local s = "|c%s%s|r"
  local qualityColor = ItemQualityColors[itemSelected.quality or 0]
  local name = itemSelected.name

  DisenchanterPlusItemFrame_Texture:SetTexture(itemSelected.texture)
  DisenchanterPlusFrame_ItemName:SetText(string.format(s, qualityColor, name))
end

---Update disenchant text
---@param text string
function DP_MainWindow:UpdateDisenchantText(text)
  if not text then text = "" end
  DisenchanterPlusFrame_Text:SetText(text)
end

---Toggle proceed button
---@param status boolean
function DP_MainWindow:ToggleProceedButton(status)
  if status then
    DisenchanterPlusFrame_ProceedButton:Enable()
  else
    DisenchanterPlusFrame_ProceedButton:Disable()
  end
end

---Toggle skip button
---@param status boolean
function DP_MainWindow:ToggleSkipButton(status)
  if status then
    DisenchanterPlusFrame_SkipButton:Enable()
  else
    DisenchanterPlusFrame_SkipButton:Disable()
  end
end

---Toggle ignore button
---@param status boolean
function DP_MainWindow:ToggleIgnoreButton(status)
  if status then
    DisenchanterPlusFrame_IgnoreButton:Enable()
  else
    DisenchanterPlusFrame_IgnoreButton:Disable()
  end
end

---add item to permanent ignored
---@param itemToIgnore table
function DP_MainWindow:AddItemToPermanentIgnored(itemToIgnore)
  local ignoredList = DisenchanterPlus.db.profile.permanentIgnoredItems or {}
  local s = "|c%s%s|r"
  local qualityColor = ItemQualityColors[itemToIgnore.quality or 0]
  local name = itemToIgnore.name
  ignoredList[tostring(itemToIgnore.id)] = string.format(s, qualityColor, name)

  DisenchanterPlus.db.profile.permanentIgnoredItems = ignoredList
  DP_MainWindow:CloseMainWindow()
end

function _DP_MainWindow.addItemToPermanentIgnored()
  local itemToProcess = DP_DisenchanterProcess.GetItemToProcess()
  if itemToProcess ~= nil then
    DP_MainWindow:AddItemToPermanentIgnored(itemToProcess)
  end
end

---remove item to permanent ignored
---@param itemToIgnore table
function DP_MainWindow:RemoveItemFromPermanentIgnored(itemToIgnore)
  local ignoredList = DisenchanterPlus.db.profile.permanentIgnoredItems or {}
  local itemId = itemToIgnore.id
  local newIgnoredList = {}
  for key, value in pairs(ignoredList) do
    if key ~= itemId then
      newIgnoredList[key] = value
    end
  end
  DisenchanterPlus.db.profile.permanentIgnoredItems = newIgnoredList
end

function _DP_MainWindow.removeItemFromPermanentIgnored()
  local itemToProcess = DP_DisenchanterProcess.GetItemToProcess()
  if itemToProcess ~= nil then
    DP_MainWindow:RemoveItemFromPermanentIgnored(itemToProcess)
  end
end

---add item to temporal ignored
---@param itemToIgnore table
function DP_MainWindow:AddItemToTemporalIgnored(itemToIgnore)
  local ignoredList = DisenchanterPlus.db.profile.temporalIgnoredItems or {}
  local s = "|c%s%s|r"
  local qualityColor = ItemQualityColors[itemToIgnore.quality or 0]
  local name = itemToIgnore.name
  local id = itemToIgnore.id
  ignoredList[tostring(itemToIgnore.id)] = string.format(s, qualityColor, name)

  DisenchanterPlus.db.profile.temporalIgnoredItems = ignoredList
  DP_MainWindow:CloseMainWindow()
end

function _DP_MainWindow.addItemToTemporalIgnored()
  local itemToProcess = DP_DisenchanterProcess.GetItemToProcess()
  if itemToProcess ~= nil then
    DP_MainWindow:AddItemToTemporalIgnored(itemToProcess)
  end
end

---remove item to temporal ignored
---@param itemToIgnore table
function DP_MainWindow:RemoveItemFromTemporalIgnored(itemToIgnore)
  local ignoredList = DisenchanterPlus.db.profile.temporalIgnoredItems or {}
  local itemId = itemToIgnore.id
  local newIgnoredList = {}
  for key, value in pairs(ignoredList) do
    if key ~= itemId then
      newIgnoredList[key] = value
    end
  end
  DisenchanterPlus.db.profile.temporalIgnoredItems = newIgnoredList
end

function _DP_MainWindow.removeItemFromTemporalIgnored()
  local itemToProcess = DP_DisenchanterProcess.GetItemToProcess()
  if itemToProcess ~= nil then
    DP_MainWindow:RemoveItemFromTemporalIgnored(itemToProcess)
  end
end

function _DP_MainWindow.proceedWithDisenchant()
  local itemToProcess = DP_DisenchanterProcess.GetItemToProcess()
  if itemToProcess ~= nil then
    DP_DisenchanterProcess:ProceedWithDisenchant()
  end
end
