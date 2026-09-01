local _, CVARs = ...
-- https://wowpedia.fandom.com/wiki/Console_variables
CVARs:SetAddonOutput("CVARs", 134063)
local cvars_settings = nil
local DEFAULT_WIDTH = 520
local DEFAULT_HEIGHT = 520
local DISCORD = "discord.gg/bhMKRMCa8d"
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

local function GetCollapsed(key)
    if key == nil then return nil end
    if type(CVTAB) ~= "table" then return nil end
    if type(CVTAB["COLLAPSED"]) ~= "table" then return nil end

    return CVTAB["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
    if key == nil then return end
    if type(CVTAB) ~= "table" then return end
    if type(CVTAB["COLLAPSED"]) ~= "table" then CVTAB["COLLAPSED"] = {} end
    if collapsed then
        CVTAB["COLLAPSED"][key] = true
    else
        CVTAB["COLLAPSED"][key] = nil
    end
end

local function CleanLabel(text)
    if text == nil then return "" end
    text = gsub(text, "%%[%-%+ #0-9%.]*[sdfxXeEgGiu]", "")
    text = gsub(text, "%s+", " ")
    text = strtrim(text)
    text = gsub(text, ":$", "")

    return strtrim(text)
end

local function CVarLabel(name)
    local key = "LID_" .. name
    local text = CVARs:Trans(key)
    if text == key then return name end

    return CleanLabel(text)
end

local function ValueText(checked)
    if checked then return CVARs:Trans("LID_TRUE") end

    return CVARs:Trans("LID_FALSE")
end

local function AddCVarCategory(name)
    cvars_settings:AddCategory({
        ["label"] = CVarLabel(name),
        ["key"] = name,
        ["search"] = name,
        ["level"] = 2
    })
end

local function IndentOne(frame)
    if frame == nil then return end
    if frame.uiElement == nil then return end
    frame.uiElement.depth = frame.uiElement.depth + 1
end

local function SetCheckboxEnabled(cb, enabled)
    if cb == nil then return end
    cb:SetEnabled(enabled)
    if enabled then
        cb:SetAlpha(1)
    else
        cb:SetAlpha(0.5)
    end
end

local function SetSliderEnabled(holder, enabled)
    if holder == nil then return end
    if enabled then
        holder.slider:Enable()
        holder:SetAlpha(1)
    else
        holder.slider:Disable()
        holder:SetAlpha(0.5)
    end
end

local function AddSetCVarCheckbox(name, db, value, onToggle)
    return cvars_settings:AddCheckbox({
        ["label"] = "LID_SETCONSOLEVARIABLE",
        ["search"] = name,
        ["value"] = value == 1,
        ["func"] = function(checked)
            if checked then
                CVTAB["Default"][db][name] = 1
            else
                CVTAB["Default"][db][name] = 0
            end

            if onToggle then onToggle(checked) end
            if db == "SETCVARS" then
                CVARs:CVARMsg(name)
            else
                CVARs:CVARMsgSlider(name)
            end
        end
    })
end

local function AddFooter()
    local footer = cvars_settings:AddFooter({["height"] = 24})
    footer.Label = footer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    footer.Label:SetPoint("LEFT", footer, "LEFT", 4, 0)
    footer.Label:SetJustifyH("LEFT")
    footer.Label:SetText(CVARs:Trans("LID_needmorecvars"))
    local discord = CreateFrame("EditBox", "CVARsSettingsDiscord", footer, "InputBoxTemplate")
    discord:SetPoint("RIGHT", footer, "RIGHT", 0, 0)
    discord:SetSize(160, 22)
    discord:SetAutoFocus(false)
    discord:SetText(DISCORD)
    discord:SetScript(
        "OnTextChanged",
        function(sel)
            if sel:GetText() ~= DISCORD then sel:SetText(DISCORD) end
        end
    )

    discord:SetScript("OnEditFocusGained", function(sel) sel:HighlightText() end)
    discord:SetScript("OnEscapePressed", function(sel) sel:ClearFocus() end)
    discord:SetScript("OnEnterPressed", function(sel) sel:ClearFocus() end)
    footer.Label:SetPoint("RIGHT", discord, "LEFT", -8, 0)
    footer.Discord = discord

    return footer
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
    CVTAB["Default"]["DEFAULTVALUE"] = CVTAB["Default"]["DEFAULTVALUE"] or {}
    if CVTAB["MMBTN"] == nil then CVTAB["MMBTN"] = CVARs:GetWoWBuild() ~= "RETAIL" end
    cvars_settings = CVARs:CreateUIWindow({
        ["name"] = "CVARsSettings",
        ["pTab"] = {"CENTER"},
        ["width"] = CVARs:GV(CVTAB, "WINDOWWIDTH", DEFAULT_WIDTH),
        ["height"] = CVARs:GV(CVTAB, "WINDOWHEIGHT", DEFAULT_HEIGHT),
        ["minWidth"] = 360,
        ["minHeight"] = 240,
        ["onResize"] = function(width, height)
            CVARs:SV(CVTAB, "WINDOWWIDTH", width)
            CVARs:SV(CVTAB, "WINDOWHEIGHT", height)
        end,
        ["getCollapsed"] = function(key) return GetCollapsed(key) end,
        ["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
        ["title"] = format("|T134063:16:16:0:0|t CVARs v%s", CVARs:GetVersion())
    })

    AddFooter()
    cvars_settings:SuspendLayout()
    cvars_settings:AddSearch()
    cvars_settings:AddCategory({
        ["label"] = "LID_GENERAL",
        ["key"] = "GENERAL",
        ["search"] = "GENERAL"
    })

    cvars_settings:AddCheckbox({
        ["label"] = "LID_MMBTN",
        ["search"] = "MMBTN",
        ["value"] = CVTAB["MMBTN"],
        ["func"] = function(value)
            CVTAB["MMBTN"] = value
            if CVTAB["MMBTN"] then
                CVARs:ShowMMBtn("CVARs")
            else
                CVARs:HideMMBtn("CVARs")
            end
        end
    })

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
    cvars_settings:AddCategory({
        ["label"] = "LID_CVARs",
        ["key"] = "CVARs",
        ["search"] = "CVARs"
    })

    for _, name in ipairs(cvarsSorted) do
        local set = CVTAB["Default"]["SETCVARS"][name]
        local valueBox = nil
        AddCVarCategory(name)
        AddSetCVarCheckbox(name, "SETCVARS", set, function(checked) SetCheckboxEnabled(valueBox, checked) end)
        valueBox = cvars_settings:AddCheckbox({
            ["search"] = name,
            ["value"] = CVTAB["Default"]["CVARSDB"][name] == 1,
            ["textFunc"] = function(cb) return CVARs:Trans("LID_SETVALUETO", nil, ValueText(cb:GetChecked())) end,
            ["func"] = function(checked)
                if checked then
                    CVTAB["Default"]["CVARSDB"][name] = 1
                else
                    CVTAB["Default"]["CVARSDB"][name] = 0
                end

                CVARs:CVARMsg(name)
            end
        })

        IndentOne(valueBox)
        SetCheckboxEnabled(valueBox, set == 1)
    end

    for _, name in ipairs(cvarsSortedSlider) do
        local set = CVTAB["Default"]["SETCVARSSLIDER"][name]
        local value = CVTAB["Default"]["CVARSDBSLIDER"][name]
        if set == nil then set = 1 end
        if value == nil then value = 1 end
        local label = CVARs:Trans("LID_SETVALUETO")
        local default = CVTAB["Default"]["DEFAULTVALUE"][name]
        if default ~= nil then label = format("%s (%s: %s)", label, CVARs:Trans("LID_DEFAULT"), default) end
        local valueSlider = nil
        AddCVarCategory(name)
        AddSetCVarCheckbox(name, "SETCVARSSLIDER", set, function(checked) SetSliderEnabled(valueSlider, checked) end)
        valueSlider = cvars_settings:AddSlider({
            ["label"] = label,
            ["search"] = name,
            ["value"] = value,
            ["min"] = CVTAB["Default"]["VMIN"][name] or 0,
            ["max"] = CVTAB["Default"]["VMAX"][name] or 9,
            ["step"] = CVTAB["Default"]["VSTE"][name] or 1,
            ["decimals"] = CVTAB["Default"]["VDEC"][name] or 0,
            ["func"] = function(newValue)
                if newValue and CVTAB["Default"]["CVARSDBSLIDER"][name] ~= newValue then
                    CVTAB["Default"]["CVARSDBSLIDER"][name] = newValue
                    CVARs:CVARMsgSlider(name)
                end
            end
        })

        IndentOne(valueSlider)
        SetSliderEnabled(valueSlider, set == 1)
    end

    cvars_settings:ResumeLayout()
end

function CVARs:ToggleSettings()
    if cvars_settings == nil then return end
    cvars_settings:Toggle()
end

function CVARs:InitMinimapButton()
    CVTAB["MMBTNTAB"] = CVTAB["MMBTNTAB"] or {}
    if CVTAB["MMBTN"] == nil then CVTAB["MMBTN"] = CVARs:GetWoWBuild() ~= "RETAIL" end
    CVARs:CreateMinimapButton({
        ["name"] = "CVARs",
        ["icon"] = 134063,
        ["dbtab"] = CVTAB,
        ["vTT"] = {{"|T134063:16:16:0:0|t CVARs", "v" .. CVARs:GetVersion()}, {CVARs:Trans("LID_LEFTCLICK"), CVARs:Trans("LID_OPENSETTINGS")}, {CVARs:Trans("LID_RIGHTCLICK"), CVARs:Trans("LID_HIDEMINIMAPBUTTON")}},
        ["funcL"] = function() CVARs:ToggleSettings() end,
        ["funcR"] = function()
            CVTAB["MMBTN"] = false
            CVARs:HideMMBtn("CVARs")
        end,
        ["dbkey"] = "MMBTN"
    })

    CVARs:AddSlash("cvars", CVARs.ToggleSettings)
end
