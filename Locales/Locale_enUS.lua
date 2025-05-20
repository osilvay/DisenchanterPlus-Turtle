local L = DisenchanterPlus.L

L:RegisterTranslations("enUS", function()
  return {
    ["show"]                 = true,
    ["Open main window"]     = true,
    ["config"]               = true,
    ["Open settings window"] = true,
    ["Enable/Disable debug"] = true,
    ["Title"]                = true,
    ["Version"]              = true,
    ["Status"]               = true,
    ["Debug"]                = true,
  }
end)

if GetLocale() == "enUS" then
  --LEFT_HINT = "Left-click to |cFF00FF00open";
end
