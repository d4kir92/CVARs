local _, CVARs = ...
local CVARS_DEBUG = false
--[[ Minimap Button ]]
D4:AddTrans("enUS", "showMinimapButton", "Show Minimap Button")
D4:AddTrans("deDE", "showMinimapButton", "Minimap Knopf anzeigen")
--[[ CVARS ]]
D4:AddTrans("enUS", "autoLootDefault", "Fast Looting")
D4:AddTrans("deDE", "autoLootDefault", "Schnell Plündern")
D4:AddTrans("enUS", "enableFloatingCombatText", "Enable Floating Combat Text")
D4:AddTrans("deDE", "enableFloatingCombatText", "Aktiviere Fliegender Kampftext")
D4:AddTrans("enUS", "floatingCombatTextCombatHealing", "Enable Floating Combat Healing Text")
D4:AddTrans("deDE", "floatingCombatTextCombatHealing", "Aktiviere Fliegenden Heilungs Kampftext")
D4:AddTrans("enUS", "xpBarText", "XP Bar Text")
D4:AddTrans("deDE", "xpBarText", "EP Bar Text")
--[[ CATEGORIES ]]
D4:AddTrans("enUS", "general", "General")
D4:AddTrans("deDE", "general", "Allgemein")
function CVARs:AddCVar(name, val, val2)
	CVTAB = CVTAB or {}
	CVTAB["Default"] = CVTAB["Default"] or {}
	CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
	CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
	if CVTAB["Default"]["SETCVARS"][name] == nil or CVTAB["Default"]["CVARSDB"][name] == nil then
		CVTAB["Default"]["SETCVARS"][name] = val
		CVTAB["Default"]["CVARSDB"][name] = val2
	end
end

function CVARs:OnInitialize(event, ...)
	CVTAB = CVTAB or {}
	CVTAB["Default"] = CVTAB["Default"] or {}
	CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
	CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
	if event == "PLAYER_LOGIN" then
		--[[INIT CVARS]]
		CVARs:AddCVar("autoLootDefault", 1, 1) -- Fast looting
		CVARs:AddCVar("enableFloatingCombatText", 1, 1) -- Combattext
		CVARs:AddCVar("floatingCombatTextCombatHealing", 1, 1) -- Combattext:Healing
		CVARs:AddCVar("xpBarText", 1, 1) -- Show XP Text
		--[[SETTING CVARS]]
		for name, val in pairs(CVTAB["Default"]["CVARSDB"]) do
			if CVTAB["Default"]["SETCVARS"][name] then
				SetCVar(name, val)
			end
		end
	elseif event == "CVAR_UPDATE" then
		print("CVARS", event, ...)
	end

	CVARs:InitMinimapButton()
	CVARs:InitSettings()
end

local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_LOGIN")
if CVARS_DEBUG then
	f:RegisterEvent("CVAR_UPDATE")
end

f:SetScript("OnEvent", CVARs.OnInitialize)