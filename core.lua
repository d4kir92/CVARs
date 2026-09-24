local AddonName, CVARs = ...
-- https://wowpedia.fandom.com/wiki/Console_variables
local CVARS_DEBUG = false
--[[ Minimap Button ]]
function CVARs:AddCVar(name, toggle, value, category, group)
	CVARs.CVarCategories = CVARs.CVarCategories or {}
	CVARs.CVarGroups = CVARs.CVarGroups or {}
	CVARs.CVarCategories[name] = category
	CVARs.CVarGroups[name] = group
	CVTAB = CVTAB or {}
	CVTAB["Default"] = CVTAB["Default"] or {}
	CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
	CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
	if CVTAB["Default"]["SETCVARS"][name] == nil or CVTAB["Default"]["CVARSDB"][name] == nil then
		CVTAB["Default"]["SETCVARS"][name] = toggle
		CVTAB["Default"]["CVARSDB"][name] = value
	end
end

function CVARs:AddCVarSlider(name, toggle, value, vmin, vmax, vdec, vste, defaultValue, category, group)
	CVARs.CVarCategories = CVARs.CVarCategories or {}
	CVARs.CVarGroups = CVARs.CVarGroups or {}
	CVARs.CVarCategories[name] = category
	CVARs.CVarGroups[name] = group
	CVTAB = CVTAB or {}
	CVTAB["Default"] = CVTAB["Default"] or {}
	CVTAB["Default"]["SETCVARSSLIDER"] = CVTAB["Default"]["SETCVARSSLIDER"] or {}
	CVTAB["Default"]["CVARSDBSLIDER"] = CVTAB["Default"]["CVARSDBSLIDER"] or {}
	CVTAB["Default"]["VMIN"] = CVTAB["Default"]["VMIN"] or {}
	CVTAB["Default"]["VMAX"] = CVTAB["Default"]["VMAX"] or {}
	CVTAB["Default"]["VDEC"] = CVTAB["Default"]["VDEC"] or {}
	CVTAB["Default"]["VSTE"] = CVTAB["Default"]["VSTE"] or {}
	CVTAB["Default"]["DEFAULTVALUE"] = CVTAB["Default"]["DEFAULTVALUE"] or {}
	if CVTAB["Default"]["SETCVARSSLIDER"][name] == nil or CVTAB["Default"]["CVARSDBSLIDER"][name] == nil or CVTAB["Default"]["VMIN"] == nil or CVTAB["Default"]["VMAX"] == nil or CVTAB["Default"]["VDEC"] == nil or CVTAB["Default"]["VSTE"] == nil then
		CVTAB["Default"]["SETCVARSSLIDER"][name] = toggle
		CVTAB["Default"]["CVARSDBSLIDER"][name] = value
		CVTAB["Default"]["VMIN"][name] = vmin or 0
		CVTAB["Default"]["VMAX"][name] = vmax or 1
		CVTAB["Default"]["VDEC"][name] = vdec or 0
		CVTAB["Default"]["VSTE"][name] = vste or 1
	end

	if CVTAB["Default"]["DEFAULTVALUE"][name] == nil then CVTAB["Default"]["DEFAULTVALUE"][name] = defaultValue or nil end
end

function CVARs:OnInitialize(event, ...)
	if event == "ADDON_LOADED" then
		local addonName = select(1, ...)
		if addonName == AddonName then
			CVARs:SetVersion(134063, "1.3.5")
			for i = 1, 100 do
				if GetCVar("nameplateMaxDistance") ~= nil then
					local currentDist = tonumber(GetCVar("nameplateMaxDistance"))
					if i > currentDist then
						SetCVar("nameplateMaxDistance", i)
						currentDist = tonumber(GetCVar("nameplateMaxDistance"))
						if currentDist ~= i then break end
					end
				end
			end

			CVTAB = CVTAB or {}
			CVTAB["Default"] = CVTAB["Default"] or {}
			CVTAB["Default"]["SETCVARS"] = CVTAB["Default"]["SETCVARS"] or {}
			CVTAB["Default"]["CVARSDB"] = CVTAB["Default"]["CVARSDB"] or {}
			--[[INIT CVARS]]
			CVARs:AddCVar("autoLootDefault", 1, 1, "GAME") -- Fast looting
			CVARs:AddCVar("enableFloatingCombatText", 1, 1, "GAME", "FLOATINGCOMBATTEXT") -- Combattext
			CVARs:AddCVar("floatingCombatTextCombatHealing", 1, 1, "GAME", "FLOATINGCOMBATTEXT") -- Combattext:Healing
			CVARs:AddCVar("floatingCombatTextReactives", 1, 1, "GAME", "FLOATINGCOMBATTEXT") -- Combattext:Reactives
			CVARs:AddCVar("xpBarText", 1, 1, "GAME") -- Show XP Text
			CVARs:AddCVar("showTargetCastbar", 1, 1, "GAME") -- Show Target Castbar
			CVARs:AddCVar("windowResizeLock", 0, 0, "GRAPHICS") -- Game Window Mode Resize Lock
			CVARs:AddCVar("nameplateMotion", 1, 1, "GAME", "NAMEPLATES") -- Nameplate stacking
			CVARs:AddCVar("nameplateShowEnemies", 0, 0, "GAME", "NAMEPLATES") -- Show Nameplates: Enemies
			CVARs:AddCVar("nameplateShowFriends", 0, 0, "GAME", "NAMEPLATES") -- Show Nameplates: Friends
			CVARs:AddCVar("nameplateShowFriendlyNpcs", 0, 0, "GAME", "NAMEPLATES") -- Show Nameplates: Friendly Npcs
			CVARs:AddCVar("ActionButtonUseKeyDown", 0, 1, "GAME")
			CVARs:AddCVar("ResampleAlwaysSharpen", 1, 1, "GRAPHICS")
			CVARs:AddCVar("cameraReduceUnexpectedMovement", 0, 1, "GAME")
			CVARs:AddCVar("showPartyPets", 0, 1, "GAME")
			CVARs:AddCVar("volumeFog", 0, 0, "GRAPHICS", "FOG")
			CVARs:AddCVar("volumeFogInterior", 0, 1, "GRAPHICS", "FOG")
			CVARs:AddCVar("RAIDVolumeFog", 0, 0, "GRAPHICS", "FOG")
			--CVARs:AddCVarSlider(name, toggle, value, vmin, vmax, vdec, vste)
			CVARs:AddCVarSlider("cameraDistanceMaxZoomFactor", 0, 4.0, 0, 4.0, 1, 0.1, 1.900000, "GAME")
			CVARs:AddCVarSlider("nameplateOverlapH", 0, 0.8, 0, 10, 2, 0.01, 0.8, "GAME", "NAMEPLATES")
			CVARs:AddCVarSlider("nameplateOverlapV", 0, 1.1, 0, 10, 2, 0.01, 1.1, "GAME", "NAMEPLATES")
			CVARs:AddCVarSlider("nameplateOtherTopInset", 0, 0.08, 0, 0.50, 2, 0.01, 0.08, "GAME", "NAMEPLATES")
			CVARs:AddCVarSlider("nameplateOtherBottomInset", 0, 0.10, 0, 0.50, 2, 0.01, 0.10, "GAME", "NAMEPLATES")
			CVARs:AddCVarSlider("cameraFov", 0, 90, 50, 90, 0, 1, 90, "GRAPHICS")
			CVARs:AddCVarSlider("WorldTextScale", 0, 1.0, 0.01, 4.00, 2, 0.01, 1.0, "GAME", "FLOATINGCOMBATTEXT")
			CVARs:AddCVarSlider("WorldTextScreenY", 0, 0.015, 0.001, 2.000, 3, 0.001, 0.015, "GAME", "FLOATINGCOMBATTEXT")
			CVARs:AddCVarSlider("WorldTextCritScreenY", 0, 0.0275, 0.0001, 2.0000, 4, 0.0001, 0.0275, "GAME", "FLOATINGCOMBATTEXT")
			CVARs:AddCVarSlider("SoftTargetInteractRange", 0, 10, 1, 40, 1, 1, 1, "GAME")
			CVARs:AddCVarSlider("SpellQueueWindow", 0, 0, 0, 400, 0, 1.0, nil, "GAME")
			CVARs:AddCVarSlider("volumeFogLevel", 0, 2, 0, 3, 0, 1, 2, "GRAPHICS", "FOG")
			CVARs:AddCVarSlider("RAIDVolumeFogLevel", 0, 2, 0, 3, 0, 1, 2, "GRAPHICS", "FOG")
			--[[SETTING CVARS]]
			for name, val in pairs(CVTAB["Default"]["CVARSDB"]) do
				if CVTAB["Default"]["SETCVARS"][name] then SetCVar(name, val) end
			end

			for name, val in pairs(CVTAB["Default"]["CVARSDBSLIDER"]) do
				if CVTAB["Default"]["SETCVARSSLIDER"][name] then SetCVar(name, val) end
			end

			CVARs:InitMinimapButton()
			CVARs:InitSettings()
		end
	elseif event == "CVAR_UPDATE" then
		print("CVARS", event, ...)
	end
end

local f = CreateFrame("FRAME")
f:RegisterEvent("ADDON_LOADED")
if CVARS_DEBUG then f:RegisterEvent("CVAR_UPDATE") end
f:SetScript("OnEvent", CVARs.OnInitialize)
