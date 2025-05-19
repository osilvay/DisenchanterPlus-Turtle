local L = DisenchanterPlus.L

L:RegisterTranslations("enUS", function()
  return {
    ["config"]                  = true,
    ["Shows the config window"] = true,
    ["Enable/Disable debug"]    = true,
    ["Title"]                   = true,
    ["Version"]                 = true,
    ["Status"]                  = true,
    ["Debug"]                   = true,
  }
end)

if GetLocale() == "enUS" then
  --LEFT_HINT = "Left-click to |cFF00FF00open";
end
