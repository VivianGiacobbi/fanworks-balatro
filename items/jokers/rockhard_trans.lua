local jokerInfo = {
	name = 'Trans Am',
	config = {
        extra = 3
    },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
	artist = 'Stupisms',
    programmer = 'Vivian Giacobbi',
}

function jokerInfo.calculate(self, card, context)
	if context.after and G.GAME.current_round.hands_left == 0 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = function()
                local newTarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil,'c_fool', 'car')
                newTarot:set_edition({negative = true}, true)
                newTarot:add_to_deck()
                G.consumeables:emplace(newTarot)
                G.GAME.consumeable_buffer = 0
            return true
        end}))
        return {
            message = localize('k_plus_fool'),
            card = context.blueprint_card or card
        }
	end
end

return jokerInfo