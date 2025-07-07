_AP_Database = {}

function _AP_Database:Initialize()
end

--- Get character database value
---@param key string
---@return any
function _AP_Database.GetCharValue(key)
  if not DisenchanterPlus or not DisenchanterPlus.info then return end
  return DisenchanterPlusDB["chars"][DisenchanterPlus.info.characterKey][key]
end

--- Set character database value
---@param key string
---@param value any|nil
function _AP_Database.SetCharValue(key, value)
  if not DisenchanterPlus or not DisenchanterPlus.info then return end
  DisenchanterPlusDB["chars"][DisenchanterPlus.info.characterKey][key] = value
end

--- Get global database value
---@param key string
---@return any|nil
function _AP_Database.GetGlobalValue(key)
end

--- Set global database value
---@param key string
---@param value any
function _AP_Database.SetGlobalValue(key, value)
end

_AP_Database:Initialize()
