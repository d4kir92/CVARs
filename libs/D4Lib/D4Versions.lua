local AddonName, _ = ...
D4VersionTab = D4VersionTab or {}
local pre = "D4PREFIX"
C_ChatInfo.RegisterAddonMessagePrefix(pre)
function D4:SetVersion(name, icon, ver)
    if name == nil then
        D4:msg("|cffff0000MISSING NAME AT SetVersion", ver)

        return false
    end

    if icon == nil then
        D4:msg("|cffff0000MISSING ICON AT SetVersion", icon)

        return false
    end

    if ver == nil then
        D4:msg("|cffff0000MISSING VERSION AT SetVersion", ver)

        return false
    end

    if D4VersionTab[string.lower(name)] ~= nil then
        D4:msg("|cffff0000VERSION ALREADY SET", name)

        return false
    end

    local index = string.lower(name)
    D4VersionTab[index] = {}
    D4VersionTab[index].name = name
    D4VersionTab[index].version = ver
    D4VersionTab[index].icon = icon
    D4VersionTab[index].foundHigher = false
    local nameOrder = {}
    for k, v in pairs(D4VersionTab) do
        tinsert(nameOrder, string.lower(k))
    end

    table.sort(nameOrder)
    local id = 0
    for i, v in pairs(nameOrder) do
        id = id + 1
        D4VersionTab[string.lower(v)].id = id
    end
end

function D4:GetVersion(name)
    if name == nil then
        D4:msg("|cffff0000MISSING NAME AT GetVersion")

        return false
    end

    if name and D4VersionTab[string.lower(name)] then return D4VersionTab[string.lower(name)].version end

    return nil
end

function D4:FoundHigher(name)
    if name == nil then
        D4:msg("|cffff0000MISSING NAME AT FoundHigher")

        return false
    end

    if name and D4VersionTab[string.lower(name)] then return D4VersionTab[string.lower(name)].foundHigher end

    return false
end

function D4:IsHigherVersion(ov1, ov2, ov3, cv1, cv2, cv3)
    if ov1 > cv1 then
        return true
    elseif ov1 == cv1 then
        if ov2 > cv2 then
            return true
        elseif ov2 == cv2 then
            if ov3 > cv3 then return true end
        end
    end

    return false
end

function D4:CheckVersion(name, ver)
    if name == nil then
        D4:msg("|cffff0000MISSING NAME AT CheckVersion")

        return false
    end

    local ov1, ov2, ov3 = string.split(".", ver)
    local cv1, cv2, cv3 = string.split(".", D4:GetVersion(name))
    local higher = D4:IsHigherVersion(ov1, ov2, ov3, cv1, cv2, cv3)
    if higher and name and D4VersionTab and D4VersionTab[string.lower(name)] then
        D4VersionTab[string.lower(name)].foundHigher = true
        D4:MSG(name, D4VersionTab[string.lower(name)].icon, format("New Version available (v%s -> v%s)", D4:GetVersion(name), ver))
    end
end

local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript(
    "OnEvent",
    function(sel, event, isInitialLogin, isReloadingUi)
        C_Timer.After(
            2,
            function()
                --[[  local id = 0
                for i, v in pairs(D4VersionTab) do
                    id = id + 1
                    if i == AddonName then break end
                end]]
                local id = D4VersionTab[string.lower(AddonName)].id or 0
                C_Timer.After(
                    id * 0.1,
                    function()
                        local ver = D4:GetVersion(AddonName)
                        if ver == nil then
                            D4:MSG(AddonName, 0, "|cffff0000MISSING VERSION", AddonName)
                        end

                        if true and ver and pre then
                            C_ChatInfo.SendAddonMessage(pre, format("A;%s;V;%s", AddonName, ver), "GUILD")
                        end
                    end
                )
            end
        )
    end
)

local r = CreateFrame("FRAME")
r:RegisterEvent("CHAT_MSG_ADDON")
r:SetScript(
    "OnEvent",
    function(sel, event, pref, msg, ...)
        if pref == pre and msg then
            local a, name, v, ver = string.split(";", msg)
            if a and name and v and ver and a == "A" and v == "V" and AddonName == name and not D4:FoundHigher(name) then
                D4:CheckVersion(name, ver)
            end
        end
    end
)