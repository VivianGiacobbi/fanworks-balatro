local jokerInfo = {
	name = 'Resilient Joker',
	config = {
		extra = {
			mult = 0,
			mult_mod = 3,
			cost_mod = 1,
			times_sold = 0,
			sell_mod = 1
		},
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
	artist = 'mal',
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.mult_mod,
			card.ability.extra.cost_mod,
			card.ability.extra.mult,
		},
		key = self.key..(card.ability.fnwk_resil_form or '')}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	if from_debuff then return end
	card:set_cost()
	if card.ability.fnwk_resil_form then
		FnwkReviveEffect(card)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 1,
			func = function()
				card.children.center:set_sprite_pos({x = 0, y = 0})
				return true
			end
		}))
		
		card.ability.fnwk_resil_form = nil
	end

	if not card.ability.fnwk_resil_id then
		if not G.GAME.fnwk_unique_resils then
			G.GAME.fnwk_unique_resils = (G.GAME.fnwk_unique_resils or 0) + 1
		end
		card.ability.fnwk_resil_id = G.GAME.fnwk_unique_resils
	else
		-- handles what occurs on copying
		local other_resils = SMODS.find_card(self.key)
		if next(other_resils) then
			for _, v in ipairs(other_resils) do
				if v ~= card and v.ability.fnwk_resil_id == card.ability.fnwk_resil_id then
					G.GAME.fnwk_unique_resils = G.GAME.fnwk_unique_resils + 1
					card.ability.fnwk_resil_id = G.GAME.fnwk_unique_resils
					return
				end
			end
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end
	-- sets this value so it won't regenerate upon being sold
	-- amanda just lets herself get sold out

	if context.joker_main and card.ability.extra.mult > 0 then
		return {
			mult = card.ability.extra.mult,
			card = context.blueprint_card or card
		}
	end

	if context.blueprint then return end
	if context.selling_self or card.fnwk_resil_sold then
		card.fnwk_resil_sold = true
		return
	end

	if context.end_of_round and context.main_eval and context.beat_boss then
		G.E_MANAGER:add_event(Event({func = function()
			play_sound('slice1', 0.96+math.random()*0.08)
			card:start_dissolve()
			return true
		end}))

		if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			local tarot_subset = {}
			for _, v in pairs(G.P_CENTER_POOLS.Tarot) do
                if v.config.mod_conv then
                    tarot_subset[#tarot_subset+1] = v.key
                end
            end
			
			local get_tarot = pseudorandom_element(tarot_subset, pseudoseed('fnwk_streetlight_resil'))
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card({area = G.consumables, key = get_tarot})
					G.GAME.consumeable_buffer = 0
				return true
			end}))
		end
		return
	end

	if context.removed_card == card then
		card.ability.extra.times_sold = card.ability.extra.times_sold + card.ability.extra.sell_mod
		scale_table = { mult_mod = card.ability.extra.mult_mod * G.GAME.round_resets.ante }
		SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "times_sold", scalar_value = "sell_mod", no_message = true,})
		SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "mult", scalar_table = scale_table, scalar_value = "mult_mod", no_message = true,})
		G.GAME.fnwk_saved_resils[#G.GAME.fnwk_saved_resils+1] = {
			key = card.config.center.key,
			id = card.ability.fnwk_resil_id,
			mult = card.ability.extra.mult,
			times_sold = card.ability.extra.times_sold,
			edition = card.edition and 'e_'..card.edition.type or nil
		}

		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_sacrifice'),
			colour = G.C.DARK_EDITION,
			instant = true
		})
	end
end

return jokerInfo