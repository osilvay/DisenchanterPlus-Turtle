---@class DP_BagsChecker
local DP_BagsChecker = DP_ModuleLoader:CreateModule("DP_BagsChecker")

---@type DP_ItemInfo
local DP_ItemInfo = DP_ModuleLoader:ImportModule("DP_ItemInfo")

local L = DisenchanterPlus.L
local _G = _G or getfenv()

function DP_BagsChecker:Initialize()
end

function DP_BagsChecker.CheckBagItemProcess()
  local item, totalNumItems = DP_BagsChecker:GetItemFromBags()
end

function DP_BagsChecker:CheckItemInBag(bagIndex)
  local item
  local numItemsInBag = 0
  local numSlots = GetContainerNumSlots(bagIndex)

  for slot = 1, numSlots do
    --local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagIndex, slot)
    local itemLink = _G.GetContainerItemLink(bagIndex, slot)
    local _, itemId = DP_ItemInfo:ParseItemLink(itemLink)
    if itemId then
      local itemInfo = DP_ItemInfo:Get(itemId)
      if itemInfo == nil then return end
      if itemInfo.type == 'Armor' or itemInfo.type == 'Weapon' then
        DP_Print(string.format("|c%s%s|r", ItemQualityColors[itemInfo.quality or 0], itemInfo.name))
        numItemsInBag = numItemsInBag + 1
      end
    end
    --[[
    if containerInfo ~= nil and containerInfo.itemID ~= nil then
      local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, _, _, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(containerInfo.itemID)
      local isBound = containerInfo.isBound

      if (itemType == DisenchanterPlus:DP_i18n("Armor") or itemType == DisenchanterPlus:DP_i18n("Weapon") or containerInfo.itemID == enchantingVellum) and
          not DP_CustomFunctions:TableHasKey(sessionIgnoredList, tostring(containerInfo.itemID)) and
          not DP_CustomFunctions:TableHasKey(permanentIgnoredList, tostring(containerInfo.itemID)) and
          DP_CustomFunctions:TableHasValue(itemQualityList, tostring(itemQuality)) and
          ((DisenchanterPlus.db.char.general.onlySoulbound and isBound) or not DisenchanterPlus.db.char.general.onlySoulbound) then
        --DisenchanterPlus:Dump(sessionIgnoredItems)
        --DisenchanterPlus:Debug(containerInfo.hyperlink)
        --DisenchanterPlus:Debug(itemLink)
        --DisenchanterPlus:Debug("itemQuality = " .. tostring(itemQuality) .. ", itemID = " .. tostring(containerInfo.itemID) .. ", texture = " .. itemTexture)
        numItemsInBag = numItemsInBag + 1
        if result == nil then
          result = {
            ItemID = tostring(containerInfo.itemID),
            ItemName = itemName,
            ItemIcon = itemTexture,
            ItemLink = containerInfo.hyperlink,
            ItemQuality = itemQuality,
            ItemLevel = itemLevel,
            ItemMinLevel = itemMinLevel,
            Slot = slot,
            BagIndex = bagIndex,
            SpellID = disenchantSpellID
          }
        end
      end
    end
    ]]
  end
  return item, numItemsInBag
end

---Get item from bags
---@return string
---@return number
function DP_BagsChecker:GetItemFromBags()
  local totalNumItems = 0
  local itemResult

  for bagIndex = 0, 4 do
    --DisenchanterPlus:Debug("Bag : " .. tostring(bagIndex))
    local itemInBag, numItemsInBag = DP_BagsChecker:CheckItemInBag(bagIndex)
    if itemInBag ~= nil then
      itemResult = itemInBag
    end
    totalNumItems = totalNumItems + numItemsInBag
  end

  return itemResult, totalNumItems
end
