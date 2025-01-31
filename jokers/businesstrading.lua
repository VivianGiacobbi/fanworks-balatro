local jokerInfo = {
    name = 'Business Trading Card',
    config = {
        extra = {
            dollars = 6,
            destroy = 1,
        },
        destroyed_card = nil
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    width = 178,
    height = 238,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist15", set = "Other"}
    return { vars = {card.ability.extra.dollars, G.GAME.probabilities.normal, card.ability.extra.destroy} }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_btc" })
end

function jokerInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center.scale = {x=self.width,y=self.height}
        card.children.center.scale_mag = math.min(self.width/card.children.center.T.w,self.height/card.children.center.T.h)
        card.children.center:reset()
    end
end

function jokerInfo.calculate(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint and G.GAME.current_round.hands_played == 0 then
        local allfaces = true
        for k, v in ipairs(context.full_hand) do
            if not v:is_face() then
                allfaces = false
            end
        end
        if allfaces then
            ease_dollars(card.ability.extra.dollars)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$') .. card.ability.extra.dollars, colour = G.C.MONEY})
            if pseudorandom('businesstrading') < G.GAME.probabilities.normal / 3 then
                card.ability.destroyed_card = pseudorandom('businesstrading_1', 1, #context.full_hand)
            end
        end
    end
    if context.destroying_card and not context.blueprint and card.ability.destroyed_card then
        context.destroying_card = card.ability.destroyed_card
        card.ability.destroyed_card = nil
        return true
    end
end

return jokerInfo