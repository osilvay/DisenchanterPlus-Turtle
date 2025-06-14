---@class DP_CommonFunctions
local DP_CommonFunctions = DP_ModuleLoader:CreateModule("DP_CommonFunctions")

---Check if table contains value
---@param table table
---@param value any
---@return boolean
function DP_CommonFunctions:TableHasValue(table, value)
  for _, v in pairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

---Check if table contains key
---@param table table
---@param key any
---@return boolean
function DP_CommonFunctions:TableHasKey(table, key)
  for k, _ in pairs(table) do
    if k == key then
      return true
    end
  end
  return false
end
