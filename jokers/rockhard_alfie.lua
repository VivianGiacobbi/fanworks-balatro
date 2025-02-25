local jokerInfo = {
    key = 'j_fnwk_rockhard_alfie',
	name = 'Alfie',
	config = {
        extra = {
            used_this_round = false
        },
    },
	rarity = 1,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rockhard',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cringe", set = "Other"}
end

function jokerInfo.calculate(self, card, context)
    if G.GAME.current_round.packs_rerolled == 0 and context.cardarea == G.jokers and context.open_booster then         
        card.ability.last_booster_cost = context.card.cost
        card.ability.last_booster_pos = context.card.ability.booster_pos

        local eval = function(card) 
            return G.GAME.current_round.packs_rerolled == 0
        end
        juice_card_until(card, eval, true, 0.6)
    end

    if G.GAME.current_round.packs_rerolled == 0 and context.cardarea == G.jokers and context.skipping_booster then
        G.GAME.current_round.used_packs[card.ability.last_booster_pos] = get_pack('shop_pack').key
        G.GAME.current_round.packs_rerolled = G.GAME.current_round.packs_rerolled and G.GAME.current_round.packs_rerolled + 1 or 1
        ease_dollars(card.ability.last_booster_cost, true)
        card:juice_up(0.3, 0.5)
        play_sound('generic1')
        G.E_MANAGER:add_event(Event({
            blocking = false,
            blockable = false,
            trigger = 'after', 
            delay = 1.25,
            func = function()
                local new_booster = Card(
                    G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27,
                    G.CARD_H*1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[G.GAME.current_round.used_packs[card.ability.last_booster_pos]],
                    {bypass_discovery_center = true, bypass_discovery_ui = true})
                create_shop_card_ui(new_booster, 'Booster', G.shop_booster)
                new_booster.ability.booster_pos = card.ability.last_booster_pos
                new_booster:start_materialize()
                G.shop_booster:emplace(new_booster)
                G.E_MANAGER:add_event(Event({
                    blocking = false,
                    blockable = false,
                    trigger = 'after', 
                    delay = 0.2,
                    func = function()
                        attention_text({
                            text = localize('k_pack_replaced'),
                            scale = 1, 
                            hold = 0.8,
                            backdrop_colour = G.C.DARK_EDITION,
                            align = 'tm',
                            major = new_booster,
                            offset = {x = 0, y = 0.15 * G.CARD_H}
                        })
                        play_sound('generic1', 1, 1)
                        new_booster:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                    return true end
                }))
            return true end
        }))
    end
end

return jokerInfo