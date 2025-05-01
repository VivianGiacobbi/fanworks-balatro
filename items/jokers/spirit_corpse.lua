local jokerInfo = {
	name = 'Corpse Crimelord',
	config = {
        extra = { 
            money = 0
        },
        last_digits = 0
    },
	rarity = 3,
	cost = 10,
    hasSoul = true,
    unlocked = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'spirit',
}

local function get_dollar_digits()
    if G.GAME.dollars <= 0 then
        return 0
    end

    local slots = math.floor(math.log(G.GAME.dollars, 10)) + 1
    return slots
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= 'saved_from_death' then
        return false
    end

    return true
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    card:set_rental(true)
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.durandal }}
    return { vars = { card.ability.extra.money, card.ability.extra.slots} }
end

function jokerInfo.calculate(self, card, context)
    if context.change_dollars and context.cardarea == G.jokers then
        local dollar_digits = get_dollar_digits()
        if card.ability.last_digits == dollar_digits then
            return
        end
        local diff = dollar_digits - card.ability.last_digits
        G.jokers.config.card_limit = G.jokers.config.card_limit + diff
        card.ability.last_digits = dollar_digits
    end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    card.ability.last_digits = get_dollar_digits()
    G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.last_digits
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    card.ability.last_digits = get_dollar_digits()
    G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.last_digits
end

return jokerInfo