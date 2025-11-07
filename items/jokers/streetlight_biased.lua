local jokerInfo = {
	name = 'Biased Joker',
	config = {
		extra = {
			dollars = 2
		}
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
	artist = 'Leafgilly',
	programmer = 'Vivian Giacobbi',
}

local function debuff_helper(card)
	if G.GAME.blind then
		G.GAME.blind:debuff_card(card)
		return
	end

	SMODS.calculate_context({ debuff_card = card, ignore_debuff = true })
	local flags = SMODS.calculate_context({ debuff_card = card, ignore_debuff = true })
	if flags.prevent_debuff then
		if card.debuff then card:set_debuff(false) end
		return
	elseif flags.debuff then
		if not card.debuff then card:set_debuff(true) end
		return
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.dollars}}
end

function jokerInfo.calculate(self, card, context)
	if not context.blueprint and not context.retrigger_joker and context.created_card then
		debuff_helper(context.created_card)
		return
	end

	if not context.blueprint and not context.retrigger_joker and (context.card_added or context.playing_card_added or context.removed_card or context.remove_playing_cards) then
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				for _, v in ipairs(G.playing_cards) do debuff_helper(v) end
				for _, v in ipairs(G.jokers.cards) do debuff_helper(v) end
				return true
			end
		}))
	end

	if not context.blueprint and not context.retrigger_joker and context.debuff_card and not card.ability.fnwk_biased_removed then
		local women = G.fnwk_women.get_from_key(context.debuff_card.config.center.key)
		if women.trans or women.woman or women.girl or context.debuff_card:get_id() == 12 then
			return {
				debuff = true
			}
		end
	end

	if context.using_consumeable and context.consumeable.ability.set == 'Tarot' then
        return {
			dollars = card.ability.extra.dollars
		}
    end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	card.ability.fnwk_biased_removed = nil
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		func = function()
			for _, v in ipairs(G.playing_cards) do debuff_helper(v) end
    		for _, v in ipairs(G.jokers.cards) do debuff_helper(v) end
        	return true
    	end
	}))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	card.ability.fnwk_biased_removed = true
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		func = function()
			for _, v in ipairs(G.playing_cards) do debuff_helper(v) end
    		for _, v in ipairs(G.jokers.cards) do debuff_helper(v) end
        	return true
    	end
	}))
end

return jokerInfo