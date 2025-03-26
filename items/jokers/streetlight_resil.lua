local jokerInfo = {
	name = 'Resilient Joker',
	config = {
		extra = {},
		form = 'normal',
		state = 'default',
		lastEdition = nil,
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	fanwork = 'streetlight',
	alt_art = true
}

SMODS.Atlas({ key = 'streetlight_resil_regen', path ='jokers/streetlight_resil_regen.png', px = 71, py = 95 })

local function updateSprite(card)
	if card.ability.form then
		if card.ability.form == 'regen' then
			local old_atlas = card.config.center.atlas
			card.config.center.atlas = 'fnwk_streetlight_resil_regen'
			card:set_sprites(card.config.center)
			card.config.center.atlas = old_atlas
		else
			card:set_sprites(card.config.center)
		end
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	local info_key = 'j_fnwk_streetlight_resil'
	if card.ability.form == 'regen' then
		info_key = info_key..'_regen'
	end
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = info_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = info_key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card)}
end

function jokerInfo.add_to_deck(self, card)
	card.sell_cost = math.max(1, math.floor(card.cost/2))
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end
	-- sets this value so it won't regenerate upon being sold
	-- amanda just lets herself get sold out
	if (context.selling_self or card.debuff) then
		card.ability.state = 'selling'
		return
	end

	if context.cardarea == G.jokers and context.joker_destroyed and context.removed == card then
		if card.ability.state == 'default' then
			card.ability.state = 'sacrifice'

			G.GAME.joker_buffer = G.GAME.joker_buffer + 1
			local new_joker = create_card('Joker', G.jokers, nil, 2, true, nil, 'j_fnwk_streetlight_resil', 'resilient')
			new_joker:set_edition({negative = true}, true, true)

			new_joker.config.center.eternal_compat = true
			new_joker:set_eternal(true)
			new_joker.config.center.eternal_compat = false

			
			new_joker.ability.state = 'hidden'
			new_joker.ability.lastEdition = card.edition and card.edition.type or nil

			new_joker.ability.form = 'regen'
			updateSprite(new_joker)

			new_joker:add_to_deck()
			new_joker:hard_set_T(card.T.x, card.T.y, card.T.w, card.T.h)
			G.jokers:emplace(new_joker)
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

			-- hopefully interrupting the dissolve wont fuck things up?
			card:remove()
			new_joker:juice_up()
		end
	end

	if context.end_of_round and context.individual then	
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
				card.ability.form = 'normal'
				updateSprite(card)
			end
		end
	end	
end

return jokerInfo
	