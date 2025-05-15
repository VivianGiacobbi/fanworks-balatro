local jokerInfo = {
	name = 'Bizarre Jester',
	config = {},
	rarity = 1,
	cost = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    fanwork = 'fanworks',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.jester }}
end

function jokerInfo.calculate(self, card, context)
    if not context.setting_blind or (context.blueprint_card or card).getting_sliced then
        return
    end

    if #G.jokers.cards + G.GAME.joker_buffer >= G.jokers.config.card_limit then
        return
    end

    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
    G.E_MANAGER:add_event(Event({
        func = function() 
            local old_banned = copy_table(G.GAME.banned_keys)
            for k, v in pairs(G.P_CENTERS) do
                if not FnwkStringStartsWith(k, "j_fnwk_") then
                    G.GAME.banned_keys[k] = true
                end
            end
            local new_fnwk_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'jes')
            new_fnwk_card:add_to_deck()
            G.jokers:emplace(new_fnwk_card)
            new_fnwk_card:start_materialize()
            G.GAME.joker_buffer = 0
            G.GAME.banned_keys = old_banned
            return true
        end
    }))   
    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.FANWORKS}) 
end

return jokerInfo