---@class DP_ItemInfo
local DP_ItemInfo = DP_ModuleLoader:CreateModule("DP_ItemInfo")

local L = DisenchanterPlus.L
local _G = _G or getfenv()

---@type table<string, string|number|table|nil>
ITEM_SKELETON = {
  name = "",
  itemLink = "",
  quality = "",
  minLevel = "",
  type = "",
  subtype = "",
  equipLocation = "",
  texture = "Interface\\Icons\\INV_Misc_QuestionMark",
  id = 0
}
function DP_ItemInfo:Initialize()
end

---Parse item link
---@param itemLink string Item link or item string.
---@return string? itemString
---@return number? itemId
---@return string? itemStringGeneric
---@return string? itemStringWithoutRandomSuffix
function DP_ItemInfo:ParseItemLink(itemLink)
  if not itemLink then
    return
  end
  local itemString, itemStringGeneric, itemStringWithoutRandomSuffix
  local found, _, itemId, enchantId, suffixId, uniqueId = string.find(tostring(itemLink), "item:(%d+):(%d+):(%d+):(%d+)")
  if found then
    local itemFormatString = "item:%s:%s:%s:%s"
    itemString = string.format(itemFormatString, itemId, enchantId, suffixId, uniqueId)
    itemStringGeneric = string.format(itemFormatString, itemId, "0", suffixId, "0")
    if suffixId ~= "0" then
      itemStringWithoutRandomSuffix = string.format(itemFormatString, itemId, "0", "0", "0")
    end
  end
  return itemString, tonumber(itemId), itemStringGeneric, itemStringWithoutRandomSuffix
end

---Get
---@param itemIdentifier string|number|nil Item ID, link, or string. Allowed to be nil for empty slots.
---@return table|nil
function DP_ItemInfo:Get(itemIdentifier)
  local itemName, itemTexture, itemString, itemLinkFromGetItemInfo,
  itemQuality, itemMinLevel, itemType, itemSubtype, itemMaxStackCount,
  itemEquipLocation, itemId, itemLinkWithoutRandomSuffix

  local item = DP_ItemInfo:InitializeItem()
  if itemIdentifier ~= nil then
    if type(itemIdentifier) == "string" then
      itemString, itemId, _, itemLinkWithoutRandomSuffix = DP_ItemInfo:ParseItemLink(itemIdentifier)
    end
    itemName,
    _,
    itemQuality,
    itemMinLevel,
    itemType,
    itemSubtype,
    _,
    itemEquipLocation,
    itemTexture = _G.GetItemInfo(itemString or itemIdentifier)
    --DP_Debug(itemType)
    if itemName == nil then
      DP_Debug("GetItemInfo() returned nil - bailing")
      return nil
    end
  end

  item.id = itemId
  item.texture = itemTexture
  item.name = itemName
  item.quality = itemQuality
  item.minLevel = itemMinLevel
  item.type = itemType
  item.subtype = itemSubtype
  item.equipLocation = itemEquipLocation

  local itemQualityColor = ItemQualityColors[item.quality or 1]
  if itemString ~= nil and not string.find(tostring(itemIdentifier), "^|") then
    item.itemLink = itemQualityColor .. "|H" .. itemString .. "|H[" .. (itemName or L.Unknown) .. "]|H|r"
  else
    item.itemLink = itemString
  end
  return item
end

function DP_ItemInfo:InitializeItem()
  return ITEM_SKELETON
end
