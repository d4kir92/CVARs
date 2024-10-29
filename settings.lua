local AddonName, CVARs = ...
CVARs:SetAddonOutput("CVARs", 134063)
local cvars_settings = nil
function CVARs:CVARMsg(name)
    local msg = name
    local set = CVTAB["Default"]["SETCVARS"][name]
    local val = CVTAB["Default"]["CVARSDB"][name]
    if set == 1 then
        msg = "|cff00ff00" .. msg .. " is set to: " .. tostring(val)
    else
        msg = "|cffff0000" .. msg .. " is not set by CVARs"
    end

    SetCVar(name, val)
    CVARs:MSG(msg)
end

function CVARs:CVARMsgSlider(name)
    local msg = name
    local set = CVTAB["Default"]["SETCVARSSLIDER"][name]
    local val = CVTAB["Default"]["CVARSDBSLIDER"][name]
    if set == 1 then
        msg = "|cff00ff00" .. msg .. " is set to: " .. tostring(val)
    else
        msg = "|cffff0000" .. msg .. " is not set by CVARs"
    end

    SetCVar(name, val)
    CVARs:MSG(msg)
end

function CVARs:InitSettings()
    CVTAB = CVTAB or {}
    CVTAB["Default"] = CVTAB["Default"] or {}
    CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
    CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
    CVTAB["Default"]["SETCVARSSLIDER"] = CVTAB["Default"]["SETCVARSSLIDER"] or {}
    CVTAB["Default"]["CVARSDBSLIDER"] = CVTAB["Default"]["CVARSDBSLIDER"] or {}
    CVTAB["Default"]["VMIN"] = CVTAB["Default"]["VMIN"] or {}
    CVTAB["Default"]["VMAX"] = CVTAB["Default"]["VMAX"] or {}
    CVTAB["Default"]["VDEC"] = CVTAB["Default"]["VDEC"] or {}
    CVTAB["Default"]["VSTE"] = CVTAB["Default"]["VSTE"] or {}
    CVARs:SetVersion(AddonName, 134063, "1.2.46")
    cvars_settings = CVARs:CreateFrame(
        {
            ["name"] = "CVARs Settings Frame",
            ["pTab"] = {"CENTER"},
            ["sw"] = 520,
            ["sh"] = 700,
            ["title"] = format("CVARs |T134063:16:16:0:0|t v|cff3FC7EB%s", "1.2.46")
        }
    )

    cvars_settings.helptext = cvars_settings:CreateFontString(nil, nil, "GameFontNormal")
    cvars_settings.helptext:SetPoint("TOP", cvars_settings, "TOP", 0, 30)
    cvars_settings.helptext:SetText("Left-Checkbox: Set CVAR by CVARs    Right-Checkbox: CVAR Value")
    cvars_settings.helptext:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    local y = -30
    if CVTAB["MMBTN"] == nil then
        CVTAB["MMBTN"] = CVARs:GetWoWBuild() ~= "RETAIL"
    end

    CVARs:AddCategory(
        {
            ["name"] = "general",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 15, y},
        }
    )

    y = y - 15
    CVARs:CreateCheckbox(
        {
            ["name"] = "MMBTN",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
            ["value"] = CVTAB["MMBTN"],
            ["funcV"] = function(sel, checked)
                CVTAB["MMBTN"] = checked
                if CVTAB["MMBTN"] then
                    CVARs:ShowMMBtn("CVArs")
                else
                    CVARs:HideMMBtn("CVArs")
                end
            end
        }
    )

    y = y - 25
    y = y - 15
    local cvarsSorted = {}
    for k in pairs(CVTAB["Default"]["SETCVARS"]) do
        tinsert(cvarsSorted, k)
    end

    table.sort(cvarsSorted)
    local cvarsSortedSlider = {}
    for k in pairs(CVTAB["Default"]["SETCVARSSLIDER"]) do
        tinsert(cvarsSortedSlider, k)
    end

    table.sort(cvarsSortedSlider)
    CVARs:AddCategory(
        {
            ["name"] = "CVARs",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 15, y},
        }
    )

    y = y - 15
    for i, name in pairs(cvarsSorted) do
        local val = false
        local val2 = false
        if CVTAB["Default"]["SETCVARS"][name] == 1 then
            val = true
        end

        if CVTAB["Default"]["CVARSDB"][name] == 1 then
            val2 = true
        end

        CVARs:CreateCheckboxForCVAR(
            {
                ["name"] = name,
                ["parent"] = cvars_settings,
                ["pTab"] = {"TOPLEFT", 10, y},
                ["value"] = val,
                ["value2"] = val2,
                ["funcV"] = function(sel, checked)
                    if checked then
                        CVTAB["Default"]["SETCVARS"][name] = 1
                    else
                        CVTAB["Default"]["SETCVARS"][name] = 0
                    end

                    CVARs:CVARMsg(name)
                end,
                ["funcV2"] = function(sel, checked)
                    if checked then
                        CVTAB["Default"]["CVARSDB"][name] = 1
                    else
                        CVTAB["Default"]["CVARSDB"][name] = 0
                    end

                    CVARs:CVARMsg(name)
                end
            }
        )

        y = y - 25
    end

    y = y - 10
    for i, name in pairs(cvarsSortedSlider) do
        local val = CVTAB["Default"]["SETCVARSSLIDER"][name]
        local val2 = CVTAB["Default"]["CVARSDBSLIDER"][name]
        if val == nil then
            val = 1
        end

        if val2 == nil then
            val2 = 1
        end

        CVARs:CreateSliderForCVAR(
            {
                ["name"] = name,
                ["parent"] = cvars_settings,
                ["pTab"] = {"TOPLEFT", 10, y},
                ["value"] = val,
                ["value2"] = val2,
                ["vmin"] = CVTAB["Default"]["VMIN"][name] or 0,
                ["vmax"] = CVTAB["Default"]["VMAX"][name] or 9,
                ["decimals"] = CVTAB["Default"]["VDEC"][name] or 0,
                ["steps"] = CVTAB["Default"]["VSTE"][name] or 1,
                ["funcV"] = function(sel, checked)
                    if checked then
                        CVTAB["Default"]["SETCVARSSLIDER"][name] = 1
                    else
                        CVTAB["Default"]["SETCVARSSLIDER"][name] = 0
                    end

                    CVARs:CVARMsgSlider(name)
                end,
                ["funcV2"] = function(sel, value)
                    if value then
                        CVTAB["Default"]["CVARSDBSLIDER"][name] = value
                    end

                    CVARs:CVARMsgSlider(name)
                end
            }
        )

        y = y - 55
    end

    y = y - 30
    CVARs:AddCategory(
        {
            ["name"] = "Need more CVARs? Join the Discord",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 15, y},
        }
    )

    local dc = CVARs:CreateEditBox(
        {
            ["name"] = "",
            ["parent"] = cvars_settings,
            ["pTab"] = {"BOTTOMRIGHT", -8, 4},
            ["sw"] = 150,
            ["value"] = "discord.gg/bhMKRMCa8d",
            ["funcV"] = function(sel, text) end
        }
    )

    dc:SetAutoFocus(false)
end

function CVARs:ToggleSettings()
    if cvars_settings then
        if cvars_settings:IsShown() then
            cvars_settings:Hide()
        else
            cvars_settings:Show()
        end
    end
end

function CVARs:InitMinimapButton()
    CVTAB["MMBTNTAB"] = CVTAB["MMBTNTAB"] or {}
    if CVTAB["MMBTN"] == nil then
        CVTAB["MMBTN"] = CVARs:GetWoWBuild() ~= "RETAIL"
    end

    CVARs:CreateMinimapButton(
        {
            ["name"] = "CVArs",
            ["icon"] = 134063,
            ["dbtab"] = CVTAB,
            ["vTT"] = {{"CVArs |T134063:16:16:0:0|t", "v|cff3FC7EB1.2.46"}, {"Leftclick", "Options"}, {"Rightclick", "Hide Minimap"}},
            ["funcL"] = function()
                CVARs:ToggleSettings()
            end,
            ["funcR"] = function()
                CVTAB["MMBTN"] = false
                CVARs:HideMMBtn("CVArs")
            end
        }
    )

    if CVTAB["MMBTN"] then
        CVARs:ShowMMBtn("CVArs")
    else
        CVARs:HideMMBtn("CVArs")
    end

    CVARs:AddSlash("cvars", CVARs.ToggleSettings)
end
