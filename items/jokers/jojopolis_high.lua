local jokerInfo = {
	name = 'From On High',
	config = {},
	rarity = 3,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'jojopolis',
		},
        custom_color = 'jojopolis',
    },
}

function jokerInfo.calculate(self, card, context)
	if context.mod_handlevel and (context.arrow_highlight_level or context.arrow_initial_level) then
		local highest = 0
		for k, v in pairs(G.GAME.hands) do
			if v.level > highest then highest = v.level end
		end

		if context.initial then
			G.E_MANAGER:add_event(Event({
				func = function()
					card:juice_up()
					G.hand_text_area.handname:juice_up()
    				G.hand_text_area.hand_level:juice_up()
					play_sound('polychrome1')
				return true
			end }))
			delay(0.3)
		end

		return {
			numerator = highest
		}
	end
end

return jokerInfo