local AddonName, CVARs = ...
local cvars_settings = nil
function CVARs:MSG(msg)
    print("|cff3FC7EB[CVARs]|r " .. msg)
end

function CVARs:CVARMsg(name)
    local msg = name
    local set = CVTAB["Default"]["SETCVARS"][name]
    local val = CVTAB["Default"]["CVARSDB"][name]
    if set then
        msg = "|cff00ff00" .. msg .. " is set to: " .. tostring(val)
    else
        msg = "|cffff0000" .. msg .. " is not set by CVARs"
    end

    CVARs:MSG(msg)
end

function CVARs:InitSettings()
    CVTAB = CVTAB or {}
    CVTAB["Default"] = CVTAB["Default"] or {}
    CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
    CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
    D4:SetVersion(AddonName, 134063, "1.2.14")
    cvars_settings = D4:CreateFrame(
        {
            ["name"] = "CVARs Settings Frame",
            ["pTab"] = {"CENTER"},
            ["sw"] = 520,
            ["sh"] = 520,
            ["title"] = format("CVARs |T134063:16:16:0:0|t v|cff3FC7EB%s", "1.2.14")
        }
    )

    cvars_settings.helptext = cvars_settings:CreateFontString(nil, nil, "GameFontNormal")
    cvars_settings.helptext:SetPoint("TOP", cvars_settings, "TOP", 0, 30)
    cvars_settings.helptext:SetText("Left-Checkbox: Set CVAR by CVARs    Right-Checkbox: CVAR Value")
    cvars_settings.helptext:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    local y = -30
    if CVTAB["MMBTN"] == nil then
        CVTAB["MMBTN"] = true
    end

    D4:AddCategory(
        {
            ["name"] = "general",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 15, y},
        }
    )

    y = y - 15
    D4:CreateCheckbox(
        {
            ["name"] = "showMinimapButton",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 10, y},
            ["value"] = CVTAB["MMBTN"],
            ["funcV"] = function(sel, checked)
                CVTAB["MMBTN"] = checked
                if CVTAB["MMBTN"] then
                    D4:GetLibDBIcon():Show("CVArs")
                else
                    D4:GetLibDBIcon():Hide("CVArs")
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
    D4:AddCategory(
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

        D4:CreateCheckboxForCVAR(
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

    y = y - 30
    D4:AddCategory(
        {
            ["name"] = "Need more CVARs? Join the Discord",
            ["parent"] = cvars_settings,
            ["pTab"] = {"TOPLEFT", 15, y},
        }
    )

    y = y - 15
    local dc = D4:CreateEditBox(
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
    if CVTAB["MMBTN"] then
        D4:ShowMMBtn("CVArs")
    else
        D4:HideMMBtn("CVArs")
    end
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
    D4:CreateMinimapButton(
        {
            ["name"] = "CVArs",
            ["icon"] = 134063,
            ["dbtab"] = CVTAB,
            ["vTT"] = {"CVArs", "Leftclick: Options"},
            ["funcL"] = function()
                CVARs:ToggleSettings()
            end
        }
    )

    D4:AddSlash("cvars", CVARs.ToggleSettings)
end