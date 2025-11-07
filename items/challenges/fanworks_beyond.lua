local chalInfo = {
    rules = {
        custom = {
            {id = "fnwk_fanworks_beyond" }
        }
    },
    restrictions = {
        banned_cards = function()
            local banned = {}
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and (not v.original_mod or v.original_mod.id ~= 'fanworks') then
                     banned[#banned+1] = k
                end
            end
            return {{id = 'j_fnwk_banned_jokers', ids = banned}}
        end,
    },
    fanwork = 'fanworks',
    programmer = 'Vivian Giacobbi',
}

return chalInfo