---@class DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:CreateModule("DP_BagsChecker")

---@type DP_CommonFunctions
local DP_CommonFunctions = DP_ModuleLoader:ImportModule("DP_CommonFunctions")

---@type DP_ItemInfo
local DP_ItemInfo = DP_ModuleLoader:ImportModule("DP_ItemInfo")

local L = DisenchanterPlus.L
local _G = _G or getfenv()

function DP_BagsChecker:Initialize()
end

---Get bag item processor
---@return table|nil
---@return number
function DP_BagsChecker.GetBagItemProcess()
  local itemToDisenchant, totalNumItems = DP_BagsChecker:GetItemFromBags()
  return itemToDisenchant, totalNumItems
end

---Check item in bag
---@return table|nil
---@return integer
function DP_BagsChecker:GetItemFromBags()
  local itemToDisenchant = nil
  local totalNumItems = 0
  local qualitiesToTest = {}

  if _AP_Database.GetCharValue("epic") then table.insert(qualitiesToTest, 4) end
  if _AP_Database.GetCharValue("rare") then table.insert(qualitiesToTest, 3) end
  if _AP_Database.GetCharValue("uncommon") then table.insert(qualitiesToTest, 2) end

  for bagIndex = 0, 4 do
    local numSlots = GetContainerNumSlots(bagIndex)
    for slot = 1, numSlots do
      --local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagIndex, slot)
      local itemLink = _G.GetContainerItemLink(bagIndex, slot)
      local _, itemId = DP_ItemInfo:ParseItemLink(itemLink)
      if itemId then
        local itemInfo = DP_ItemInfo:Get(itemId)
        if itemInfo == nil then
          return nil, 0
        end
        --DP_Debug(string.format("|c%s%s|r = %s", ItemQualityColors[itemInfo.quality or 0], itemInfo.name, tostring(itemInfo.quality)))
        if (itemInfo.type == 'Armor' or itemInfo.type == 'Weapon') and
            DP_CommonFunctions:TableHasValue(qualitiesToTest, itemInfo.quality) and
            not DP_BagsChecker:CheckItemIsIgnored(itemId) then
          -- filter by quality

          totalNumItems = totalNumItems + 1

          if itemToDisenchant == nil then
            itemToDisenchant = {
              id = itemId,
              itemLink = itemLink,
              texture = itemInfo.texture,
              name = itemInfo.name,
              quality = itemInfo.quality,
              minLevel = itemInfo.minLevel,
              type = itemInfo.type,
              subtype = itemInfo.subtype,
              equipLocation = itemInfo.equipLocation,
              bagIndex = bagIndex,
              slot = slot
            }
          end
        end
      end
    end
  end
  return itemToDisenchant, totalNumItems
end

---Check item is ignored
---@param itemId number
---@return boolean
function DP_BagsChecker:CheckItemIsIgnored(itemId)
  local temporalIgnoredItems = _AP_Database.SetCharValue("temporalIgnoredItems") or {}
  local permanentIgnoredItems = _AP_Database.GetCharValue("permanentIgnoredItems") or {}
  if DP_CommonFunctions:TableHasKey(temporalIgnoredItems, tostring(itemId)) or
      DP_CommonFunctions:TableHasKey(permanentIgnoredItems, tostring(itemId)) then
    return true
  end
  return false
end
