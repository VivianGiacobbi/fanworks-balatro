local chalInfo = {
    consumables = {
        { id = 'c_fnwk_crimson_cough', eternal = true}
    },
    restrictions = {
        banned_cards = function()
            local bans = {
                { id = 'j_marble' },
                { id = 'j_steel_joker' },
                { id = 'j_midas_mask' },
                { id = 'j_stone' },
                { id = 'j_lucky_cat' },
                { id = 'j_glass' },
                { id = 'j_golden' },
                { id = 'j_smeared' },
                { id = 'j_fnwk_bone_samurai' },
                { id = 'j_fnwk_moscow_mule' },
                { id = 'j_fnwk_crimson_golden' },
                { id = 'j_fnwk_gotequest_lambiekins' },
                { id = 'j_fnwk_mania_fragile' },
                { id = 'j_fnwk_rubicon_moonglass' },
                { id = 'j_fnwk_streetlight_pinstripe' },
                { id = 'c_fnwk_bone_king' },
                { id = 'c_fnwk_bone_king_farewell' },
                { id = 'c_fnwk_glass_big' },
                { id = 'c_fnwk_iron_shatter' },
                { id = 'c_fnwk_lighted_money' },
                { id = 'c_fnwk_spirit_ultimate' },
            }

            if next(SMODS.find_mod('jojobal')) then
                local jojobal_bans = {
                    { id = 'c_jojobal_lion_wonder' },
                    { id = 'c_jojobal_diamond_echoes_3' },
                    { id = 'c_jojobal_vento_gold' },
                    { id = 'c_jojobal_vento_gold_requiem' },
                    { id = 'c_jojobal_stone_stone' },
                    { id = 'c_jojobal_steel_d4c' },
                    { id = 'c_jojobal_steel_d4c_love' },
                    { id = 'c_jojobal_lion_soft' },
                    { id = 'c_jojobal_lion_soft_beyond' },
                    { id = 'c_jojobal_lion_rock' },
                    
                }

                for i = #jojobal_bans, 1, -1 do
                    if G.P_CENTERS[jojobal_bans[i].id] then
                        table.insert(bans, 9, jojobal_bans[i])
                    end
                end
            end

            local enhancement_map = {}
            for _, v in pairs(G.P_CENTER_POOLS.Enhanced) do
                if v.key ~= 'm_wild' then
                    bans[#bans+1] = { id = v.key }
                    enhancement_map[v.key] = true
                end
            end

            for _, v in pairs(G.P_CENTER_POOLS.Consumeables) do
                if enhancement_map[v.config.mod_conv] and v.config.mod_conv ~= 'm_wild' then
                    bans[#bans+1] = { id = v.key }
                end
            end
            
            return bans
        end,

        banned_other = {
            {id = 'bl_club', type = 'blind'},
            {id = 'bl_goad', type = 'blind'},
            {id = 'bl_window', type = 'blind'},
            {id = 'bl_head', type = 'blind'}
        }
    },
    deck = {
        enhancement = 'm_wild'
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'crimson',
		},
        custom_color = 'crimson',
    }
}

return chalInfo