local consumInfo = {
    name = 'Moody Blues',
    set = "Stand",
    cost = 4,
    config = {
        preview = 5
    },
    alerted = true,
    hasSoul = true,
}

-- Modified Code from Jimbo's Pack
local create_tohth_cardarea = function(card, cards)
    if not tohth_cards then
        tohth_cards = CardArea(
                0,
                0,
                (math.min(card.ability.preview,#cards) * G.CARD_W)*0.5,
                (G.CARD_H*1.5)*0.5,
                {card_limit = #cards, type = 'title', highlight_limit = 0, card_w = G.CARD_W*0.7})
    end
    for i = 1, #cards do
        local card = copy_card(cards[i], nil, nil, G.playing_card)
        tohth_cards:emplace(card)
    end
    return {
        n=G.UIT.R, config = {
            align = "cm", colour = G.C.CLEAR, r = 0.0
        },
        nodes={
            {
                n=G.UIT.C,
                config = {align = "cm", padding = 0.2},
                nodes={
                    {n=G.UIT.O, config = {padding = 0.2, object = tohth_cards}},
                }
            }
        },
    }
end

function consumInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if card.config.center.discovered then
        -- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
        full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card)}
    if G.deck and not card.area.config.collection then
        local cards = {}
        for i = 1, card.ability.preview do
            if G.deck.cards[i] then
                cards[#cards+1]=G.deck.cards[#G.deck.cards-(i-1)]
            end
        end
        local cardarea = create_tohth_cardarea(card, cards)
        desc_nodes[#desc_nodes+1] = {{
            n=G.UIT.R, config = {
                align = "cm", colour = G.C.CLEAR, r = 0.0
            },
            nodes={
                {
                    n=G.UIT.C,
                    config = {align = "cm", padding = 0.1},
                    nodes={
                        {n=G.UIT.T, config={text = '/', scale = 0.15, colour = G.C.CLEAR}},
                    }
                }
            },
        }}
        desc_nodes[#desc_nodes+1] = {cardarea}
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo