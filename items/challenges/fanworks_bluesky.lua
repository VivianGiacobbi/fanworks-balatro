local chalInfo = {
    rules = {
        custom = {
            {id = "fnwk_fanworks_bluesky" }
        }
    },
    jokers = {
        { id = 'j_blueprint', eternal = true },
        { id = 'j_brainstorm', eternal = true }
    },
    restrictions = {
        banned_cards = function()
            local banned = {}
            for k, v in pairs(G.P_CENTERS) do
                if (v.set == 'Joker' and v.rarity ~= 1) or (v.set == 'Stand' and v.config.evolved) then
                    banned[#banned+1] = k
                end
            end
            return {
                { id = 'j_fnwk_banned_commons', ids = banned},
                { id = 'j_fnwk_streetlight_arrow' },
                { id = 'c_arrow_spec_diary' },
                { id = 'v_arrow_plant' },
            }
        end,
        banned_tags = {
            {id = 'tag_rare'}
        },
    },
    fanwork = 'fanworks',
    programmer = 'Vivian Giacobbi',
}

return chalInfo