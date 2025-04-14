local jokerInfo = {
    name = 'Kunst',
	config = {
        extra = {
            upgrade_mod = 2,
        },
    },
	rarity = 4,
	cost = 20,
    unlocked = false,
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'jspec'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
    return { vars = { FnwkCountGrammar(card.ability.extra.upgrade_mod) }}
end

function jokerInfo.calculate(self, card, context)
    if not (context.cardarea == G.jokers and context.end_of_round and G.GAME.blind.boss) then
        return
    end

    local juice_card = context.blueprint_card or card

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        juice_card:juice_up(0.8, 0.1)
        attention_text({
            text = localize('k_kunst_hm'),
            scale = 1, 
            hold = 0.7,
            backdrop_colour = G.C.FILTER,
            align = 'bm',
            major = juice_card,
            offset = {x = 0, y = 0.05*juice_card.T.h}
        })
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        juice_card:juice_up(0.8, 0.1)
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        juice_card:juice_up(0.8, 0.1)
        attention_text({
            text = localize('k_kunst_acceptable'),
            scale = 1, 
            hold = 0.7,
            backdrop_colour = G.C.FILTER,
            align = 'bm',
            major =  juice_card,
            offset = {x = 0, y = 0.05* juice_card.T.h}
        })
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+'..card.ability.extra.upgrade_mod})
    delay(1.3)
    fnwk_batch_level_up(card, SMODS.PokerHands, card.ability.extra.upgrade_mod)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

return jokerInfo