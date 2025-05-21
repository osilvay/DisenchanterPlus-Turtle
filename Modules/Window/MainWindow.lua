---@class DP_MainWindow
local DP_MainWindow = DP_ModuleLoader:CreateModule("DP_MainWindow")
_DP_MainWindow = {}

local L = DisenchanterPlus.L
local QUALITY_TEXTURE_SELECTED = "Interface\\AddOns\\DisenchanterPlus-Turtle\\Images\\Qualities\\%s_selected"
local QUALITY_TEXTURE_NORMAL = "Interface\\AddOns\\DisenchanterPlus-Turtle\\Images\\Qualities\\%s"

---Close main window
function _DP_MainWindow.closeMainWindow()
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\CharacterSheetClose.ogg", "master")
  DisenchanterPlusHeaderFrame:Hide()
end

---Show main window
function _DP_MainWindow.showMainWindow()
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\CharacterSheetOpen.ogg", "master")
  DP_MainWindow:UpdateButtonStatus()
  DisenchanterPlusHeaderFrame:Show()
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

  tooltipFrame:SetText(string.format("Filter by %s : %s", typeString, statusString))
  tooltipFrame:Show();
end

---Start disenchant process
function _DP_MainWindow.startDisenchantProcess()
  local currentStatus = DisenchanterPlus.db.profile.status
  if currentStatus ~= DISENCHANT_PROCESS_STATUS_RUNNING then
    DisenchanterPlus.db.profile.status = DISENCHANT_PROCESS_STATUS_RUNNING
  end
  PlaySoundFile("Interface\\Addons\\DisenchanterPlus-Turtle\\Sounds\\TabChange.ogg", "master")
  DP_MainWindow:CheckStatusButton()
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
