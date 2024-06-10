local _, CVARs = ...
local CVARS_DEBUG = false
--[[ Minimap Button ]]
D4:AddTrans("enUS", "CVARs", "CVARs")
D4:AddTrans("enUS", "showMinimapButton", "Show Minimap Button")
D4:AddTrans("deDE", "showMinimapButton", "Minimap Knopf anzeigen")
--[[ CVARS ]]
D4:AddTrans("enUS", "autoLootDefault", "Fast Looting")
D4:AddTrans("deDE", "autoLootDefault", "Schnell Plündern")
D4:AddTrans("enUS", "enableFloatingCombatText", "Enable Floating Combat Text")
D4:AddTrans("deDE", "enableFloatingCombatText", "Aktiviere Fliegender Kampftext")
D4:AddTrans("enUS", "floatingCombatTextCombatHealing", "Enable Floating Combat Healing Text")
D4:AddTrans("deDE", "floatingCombatTextCombatHealing", "Aktiviere Fliegenden Heilung (Kampftext)")
D4:AddTrans("enUS", "floatingCombatTextReactives", "Enable Reactive Spells and Abilities")
D4:AddTrans("deDE", "floatingCombatTextReactives", "Aktiviere Reaktive Zauber und Fähigkeiten")
D4:AddTrans("enUS", "xpBarText", "XP Bar Text")
D4:AddTrans("deDE", "xpBarText", "EP Bar Text")
D4:AddTrans("enUS", "showTargetCastbar", "Show TargetFrame Castbar")
D4:AddTrans("deDE", "showTargetCastbar", "Ziel-Zauberleiste anzeigen")
D4:AddTrans("enUS", "windowResizeLock", "Windowmode resize lock")
D4:AddTrans("deDE", "windowResizeLock", "Sperrung der Größenänderung im Fenstermodus")
D4:AddTrans("enUS", "nameplateMotion", "Namplate Stacking")
D4:AddTrans("deDE", "nameplateMotion", "Namensplaketten stapeln")
D4:AddTrans("enUS", "nameplateShowEnemies", "Show Enemy Nameplates")
D4:AddTrans("deDE", "nameplateShowEnemies", "Gegner-Namensplaketten anzeigen")
D4:AddTrans("enUS", "nameplateShowFriends", "Show Friend Nameplates")
D4:AddTrans("deDE", "nameplateShowFriends", "Freund-Namensplaketten anzeigen")
D4:AddTrans("enUS", "nameplateShowFriendlyNpcs", "Show Friendly Npc Nameplates")
D4:AddTrans("deDE", "nameplateShowFriendlyNpcs", "Freundliche Npc-Namensplaketten anzeigen")
D4:AddTrans("enUS", "ActionButtonUseKeyDown", "ActionButtonUseKeyDown")
D4:AddTrans("deDE", "ActionButtonUseKeyDown", "ActionButtonUseKeyDown")
D4:AddTrans("enUS", "Need more CVARs? Join the Discord", "Need more CVARs? Join the Discord")
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
	if event == "PLAYER_LOGIN" then
		for i = 1, 100 do
			if GetCVar("nameplateMaxDistance", i) ~= nil then
				local currentDist = tonumber(GetCVar("nameplateMaxDistance", i))
				if i > currentDist then
					SetCVar("nameplateMaxDistance", i)
					currentDist = tonumber(GetCVar("nameplateMaxDistance", i))
					if currentDist ~= i then break end
				end
			end
		end

		CVTAB = CVTAB or {}
		CVTAB["Default"] = CVTAB["Default"] or {}
		CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
		CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
		--[[INIT CVARS]]
		CVARs:AddCVar("autoLootDefault", 1, 1) -- Fast looting
		CVARs:AddCVar("enableFloatingCombatText", 1, 1) -- Combattext
		CVARs:AddCVar("floatingCombatTextCombatHealing", 1, 1) -- Combattext:Healing
		CVARs:AddCVar("floatingCombatTextReactives", 1, 1) -- Combattext:Reactives
		CVARs:AddCVar("xpBarText", 1, 1) -- Show XP Text
		CVARs:AddCVar("showTargetCastbar", 1, 1) -- Show Target Castbar
		CVARs:AddCVar("windowResizeLock", 0, 0) -- Game Window Mode Resize Lock
		CVARs:AddCVar("nameplateMotion", 1, 1) -- Nameplate stacking
		CVARs:AddCVar("nameplateShowEnemies", 0, 0) -- Show Nameplates: Enemies
		CVARs:AddCVar("nameplateShowFriends", 0, 0) -- Show Nameplates: Friends
		CVARs:AddCVar("nameplateShowFriendlyNpcs", 0, 0) -- Show Nameplates: Friendly Npcs
		CVARs:AddCVar("ActionButtonUseKeyDown", 0, 1)
		--[[SETTING CVARS]]
		for name, val in pairs(CVTAB["Default"]["CVARSDB"]) do
			if CVTAB["Default"]["SETCVARS"][name] then
				SetCVar(name, val)
			end
		end

		CVARs:InitMinimapButton()
		CVARs:InitSettings()
	elseif event == "CVAR_UPDATE" then
		print("CVARS", event, ...)
	end
end

local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_LOGIN")
if CVARS_DEBUG then
	f:RegisterEvent("CVAR_UPDATE")
end

f:SetScript("OnEvent", CVARs.OnInitialize)
