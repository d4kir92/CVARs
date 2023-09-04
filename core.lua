local _, CVARs = ...
local colors = {}

colors["bg"] = {0.03, 0.03, 0.03}

colors["se"] = {1.0, 1.0, 0.0}

colors["el"] = {0.6, 0.84, 1.0}

colors["hidden"] = {1.0, 0.0, 0.0}

colors["clickthrough"] = {0.2, 0.2, 1.0}

function CVARs:GetColor(key)
	return colors[key][1], colors[key][2], colors[key][3]
end

local MADF = {}

function CVARs:GetDragFrames()
	return MADF
end

--[[ HIDEPANEL ]]
local MAHIDDEN = CreateFrame("Frame", "MAHIDDEN")
MAHIDDEN:Hide()
MAHIDDEN.unit = "player"
MAHIDDEN.auraRows = 0
--[[ HIDEPANEL ]]
--[[ NEW ]]
local MAUIP = CreateFrame("Frame", "UIParent")
MAUIP:SetAllPoints(UIParent)
MAUIP.unit = "player"
MAUIP.auraRows = 0

hooksecurefunc(UIParent, "SetScale", function(self, scale)
	MAUIP:SetScale(scale)
end)

MAUIP:SetScale(UIParent:GetScale())

hooksecurefunc(UIParent, "SetAlpha", function(self, alpha)
	MAUIP:SetAlpha(alpha)
end)

MAUIP:SetAlpha(UIParent:GetAlpha())

hooksecurefunc(UIParent, "Show", function(self)
	MAUIP:SetAlpha(1)
end)

hooksecurefunc(UIParent, "Hide", function(self)
	MAUIP:SetAlpha(0)
end)

hooksecurefunc(_G, "SetUIVisibility", function(show)
	if show then
		MAUIP:SetAlpha(1)
	else
		MAUIP:SetAlpha(0)
	end
end)

function CVARs:GetMainPanel()
	return MAUIP
end

--[[ NEW ]]
local pausedKeybinds = {"UP", "DOWN", "LEFT", "RIGHT"}

local oldKeybinds = {}
local isToggling = false
local wasDisabled = false

function CVARs:UnlockBindings()
	if not InCombatLockdown() then
		if CVARs:IsEnabled("DISABLEMOVEMENT", false) then
			for i, name in pairs(pausedKeybinds) do
				oldKeybinds[name] = GetBindingAction(name)
				SetBinding(name, nil)
			end

			wasDisabled = true
		end

		isToggling = false
	else
		C_Timer.After(0.1, CVARs.UnlockBindings)
	end
end

function CVARs:LockBindings()
	if not InCombatLockdown() then
		if CVARs:IsEnabled("DISABLEMOVEMENT", false) or wasDisabled then
			for i, name in pairs(pausedKeybinds) do
				if oldKeybinds[name] then
					SetBinding(name, oldKeybinds[name])
				end
			end

			wasDisabled = false
		end

		isToggling = false
	else
		C_Timer.After(0.1, CVARs.LockBindings)
	end
end

function CVARs:Unlock()
	if not isToggling then
		isToggling = true
		CVARs:SetEnabled("MALOCK", true)
		CVARs:UnlockBindings()
	else
		CVARs:MSG("[Unlock] Settings Frame is toggling. ShowMenu: " .. tostring(CVARs:IsEnabled("MALOCK", false)))
	end
end

function CVARs:Lock()
	if not isToggling then
		isToggling = true
		CVARs:SetEnabled("MALOCK", false)
		CVARs:LockBindings()
	else
		CVARs:MSG("[Lock] Settings Frame is toggling. ShowMenu: " .. tostring(CVARs:IsEnabled("MALOCK", false)))
	end
end

function CVARs:IsMALockNotReady()
	if MALock == nil then
		CVARs:MSG("Settings Frame is not created yet, maybe you got an error? If not error, please install BugSack, Buggrabber to see the error.")

		return true
	end

	return false
end

function CVARs:ShowMALock()
	if CVARs:IsMALockNotReady() then return end
	CVARs:Unlock()

	if CVARs:IsEnabled("MALOCK", false) then
		for i, df in pairs(CVARs:GetDragFrames()) do
			df:EnableMouse(true)
			df:SetAlpha(1)

			if df.opt then
				df.opt:Show()
			end
		end

		if MALock then
			MALock:Show()
			MAGridFrame:Show()
			MALock:UpdateShowErrors()
		else
			CVARs:MSG("[ShowMALock] Settings Frame couldn't be created, please tell dev.")
		end
	end
end

function CVARs:HideMALock(onlyHide)
	if CVARs:IsMALockNotReady() then return end

	if not onlyHide then
		CVARs:Lock()
	end

	if not CVARs:IsEnabled("MALOCK", false) then
		for i, df in pairs(CVARs:GetDragFrames()) do
			df:EnableMouse(false)
			df:SetAlpha(0)

			if df.opt then
				df.opt:Hide()
			end
		end

		if MALock then
			MALock:Hide()
			MAGridFrame:Hide()
			MALock:UpdateShowErrors()
		else
			CVARs:MSG("[HideMALock] Settings Frame couldn't be created, please tell dev.")
		end
	end
end

function CVARs:ToggleMALock()
	if CVARs:IsMALockNotReady() then return end

	if InCombatLockdown() then
		CVARs:MSG("You are in Combat")

		return
	end

	if CVARs:IsEnabled("MALOCK", false) and MALock.save and MALock.save:IsEnabled() then
		CVARs:MSG("Can't Toggle Settings Frame when it is not saved.")

		return
	end

	if not CVARs:IsEnabled("MALOCK", false) then
		CVARs:ShowMALock()
	else
		CVARs:HideMALock()
	end
end

local inCombat = false

function CVARs:UpdateMALock()
	if CVARs:IsEnabled("MALOCK", false) and InCombatLockdown() then
		inCombat = true
		CVARs:HideMALock()
	elseif inCombat and not InCombatLockdown() then
		inCombat = false
		CVARs:ShowMALock()
	end

	C_Timer.After(0.1, CVARs.UpdateMALock)
end

-- TAINTFREE SLASH COMMANDS --
local lastMessage = ""
local cmds = {}

hooksecurefunc("ChatEdit_ParseText", function(editBox, send, parseIfNoSpace)
	if send == 0 then
		lastMessage = editBox:GetText()
	end
end)

hooksecurefunc("ChatFrame_DisplayHelpTextSimple", function(frame)
	if lastMessage and lastMessage ~= "" then
		local cmd = string.upper(lastMessage)
		cmd = strsplit(" ", cmd)

		if cmds[cmd] ~= nil then
			local count = 1
			local numMessages = frame:GetNumMessages()

			local function predicateFunction(entry)
				if count == numMessages and entry == HELP_TEXT_SIMPLE then return true end
				count = count + 1
			end

			frame:RemoveMessagesByPredicate(predicateFunction)
			cmds[cmd]()
		end
	end
end)

function CVARs:InitSlash()
	cmds["/MOVE"] = CVARs.ToggleMALock
	cmds["/MOVEANY"] = CVARs.ToggleMALock
	cmds["/RL"] = C_UI.Reload
	cmds["/REL"] = C_UI.Reload
end
-- TAINTFREE SLASH COMMANDS --