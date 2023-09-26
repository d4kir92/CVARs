function D4:msg(msg)
    print("[D4] " .. msg)
end

function D4:MSG(name, icon, msg)
    print(format("[|cFFA0A0FF%s|r |T%s:0:0:0:0|t] %s", name, icon, msg))
end