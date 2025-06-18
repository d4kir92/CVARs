local _, CVARs = ...
local CVARS_DEBUG = false
--[[ Minimap Button ]]
CVARs:AddTrans("enUS", "CVARs", "CVARs")
CVARs:AddTrans("enUS", "", "")
CVARs:AddTrans("deDE", "", "")
CVARs:AddTrans("enUS", "MMBTN", "Show Minimap Button")
CVARs:AddTrans("deDE", "MMBTN", "Minimap Knopf anzeigen")
--[[ CVARS ]]
CVARs:AddTrans("enUS", "autoLootDefault", "Fast Looting")
CVARs:AddTrans("deDE", "autoLootDefault", "Schnell Plündern")
CVARs:AddTrans("enUS", "enableFloatingCombatText", "Enable Floating Combat Text")
CVARs:AddTrans("deDE", "enableFloatingCombatText", "Aktiviere Fliegender Kampftext")
CVARs:AddTrans("enUS", "floatingCombatTextCombatHealing", "Enable Floating Combat Healing Text")
CVARs:AddTrans("deDE", "floatingCombatTextCombatHealing", "Aktiviere Fliegenden Heilung (Kampftext)")
CVARs:AddTrans("enUS", "floatingCombatTextReactives", "Enable Reactive Spells and Abilities")
CVARs:AddTrans("deDE", "floatingCombatTextReactives", "Aktiviere Reaktive Zauber und Fähigkeiten")
CVARs:AddTrans("enUS", "xpBarText", "XP Bar Text")
CVARs:AddTrans("deDE", "xpBarText", "EP Bar Text")
CVARs:AddTrans("enUS", "showTargetCastbar", "Show TargetFrame Castbar")
CVARs:AddTrans("deDE", "showTargetCastbar", "Ziel-Zauberleiste anzeigen")
CVARs:AddTrans("enUS", "windowResizeLock", "Windowmode resize lock")
CVARs:AddTrans("deDE", "windowResizeLock", "Sperrung der Größenänderung im Fenstermodus")
CVARs:AddTrans("enUS", "nameplateMotion", "Namplate Stacking")
CVARs:AddTrans("deDE", "nameplateMotion", "Namensplaketten stapeln")
CVARs:AddTrans("enUS", "nameplateShowEnemies", "Show Enemy Nameplates")
CVARs:AddTrans("deDE", "nameplateShowEnemies", "Gegner-Namensplaketten anzeigen")
CVARs:AddTrans("enUS", "nameplateShowFriends", "Show Friend Nameplates")
CVARs:AddTrans("deDE", "nameplateShowFriends", "Freund-Namensplaketten anzeigen")
CVARs:AddTrans("enUS", "nameplateShowFriendlyNpcs", "Show Friendly Npc Nameplates")
CVARs:AddTrans("deDE", "nameplateShowFriendlyNpcs", "Freundliche Npc-Namensplaketten anzeigen")
CVARs:AddTrans("enUS", "ActionButtonUseKeyDown", "ActionButtonUseKeyDown")
CVARs:AddTrans("deDE", "ActionButtonUseKeyDown", "ActionButtonUseKeyDown")
CVARs:AddTrans("enUS", "Need more CVARs? Join the Discord", "Need more CVARs? Join the Discord")
CVARs:AddTrans("enUS", "nameplateOverlapH", "Nameplate Overlap Horizontal %s")
CVARs:AddTrans("deDE", "nameplateOverlapH", "Namensplaketten Überlappen Horizontal %s")
CVARs:AddTrans("enUS", "nameplateOverlapV", "Nameplate Overlap Vertical %s")
CVARs:AddTrans("deDE", "nameplateOverlapV", "Namensplaketten Überlappen Vertikal %s")
CVARs:AddTrans("enUS", "cameraReduceUnexpectedMovement", "Camera Reduce Unexpected Movement")
CVARs:AddTrans("deDE", "cameraReduceUnexpectedMovement", "Kamera Unerwartete Bewegung reduzieren")
CVARs:AddTrans("enUS", "cameraDistanceMaxZoomFactor", "Camera Distance Max Zoom Factor: %s")
CVARs:AddTrans("deDE", "cameraDistanceMaxZoomFactor", "Kameraabstand Max. Zoom-Faktor: %s")
CVARs:AddTrans("enUS", "ResampleAlwaysSharpen", "Resample Always Sharpen")
CVARs:AddTrans("deDE", "ResampleAlwaysSharpen", "Neuabtastung immer schärfen")
CVARs:AddTrans("enUS", "cameraFov", "Camera FOV: %s")
CVARs:AddTrans("deDE", "cameraFov", "Kamera FOV: %s")
--[[ CATEGORIES ]]
CVARs:AddTrans("enUS", "general", "General")
CVARs:AddTrans("deDE", "general", "Allgemein")
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

function CVARs:AddCVarSlider(name, val, val2, vmin, vmax, vdec, vste)
	CVTAB = CVTAB or {}
	CVTAB["Default"] = CVTAB["Default"] or {}
	CVTAB["Default"]["SETCVARSSLIDER"] = CVTAB["Default"]["SETCVARSSLIDER"] or {}
	CVTAB["Default"]["CVARSDBSLIDER"] = CVTAB["Default"]["CVARSDBSLIDER"] or {}
	CVTAB["Default"]["VMIN"] = CVTAB["Default"]["VMIN"] or {}
	CVTAB["Default"]["VMAX"] = CVTAB["Default"]["VMAX"] or {}
	CVTAB["Default"]["VDEC"] = CVTAB["Default"]["VDEC"] or {}
	CVTAB["Default"]["VSTE"] = CVTAB["Default"]["VSTE"] or {}
	if CVTAB["Default"]["SETCVARSSLIDER"][name] == nil or CVTAB["Default"]["CVARSDBSLIDER"][name] == nil or CVTAB["Default"]["VMIN"] == nil or CVTAB["Default"]["VMAX"] == nil or CVTAB["Default"]["VDEC"] == nil or CVTAB["Default"]["VSTE"] == nil then
		CVTAB["Default"]["SETCVARSSLIDER"][name] = val
		CVTAB["Default"]["CVARSDBSLIDER"][name] = val2
		CVTAB["Default"]["VMIN"][name] = vmin or 0
		CVTAB["Default"]["VMAX"][name] = vmax or 1
		CVTAB["Default"]["VDEC"][name] = vdec or 0
		CVTAB["Default"]["VSTE"][name] = vste or 1
	end
end

function CVARs:OnInitialize(event, ...)
	if event == "PLAYER_LOGIN" then
		CVARs:SetVersion(134063, "1.2.66")
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
		CVARs:AddCVar("ResampleAlwaysSharpen", 1, 1)
		CVARs:AddCVar("cameraReduceUnexpectedMovement", 0, 1)
		local maxZoom = 4.0
		if CVARs:GetWoWBuild() == "RETAIL" then
			maxZoom = 2.6
		end

		CVARs:AddCVarSlider("cameraDistanceMaxZoomFactor", 0, maxZoom, 0, maxZoom, 1, 0.1)
		CVARs:AddCVarSlider("nameplateOverlapH", 0, 0.8, 0, 10, 2, 0.05)
		CVARs:AddCVarSlider("nameplateOverlapV", 0, 1.1, 0, 10, 2, 0.05)
		CVARs:AddCVarSlider("cameraFov", 0, 90, 50, 90, 0, 1)
		--[[SETTING CVARS]]
		for name, val in pairs(CVTAB["Default"]["CVARSDB"]) do
			if CVTAB["Default"]["SETCVARS"][name] then
				SetCVar(name, val)
			end
		end

		for name, val in pairs(CVTAB["Default"]["CVARSDBSLIDER"]) do
			if CVTAB["Default"]["SETCVARSSLIDER"][name] then
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
