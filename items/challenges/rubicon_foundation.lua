local chalInfo = {
    rules = {
        custom = {
            {id = 'fnwk_rubicon_foundation' },
            {id = 'fnwk_rubicon_foundation_2'}
        },
        modifiers = {
            {id = 'discards', value = 5},
        }
    },
    gameover = {
        endgame_type = 'prevent',
        condition = {suits = 2, cards = 50},
        type = 'modify_deck',
        func = function(ch, endgame)
            if not G.playing_cards then return end
            local suits_map = {}
            for _, v in ipairs(G.playing_cards) do
                suits_map[v.base.suit] = (suits_map[v.base.suit] or 0) + 1
            end

            local num_matches = 0
            for _, v in pairs(suits_map) do
                if v >= ch.gameover.condition.cards then num_matches = num_matches + 1 end
                if num_matches >= ch.gameover.condition.suits then return true end
            end
        end
    },
    vouchers = {
        { id = 'v_tarot_merchant' },
        { id = 'v_tarot_tycoon' },
        { id = 'v_magic_trick' }
    },
    restrictions = {
        banned_cards = function()
            local bans = {
                { id = 'j_marble' },
                { id = 'j_trading' },
                { id = 'j_stone' },
                { id = 'j_glass' },
                { id = 'j_smeared' },
                { id = 'j_caino', },
                { id = 'j_fnwk_gotequest_killing' },
                { id = 'j_fnwk_lighted_square' },
                { id = 'j_fnwk_mania_fragile' },
                { id = 'j_fnwk_rubicon_moonglass' },
                { id = 'j_fnwk_lipstick_bronx' },
                { id = 'c_fnwk_bone_king' },
                { id = 'c_fnwk_bone_king_farewell' },
                { id = 'c_fnwk_glass_big' },
                { id = 'c_fnwk_last_tragic' },
                { id = 'c_fnwk_iron_shatter' },
                { id = 'c_fnwk_lighted_money' },
                { id = 'c_fnwk_rubicon_dance' },
                { id = 'c_fnwk_bluebolt_thunder_dc' },
                { id = 'c_lovers' },
                { id = 'c_hanged_man' },
                { id = 'c_tower' },
                { id = 'c_immolate' },
                { id = 'm_wild' },
                { id = 'm_glass' },
                { id = 'm_stone' },
            }

            if next(SMODS.find_mod('jojobal')) then
                local jojobal_bans = {
                    { id = 'c_jojobal_diamond_hand' },
                    { id = 'c_jojobal_diamond_killer_btd' },
                    { id = 'c_jojobal_stone_stone' },
                    { id = 'c_jojobal_steel_tusk_3' },
                    { id = 'c_jojobal_steel_tusk_4' },
                    { id = 'c_jojobal_steel_d4c' },
                    { id = 'c_jojobal_lion_rock' },

                }

                for i = #jojobal_bans, 1, -1 do
                    if G.P_CENTERS[jojobal_bans[i].id] then
                        table.insert(bans, 9, jojobal_bans[i])
                    end
                end
            end

            return bans
        end,
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
    programmer = 'Vivian Giacobbi',
}

return chalInfo