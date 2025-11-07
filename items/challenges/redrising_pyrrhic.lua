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
    post_apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local invisible = SMODS.find_card('c_fnwk_redrising_invisible', true)[1]
                invisible.ability.extra.reps = 3
                invisible.ability.extra.reps_max = 6
                return true
            end
        }))
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
        { id = 'c_hanged_man' },
    },
    vouchers = {
        { id = 'v_crystal_ball'},
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'redrising',
		},
        custom_color = 'redrising',
    },
    programmer = 'Vivian Giacobbi',
}

return chalInfo