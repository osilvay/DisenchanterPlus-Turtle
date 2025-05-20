---@class DP_MainWindow
local DP_MainWindow = DP_ModuleLoader:CreateModule("DP_MainWindow")
_DP_MainWindow = {}

local L = DisenchanterPlus.L
local QUALITY_TEXTURE_SELECTED = "Interface\\AddOns\\DisenchanterPlus-Turtle\\Images\\Qualities\\%s_selected"
local QUALITY_TEXTURE_NORMAL = "Interface\\AddOns\\DisenchanterPlus-Turtle\\Images\\Qualities\\%s"

---Close main window
function _DP_MainWindow.closeMainWindow()
  DisenchanterPlusHeaderFrame:Hide()
end

---Show main window
function _DP_MainWindow.showMainWindow()
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
  DP_MainWindow:UpdateButtonStatus()
end

---Check status button
function DP_MainWindow:CheckStatusButton()
  if DisenchanterPlus.db.profile.status == nil then DisenchanterPlus.db.profile.status = "stopped" end
  if DisenchanterPlus.db.profile.status == "running" then
    DisenchanterPlusHeaderFrame_PlayButton:Hide()
    DisenchanterPlusHeaderFrame_PauseButton:Show()
  elseif DisenchanterPlus.db.profile.status == "paused" or DisenchanterPlus.db.profile.status == "stopped" then
    DisenchanterPlusHeaderFrame_PlayButton:Show()
    DisenchanterPlusHeaderFrame_PauseButton:Hide()
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
