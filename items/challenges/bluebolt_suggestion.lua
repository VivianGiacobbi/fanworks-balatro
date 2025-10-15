local chalInfo = {
    rules = {
        custom = {
            {id = 'fnwk_bluebolt_suggestion'},
            {id = 'fnwk_bluebolt_suggestion_2'},
        },
    },
    apply = function(self)
        G.fnwk_suggestion_startup_flag = true
    end,
    gameover = {
        endgame_type = 'lose',
        condition = {win_rank = 'Queen', start_num = 24, start_rank = 'Jack'},
        type = 'modify_deck',
        func = function(ch, endgame)
            if not G.playing_cards then return end

            if #G.playing_cards < ch.gameover.condition.start_num and not G.fnwk_suggestion_startup_flag then 
                return false
            elseif G.fnwk_suggestion_startup_flag then
                if #G.playing_cards ~= ch.gameover.condition.start_num then return end   
                G.fnwk_suggestion_startup_flag = nil
            end

            local queens = 0
            for _, v in ipairs(G.playing_cards) do
                if v.base.value == ch.gameover.condition.win_rank then
                    queens = queens + 1
                elseif v.base.value ~= ch.gameover.condition.start_rank then
                    return false
                end
            end

            if queens >= ch.gameover.condition.start_num then return true end
        end
    },
    jokers = {
        {id = 'j_fnwk_bluebolt_sexy', eternal = true },
    },
    restrictions = {
        banned_cards = {
            {id = 'j_trading' },
            {id = 'j_glass' },
            {id = 'j_caino' },
            {id = 'j_fnwk_gotequest_killing' },
            {id = 'j_fnwk_lighted_square' },
            {id = 'j_fnwk_rubicon_moonglass' },
            {id = 'j_fnwk_lipstick_bronx'},
            {id = 'j_fnwk_fanworks_bathroom'},
            {id = 'c_jojobal_diamond_hand'},
            {id = 'c_jojobal_diamond_killer'},
            {id = 'c_jojobal_stone_stone'},
            {id = 'c_jojobal_steel_d4c'},
            {id = 'c_jojobal_lion_rock'},
            {id = 'c_jojobal_lion_wonder'},
            {id = 'c_jojobal_lands_smooth'},
            {id = 'c_fnwk_bone_king'},
            {id = 'c_fnwk_bone_king_farewell'},
            {id = 'c_fnwk_glass_big'},
            {id = 'c_fnwk_last_tragic'},
            {id = 'c_fnwk_iron_shatter'},
            {id = 'c_fnwk_lighted_money'},
            {id = 'c_fnwk_rubicon_dance'},
            {id = 'c_fnwk_lighted_money'},
            {id = 'c_fnwk_bluebolt_thunder_dc'},
            {id = 'c_justice'},
            {id = 'c_hanged_man'},
            {id = 'c_tower'},
            {id = 'c_grim'},
            {id = 'c_incantation'},
            {id = 'c_immolate'},
            {id = 'm_glass'},
            {id = 'm_stone'},
        },
    },
    deck = {
        cards = {
            {s = 'S', r = 'J'},
            {s = 'S', r = 'J'},
            {s = 'S', r = 'J'},
            {s = 'S', r = 'J'},
            {s = 'S', r = 'J'},
            {s = 'S', r = 'J'},
            {s = 'H', r = 'J'},
            {s = 'H', r = 'J'},
            {s = 'H', r = 'J'},
            {s = 'H', r = 'J'},
            {s = 'H', r = 'J'},
            {s = 'H', r = 'J'},
            {s = 'C', r = 'J'},
            {s = 'C', r = 'J'},
            {s = 'C', r = 'J'},
            {s = 'C', r = 'J'},
            {s = 'C', r = 'J'},
            {s = 'C', r = 'J'},
            {s = 'D', r = 'J'},
            {s = 'D', r = 'J'},
            {s = 'D', r = 'J'},
            {s = 'D', r = 'J'},
            {s = 'D', r = 'J'},
            {s = 'D', r = 'J'},
        }
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
        custom_color = 'bluebolt',
    }
}

return chalInfo