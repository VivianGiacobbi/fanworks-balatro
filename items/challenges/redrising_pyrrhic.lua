local chalInfo = {
    rules = {
        custom = {
            {id = 'fnwk_redrising_pyrrhic'},
            {id = 'fnwk_redrising_pyrrhic_2'},
        },
        modifiers = {
            {id = 'consumable_slots', value = 3}
        }
    },
    apply = function(self)
        G.fnwk_pyrrhic_startup_flag = true
    end,
    gameover = {
        endgame_type = 'win',
        condition = {lose_reps = 0},
        func = function(ch, endgame)
            local invisible = SMODS.find_card('c_fnwk_redrising_invisible', true)[1]
            if not invisible and not G.fnwk_pyrrhic_startup_flag then 
                return false
            elseif G.fnwk_pyrrhic_startup_flag then
                if not invisible then return end   
                G.fnwk_pyrrhic_startup_flag = nil
            end
            if invisible.ability.extra.reps <= ch.gameover.condition.lose_reps then
                return false
            end
        end
    },
    consumeables = {
        { id = 'c_fnwk_redrising_invisible', eternal = true },
        { id = 'c_hanged_man' },
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'redrising',
		},
        custom_color = 'redrising',
    }
}

return chalInfo