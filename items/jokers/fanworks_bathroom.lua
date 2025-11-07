SMODS.Sound({key = "terlet", path = "terlet.ogg"})
SMODS.Sound({key = "flush", path = "flush.ogg"})
SMODS.Sound({key = "fart_reverb", path = "fart_reverb.ogg"})

local jokerInfo = {
	name = '#the-bathroom',
	config = {},
	rarity = 2,
	cost = 6,
    unlocked = false,
    unlock_condition = {type = 'fnwk_discovered_card'},
    no_collection = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
    programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { '#' } }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    local discovered, total = ArrowAPI.game.check_mod_discoveries('fanworks', nil, self)
    return { vars = { discovered, total } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end

    local discovered, total = ArrowAPI.game.check_mod_discoveries('fanworks', nil, self)

    if discovered >= total then
        self.no_collection = nil
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.blueprint then
        return
    end

    if context.before and not card.debuff and context.scoring_name == 'Flush' and #G.hand.cards > 0 then
        local rand_card = pseudorandom_element(G.hand.cards, pseudoseed('bathroom'))
        rand_card.bathroom_flag = true
        return
    end

    if context.destroy_card and not card.debuff and context.destroy_card.bathroom_flag then
        context.destroy_card.bathroom_flag = nil
        local rand_idx = math.random(1, 5)
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize('k_toilet'..rand_idx),
            message_card = card,
			sound = 'fnwk_terlet',
            delay = 1.2,
		})
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                play_sound('fnwk_fart_reverb', 1, 0.75)
                return true
            end
        }))
        return {
            delay = 0.5,
            remove = true,
            card = context.destroy_card,
            message = localize('k_flush'),
            sound = 'fnwk_flush',
        }
    end
end

return jokerInfo