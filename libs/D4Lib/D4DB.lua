function D4:GV(db, key, value)
    if db == nil then
        D4:msg("[D4:SV] db is nil")

        return value
    end

    if type(db) ~= "table" then
        D4:msg("[D4:SV] db is not table")

        return value
    end

    if db[key] ~= nil then return db[key] end

    return value
end

function D4:SV(db, key, value)
    if db == nil then
        D4:msg("[D4:SV] db is nil")

        return false
    end

    if key == nil then
        D4:msg("[D4:SV] key is nil")

        return false
    end

    db[key] = value
end