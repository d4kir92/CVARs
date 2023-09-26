D4 = D4 or {}
--[[ Basics ]]
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

--[[ QOL ]]
if D4:GetWoWBuild() ~= "RETAIL" and ShouldKnowUnitHealth and ShouldKnowUnitHealth("target") == false then
    function ShouldKnowUnitHealth(unit)
        return true
    end
end