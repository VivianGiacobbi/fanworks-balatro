local jokerInfo = {
	name = 'Resilient Streetlit Joker',
	config = {
		extra = {},
		form = 'resil',
		state = 'default',
		lastEdition = nil,
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	fanwork = 'streetlight',
}

SMODS.Atlas({ key = 'resil', path ='jokers/streetlight_resil.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'resil2', path ='jokers/streetlight_resil2.png', px = 71, py = 95 })

local function updateSprite(card)
	if card.ability.form then
		if card.config.center.atlas ~= card.ability.form then
			card.config.center.atlas = 'fnwk_'..card.ability.form
			card:set_sprites(card.config.center)
			card.config.center.atlas = 'fnwk_resil'
		end
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = "j_fnwk_streetlight_"..card.ability.form or self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = "j_fnwk_streetlight_"..card.ability.form or self.key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card)}
end

function jokerInfo.add_to_deck(self, card)
	card.sell_cost = math.max(1, math.floor(card.cost/2))
end

function jokerInfo.calculate(self, card, context)
	-- sets this value so it won't regenerate upon being sold
	-- amanda just lets herself get sold out
	if (context.selling_self or card.debuff) and not context.blueprint then
		card.ability.state = 'selling'
		return
	end

	if context.cardarea == G.jokers and context.joker_destroyed and context.removed == card and not context.blueprint then
		if card.ability.state == 'default' then
			card.ability.state = 'sacrifice'

			G.GAME.joker_buffer = G.GAME.joker_buffer + 1
			local newJoker = create_card('Joker', G.jokers, nil, 2, true, nil, 'j_fnwk_streetlight_resil', 'rif')
			newJoker:set_edition({negative = true}, true, true)

			newJoker.config.center.eternal_compat = true
			newJoker:set_eternal(true)
			newJoker.config.center.eternal_compat = false

			
			newJoker.ability.state = 'hidden'
			newJoker.ability.lastEdition = card.edition and card.edition.type or nil

			newJoker.ability.form = 'resil2'
			updateSprite(newJoker)

			newJoker:add_to_deck()
			G.jokers:emplace(newJoker)
			newJoker:start_materialize()
			G.GAME.joker_buffer = 0
			-- create specific tarot subset to synergize with vampire
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit  then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				local tarot_subset = {'c_magician', 'c_empress', 'c_heirophant', 'c_lovers', 'c_chariot', 'c_justice', 'c_devil', 'c_tower'}
				local get_tarot = pseudorandom_element(tarot_subset, pseudoseed('resil'))
				G.E_MANAGER:add_event(Event({
					func = function() 
						local newTarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, get_tarot, 'car')
						newTarot:add_to_deck()
						G.consumeables:emplace(newTarot)
						G.GAME.consumeable_buffer = 0
					return true
				end}))  
			end
		end
	end

	if context.end_of_round and context.individual and not context.blueprint then	
		-- avoid regenerating if there's not an available slot
		-- I.E. the player used Judgement during a run
		if card.ability.state == 'hidden' then
			card.ability.state = 'retire'
			if #G.jokers.cards + G.GAME.joker_buffer >= G.jokers.config.card_limit then
				G.E_MANAGER:add_event(Event({func = function()
					card:start_dissolve(nil, false)
					return true 
				end}))
			else
				-- recreate the resil
				card.config.center.eternal_compat = true
				card:set_eternal(false)
				card.config.center.eternal_compat = false

				local lastEdition = card.ability.lastEdition
				if not lastEdition then
					card:set_edition({negative = false}, true, true)
				else
					if lastEdition == "foil" then
						card:set_edition({foil = true}, true, true)
					elseif lastEdition == "holo" then
						card:set_edition({holo = true}, true, true)
					elseif lastEdition == "polychrome" then
						card:set_edition({polychrome = true}, true, true)
					elseif lastEdition == "negative" then
						card:set_edition({negative = true}, true, true)
					end
				end			

				card:juice_up()
				play_sound('tarot2')

				card.ability.state = 'default'
				card.ability.form = 'resil'
				updateSprite(card)
			end
		end
	end	
end

function jokerInfo.update(self, card)
	if card.area and card.area.config.type == "shop" then
		card.ability.form = 'resil'
		updateSprite(card)
	end

	if card.area and card.area.config.collection and self.discovered then
        card.ability.form = 'resil'
		updateSprite(card)
    end
end

return jokerInfo
	