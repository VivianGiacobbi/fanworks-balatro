CardArea.draw_card_from = function(self, area, stay_flipped, discarded_only)
    if area:is(CardArea) then
        if #self.cards < self.config.card_limit or self == G.deck or self == G.hand then
            local card = area:remove_card(nil, discarded_only)
            if card then
                if area == G.discard then
                    card.T.r = 0
                end
                for j=1, #G.jokers.cards do
                    eval_card(G.jokers.cards[j], {cardarea = G.jokers, pre_draw = true, drawn = card})
                end
                local stay_flipped = (G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(self, card)) or card.joker_force_facedown
                if (self == G.hand) and G.GAME.modifiers.flipped_cards then
                    if pseudorandom(pseudoseed('flipped_card')) < 1/G.GAME.modifiers.flipped_cards then
                        stay_flipped = true
                    end
                end
                self:emplace(card, nil, stay_flipped)
                return true
            end
        end
    end
end

CardArea.emplace = function(self, card, location, stay_flipped)
    if location == 'front' or self.config.type == 'deck' then 
        table.insert(self.cards, 1, card)
    else
        self.cards[#self.cards+1] = card
    end
    if card.facing == 'back' and self.config.type ~= 'discard' and self.config.type ~= 'deck' and not stay_flipped and not card.joker_force_facedown then
        card:flip()
    end
    if self == G.hand and stay_flipped and not card.joker_force_facedown then 
        card.ability.wheel_flipped = true
    end

    card.joker_force_facedown = nil

    if #self.cards > self.config.card_limit then
        if self == G.deck then
            self.config.card_limit = #self.cards
        end
    end
    
    card:set_card_area(self)
    self:set_ranks()
    self:align_cards()

    if self == G.jokers then
        local joker_tally = 0
        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].ability.set == 'Joker' then joker_tally = joker_tally + 1 end
        end
        if joker_tally > G.GAME.max_jokers then G.GAME.max_jokers = joker_tally end
        check_for_unlock({type = 'modify_jokers'}) 
    end
    if self == G.deck then check_for_unlock({type = 'modify_deck', deck = self}) end
end