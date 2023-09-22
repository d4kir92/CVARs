D4 = D4 or {}
local BuildNr = select(4, GetBuildInfo())
local Build = "CLASSIC"
if BuildNr >= 100000 then
    Build = "RETAIL"
elseif BuildNr > 29999 then
    Build = "WRATH"
elseif BuildNr > 19999 then
    Build = "TBC"
end

function D4:GetWoWBuildNr()
    return BuildNr
end

function D4:GetWoWBuild()
    return Build
end

--[[ MINIMAP BUTTONS ]]
local icon = LibStub("LibDBIcon-1.0", true)
function D4:GetLibDBIcon()
    return icon
end

function D4:CreateMinimapButton(tab)
    local mmbtn = LibStub("LibDataBroker-1.1"):NewDataObject(
        tab.name,
        {
            type = "data source",
            text = tab.name,
            icon = tab.icon,
            OnClick = function(sel, btnName)
                if btnName == "LeftButton" and tab.funcL then
                    tab:funcL()
                elseif btnName == "RightButton" and tab.funcR then
                    tab:funcR()
                end
            end,
            OnTooltipShow = function(tooltip)
                if not tooltip or not tooltip.AddLine then return end
                for i, v in pairs(tab.vTT) do
                    tooltip:AddLine(v)
                end
            end,
        }
    )

    if mmbtn and D4:GetLibDBIcon() then
        D4:GetLibDBIcon():Register(tab.name, mmbtn, tab.dbtab)
    end
end

--[[ QOL ]]
if D4:GetWoWBuild() ~= "RETAIL" and ShouldKnowUnitHealth and ShouldKnowUnitHealth("target") == false then
    function ShouldKnowUnitHealth(unit)
        return true
    end
end

--[[ INPUTS ]]
function D4:CreateCheckbox(tab)
    tab.sw = tab.sw or 25
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.value = tab.value or nil
    local cb = CreateFrame("CheckButton", tab.name, tab.parent, "UICheckButtonTemplate")
    cb:SetSize(tab.sw, tab.sh)
    cb:SetPoint(unpack(tab.pTab))
    cb:SetChecked(tab.value)
    cb:SetScript(
        "OnClick",
        function(sel)
            tab:funcV(sel:GetChecked())
        end
    )

    cb.f = cb:CreateFontString(nil, nil, "GameFontNormal")
    cb.f:SetPoint("LEFT", cb, "RIGHT", 0, 0)
    cb.f:SetText(tab.name)

    return cb
end

function D4:CreateCheckboxForCVAR(tab)
    tab.sw = tab.sw or 25
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.value = tab.value or nil
    local cb = D4:CreateCheckbox(tab)
    local cb2 = CreateFrame("CheckButton", tab.name, tab.parent, "UICheckButtonTemplate")
    cb2:SetSize(tab.sw, tab.sh)
    local p1, p2, p3 = unpack(tab.pTab)
    cb2:SetPoint(p1, p2 + 25, p3)
    cb2:SetChecked(tab.value2)
    cb2:SetScript(
        "OnClick",
        function(sel)
            tab:funcV2(sel:GetChecked())
        end
    )

    cb.f:SetPoint("LEFT", cb, "RIGHT", 25, 0)

    return cb
end

--[[ FRAMES ]]
function D4:CreateFrame(tab)
    tab.sw = tab.sw or 100
    tab.sh = tab.sh or 100
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.title = tab.title or ""
    tab.templates = tab.templates or "BasicFrameTemplateWithInset"
    local fra = CreateFrame("FRAME", tab.name, tab.parent, tab.templates)
    fra:SetSize(tab.sw, tab.sh)
    fra:SetPoint(unpack(tab.pTab))
    fra:SetClampedToScreen(true)
    fra:SetMovable(true)
    fra:EnableMouse(true)
    fra:RegisterForDrag("LeftButton")
    fra:SetScript("OnDragStart", fra.StartMoving)
    fra:SetScript("OnDragStop", fra.StopMovingOrSizing)
    fra:Hide()
    fra.TitleText:SetText(tab.title)

    return fra
end