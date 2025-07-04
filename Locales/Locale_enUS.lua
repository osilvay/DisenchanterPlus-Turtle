local L = DisenchanterPlus.L

L:RegisterTranslations("enUS", function()
  return {
    ["show"]                                      = true,
    ["Open main window"]                          = true,
    ["config"]                                    = true,
    ["Open settings window"]                      = true,
    ["Enable/Disable debug"]                      = true,
    ["Title"]                                     = true,
    ["Version"]                                   = true,
    ["Status"]                                    = true,
    ["Debug"]                                     = true,
    ["Scan %s : %s"]                              = true,
    ["Pause disenchant process"]                  = true,
    ["Start disenchant process"]                  = true,
    ["Close (and pause disenchant process)"]      = true,
    ["Click to open the DisenchanterPlus frame."] = true,
    ["Update time"]                               = true,
    ["Item can be disenchanted."]                 = true,
    ["Waiting an item to disenchant..."]          = true,
    ["You do not have the Disenchant skill."]     = true,
    ["You cannot disenchant while moving."]       = true,
    ["Ignore list"]                               = true,
  }
end)

if GetLocale() == "enUS" then
  --LEFT_HINT = "Left-click to |cFF00FF00open";
end
