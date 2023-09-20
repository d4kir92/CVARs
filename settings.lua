local _, CVARs = ...
local cvars_settings = nil
function CVARs:MSG(msg)
    print("|cff3FC7EB[CVARs]|r " .. msg)
end

function CVARs:CVARMsg(name)
    local msg = name
    local set = CVTAB["Default"]["SETCVARS"][name]
    local val = CVTAB["Default"]["CVARSDB"][name]
    if set then
        msg = msg .. " is set to: " .. tostring(val)
    else
        msg = msg .. " is not set"
    end

    CVARs:MSG(msg)
end

function CVARs:InitSettings()
    CVTAB = CVTAB or {}
    CVTAB["Default"] = CVTAB["Default"] or {}
    CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
    CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
    cvars_settings = D4:CreateFrame(
        {
            ["name"] = "CVARs Settings Frame",
            ["pTab"] = {"CENTER"},
            ["sw"] = 520,
            ["sh"] = 520,
            ["title"] = format("CVARs |T134063:16:16:0:0|t v|cff3FC7EB%s", "1.0.8")
        }
    )

    cvars_settings.helptext = cvars_settings:CreateFontString(nil, nil, "GameFontNormal")
    cvars_settings.helptext:SetPoint("TOP", cvars_settings, "TOP", 0, 30)
    cvars_settings.helptext:SetText("Left-Checkbox: Set CVAR    Right-Checkbox: CVAR Value")
    cvars_settings.helptext:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    local y = -30
    if CVTAB["MMBTN"] == nil then
        CVTAB["MMBTN"] = true
    end

    D4:CreateCheckbox(
        {
            ["name"] = "Show Minimap Icon",
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
    for i, name in pairs(cvarsSorted) do
        D4:CreateCheckboxForCVAR(
            {
                ["name"] = name,
                ["parent"] = cvars_settings,
                ["pTab"] = {"TOPLEFT", 10, y},
                ["value"] = CVTAB["Default"]["SETCVARS"][name],
                ["value2"] = CVTAB["Default"]["CVARSDB"][name],
                ["funcV"] = function(sel, checked)
                    CVTAB["Default"]["SETCVARS"][name] = checked
                    CVARs:CVARMsg(name)
                end,
                ["funcV2"] = function(sel, checked)
                    CVTAB["Default"]["CVARSDB"][name] = checked
                    CVARs:CVARMsg(name)
                end
            }
        )

        y = y - 25
    end

    if CVTAB["MMBTN"] then
        D4:GetLibDBIcon():Show("CVArs")
    else
        D4:GetLibDBIcon():Hide("CVArs")
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
    local mmbtn = nil
    CVTAB["MMBTNTAB"] = CVTAB["MMBTNTAB"] or {}
    D4:CreateMinimapButton(
        {
            ["name"] = "CVArs",
            ["icon"] = 134063,
            ["var"] = mmbtn,
            ["dbtab"] = CVTAB,
            ["vTT"] = {"Leftclick: Options"},
            ["funcL"] = function()
                CVARs:ToggleSettings()
            end
        }
    )

    SLASH_CVARS1 = "/cvars"
    SlashCmdList["CVARS"] = function(msg)
        CVARs:ToggleSettings()
    end
end