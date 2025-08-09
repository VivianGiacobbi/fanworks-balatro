local jokerInfo = {
	name = 'Corpse Crimelord',
	config = {
        extra = { 
            slot_mod = 1,
            cost_mod = 1
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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
	artist = 'durandal'
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

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.slot_mod, card.ability.extra.cost_mod} }
end

function jokerInfo.calculate(self, card, context)
    if context.blueprint or context.retrigger_joker then return end

    if context.fnwk_change_dollars and context.cardarea == G.jokers then
        local dollar_digits = get_dollar_digits()
        if card.ability.last_digits == dollar_digits then
            return
        end
        local diff = dollar_digits - card.ability.last_digits
        G.jokers.config.card_limit = G.jokers.config.card_limit + diff * card.ability.extra.slot_mod
        card.ability.last_digits = dollar_digits
    end

    if context.end_of_round and context.main_eval and not card.getting_sliced then
        local count = 0
        local other_crimelords = {}
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_fnwk_spirit_corpse' then
                if v ~= card then
                    if count == 0 then break end
                    other_crimelords[#other_crimelords+1] = v
                    v.getting_sliced = true
                end

                count = count + 1
            end
        end

        if #other_crimelords > 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    for _, v in ipairs(other_crimelords) do
                        v:start_dissolve({HEX("57ecab")}, i ~= 0)
                    end
                    play_sound('slice1', 0.96+math.random()*0.08)                
                    return true
                end
            }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_valentino'), colour = G.C.GREEN, no_juice = true})
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local mod = #G.jokers.cards * card.ability.extra.cost_mod
                ease_dollars(-mod)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = '-$'..mod, colour = G.C.MONEY})
                return true
            end
        }))
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