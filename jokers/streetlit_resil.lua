local jokerInfo = {
	name = 'Resilient Streetlit Joker',
	config = {
		extra = {
			form = "resil",
			beingSold = false,
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	streamer = "other",
}

SMODS.Atlas({ key = "resil", path ="jokers/streetlit_resil.png", px = 71, py = 95 })
SMODS.Atlas({ key = "resil2", path ="jokers/streetlit_resil2.png", px = 71, py = 95 })

local function updateSprite(card)
	if card.ability.extra.form then
		if card.config.center.atlas ~= card.ability.extra.form then
			card.config.center.atlas = "fnwk_"..card.ability.extra.form
			card:set_sprites(card.config.center)
		end
	end
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = "j_fnwk_streetlit_"..card.ability.extra.form or self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = "j_fnwk_streetlit_"..card.ability.extra.form or self.key, set = self.set, nodes = desc_nodes, vars = {}}
end

function jokerInfo.add_to_deck(self, card)
	card.sell_cost = math.max(1, math.floor(card.cost/2))
end

function jokerInfo.calculate(self, card, context)
	if context.selling_self and not context.blueprint then
		card.ability.extra.beingSold = true
		return
	end
	if context.joker_destroyed and not context.blueprint then
		if context.end_of_round and not G.GAME.lastResil then
			-- this case means that the card's effect either failed to activate because of a debuff
			-- or it destroyed itself when trying to regenerate due to no space
			card.ability.extra.form = 'resil'
			updateSprite(card)
		elseif not card.ability.extra.beingSold and not card.debuff then 
			G.GAME.lastResil = {edition = card.edition and card.edition.type or nil}

			-- create specific tarot subset to synergize with vampire
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit  then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				local tarot_subset = {'c_magician', 'c_empress', 'c_heirophant', 'c_lovers', 'c_chariot', 'c_justice', 'c_devil', 'c_tower'}
				local get_tarot = pseudorandom_element(tarot_subset, pseudoseed('resil'))
				G.E_MANAGER:add_event(Event({
					func = function() 
						local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, get_tarot, 'car')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
					return true
				end}))  
			end
			
			G.GAME.joker_buffer = G.GAME.joker_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function() 
					local card = create_card('Joker', G.jokers, nil, 2, nil, nil, 'j_fnwk_streetlit_resil', 'rif')
					card:set_edition({negative = true}, true, true)

					card.config.center.eternal_compat = true
					card:set_eternal(true)
					card.config.center.eternal_compat = false

					card.ability.extra.form = 'resil2'
					updateSprite(card)

					card:add_to_deck()
					G.jokers:emplace(card)
					card:start_materialize()
					G.GAME.joker_buffer = 0
					updateSprite(card)
				return true
			end}))
		end
		
		card.ability.extra.beingSold = false
	end

	if context.end_of_round and not context.blueprint and G.GAME.lastResil then
		-- avoid regenerating if there's not an available slot
		-- I.E. the player used Judgement during a run
		if #G.jokers.cards + G.GAME.joker_buffer >= G.jokers.config.card_limit then
			G.E_MANAGER:add_event(Event({func = function()
				card:start_dissolve(nil, false)
				return true 
			end}))
			return
		else
			-- recreate the resil
			local lastResil = G.GAME.lastResil

			card.config.center.eternal_compat = true
			card:set_eternal(false)
			card.config.center.eternal_compat = false
			card:set_edition({negative = false}, true, true)

			if lastResil['edition'] then
				if lastResil['edition'] == "foil" then
					card:set_edition({foil = true}, true, true)
				elseif lastResil['edition'] == "holo" then
					card:set_edition({holo = true}, true, true)
				elseif lastResil['edition'] == "polychrome" then
					card:set_edition({polychrome = true}, true, true)
				elseif lastResil['edition'] == "negative" then
					card:set_edition({negative = true}, true, true)
				end
			end			

			card:juice_up()
			play_sound('tarot2')
		end

		card.ability.extra.form = 'resil'
		updateSprite(card)
		G.GAME.lastResil = nil
	end
end

function jokerInfo.update(self, card)
	if G.screenwipe then
		updateSprite(card)
	end
end

return jokerInfo
	