--
-- MageHUDFu -- a FuBar button interface to MageHUD
--

-- Only load if MageHUD is already loaded
if not DisenchanterPlus then return end

local dewdrop = AceLibrary("Dewdrop-2.0")

DisenchanterPlusFu = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")
DisenchanterPlusFu:RegisterDB("DisenchanterPlusDB")
DisenchanterPlusFu.hasIcon = "Interface\\Addons\\DisenchanterPlus-Turtle\\Images\\MiniMap\\disenchanterplus"
DisenchanterPlusFu.defaultMinimapPosition = 180
DisenchanterPlusFu.cannotDetachTooltip = true
DisenchanterPlusFu.independentProfile = true
DisenchanterPlusFu.hideWithoutStandby = true

function DisenchanterPlusFu:OnMenuRequest(level, value, x, valueN_1, valueN_2, valueN_3, valueN_4)
  DisenchanterPlus:Debug(tostring(level))
  DisenchanterPlusFu.createDDMenu(level, value, true)
  if (level == 1) then
    dewdrop:AddLine()
  end
end

---Create Dropdown menu
---@param level string
---@param menu string
---@param skipfirst boolean
function DisenchanterPlusFu.createDDMenu(level, menu, skipfirst)
  if (level == 1) then

  else
  end

  --[[if (level == 1) then
    for k, v in ipairs(DisenchanterPlus.menu["L1"]) do
      if (k == 1 and not skipfirst or k > 1) then
        if (type(v) == "table") then
          --MageHUD:LevelDebug(d_notice, "Creating button on level %s", level)
          dewdrop:AddLine(unpack(v))
        else
          --MageHUD:LevelDebug(d_warn, "Error in createDDMenu in level %d (table expected, got %s)", level, type(v))
        end
      end
    end
  else
    if (DisenchanterPlus.menu[menu]) then
      local id
      local val
      local arg3
      local arg4
      local isradio
      for _, v in ipairs(DisenchanterPlus.menu[menu]) do
        if (type(v) == "table") then
          --MageHUD:LevelDebug(d_notice, "Creating button on level %s in menu %s", level, menu)
          id, val, arg3, arg4, isradio = nil, nil, nil, nil, nil
          for a, b in ipairs(v) do
            --MageHUD:LevelDebug(d_notice, "  ID: %d, Value: %s", a, (type(b) == "function" and "function" or b))
            if (b == "checked" or b == "sliderValue") then
              id = a + 1
            elseif (b == "isRadio" and v[a + 1]) then
              isradio = true
            elseif (b == "arg2" or b == "sliderArg2") then
              val = v[a + 1]
            elseif (b == "arg3" or b == "sliderArg3") then
              arg3 = v[a + 1]
            elseif (b == "arg4" or b == "sliderArg4") then
              arg4 = v[a + 1]
            end
          end
          if (id) then
            --MageHUD:LevelDebug(d_notice, "  Found value on '%d', setting name '%s'", id, val)
            if (isradio) then
              if (arg4) then
                --MageHUD:LevelDebug(d_notice, "  Using namespace '%s'", arg3)
                v[id] = (MageHUD:AcquireDBNamespace(arg3).profile[val] == arg4 and true or false)
                --MageHUD:LevelDebug(d_notice, "  Value set to '%s'", v[id])
              else
                v[id] = (MageHUD.db.profile[val] == arg3 and true or false)
                --MageHUD:LevelDebug(d_notice, "  Value set to '%s'", v[id])
              end
            else
              if (arg3) then
                --MageHUD:LevelDebug(d_notice, "  Using namespace '%s'", arg3)
                v[id] = MageHUD:AcquireDBNamespace(arg3).profile[val]
                --MageHUD:LevelDebug(d_notice, "  Value set to '%s'", v[id])
              else
                v[id] = MageHUD.db.profile[val]
                --MageHUD:LevelDebug(d_notice, "  Value set to '%s'", v[id])
              end
            end
          end
          dewdrop:AddLine(unpack(v))
        else
          MageHUD:LevelDebug(d_warn, "Error in createDDMenu in level %d (table expected, got %s)", level, type(v))
        end
      end
    end
  end]]
end
