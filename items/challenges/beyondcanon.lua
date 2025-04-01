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

function fnwk_tucker_addBanned()
    for k, v in pairs(G.P_CENTERS) do
        fnwkJokerCheck(k)
    end
    for k, v in pairs(SMODS.Centers) do
        fnwkJokerCheck(k)
    end
end

local chalInfo = {
    rules = {
        custom = {
            {id = "fnwk_beyondcanon" }
        }
    },
    restrictions = {
        banned_cards = banned,
    },
    unlocked = function(self)
        for k, v in pairs(SMODS.Achievements) do
            if k == 'ach_fnwk_win_vine'  then
                return v.earned
            end
        end
    end
}

return chalInfo