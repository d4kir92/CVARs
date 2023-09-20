local _, CVARs = ...
local CVARS_DEBUG = false
function CVARs:OnInitialize(event, ...)
	SetCVar("autoLootDefault", 1) -- Fast looting
	SetCVar("enableFloatingCombatText", 1) -- Combattext
	SetCVar("floatingCombatTextCombatHealing", 1) -- Combattext: Healing
	SetCVar("xpBarText", 1) -- Show XP Text
	if event == "CVAR_UPDATE" then
		print(...)
	end
end

local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_LOGIN")
if CVARS_DEBUG then
	f:RegisterEvent("CVAR_UPDATE")
end

f:SetScript("OnEvent", CVARs.OnInitialize)