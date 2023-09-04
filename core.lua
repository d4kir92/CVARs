local _, CVARs = ...

function CVARs:OnInitialize()
	SetCVar("autoLootDefault", 1)
	SetCVar("enableFloatingCombatText", 1)
end

local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", CVARs.OnInitialize)