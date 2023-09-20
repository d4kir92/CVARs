local _, CVARs = ...
local CVARS_DEBUG = false
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
		print(...)
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