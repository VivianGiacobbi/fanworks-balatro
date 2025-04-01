function containsKey(table, key)
	return table[key] ~= nil
end

local banned = {}
local function fnwkJokerCheck(k)
    if not banned[k] then
        if StringStartsWith(k, "j_") then
            if not StringStartsWith(k, "j_fnwk_") then
                banned[#banned+1] = { id = k }
            end
        end
    end
end

function fnwk_beyondcanon_addBanned()
    for k, v in pairs(G.P_CENTERS) do
        fnwkJokerCheck(k)
    end
    sendDebugMessage(#banned)
end

local chalInfo = {
    rules = {
        custom = {
            {id = "fnwk_beyondcanon" }
        }
    },
    restrictions = {
        banned_cards = banned,
    }
}

return chalInfo