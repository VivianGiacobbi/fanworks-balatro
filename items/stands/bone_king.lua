local consumInfo = {
    key = 'c_fnwk_bone_king',
    name = 'KING & COUNTRY',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'CC2CDDFDC', '9C403ADC' },
        evolve_key = 'c_fnwk_bone_king_farewell',
        extra = {
            evolve_sub = 7
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bone',
		},
		custom_color = 'bone',
	},
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {G.GAME.starting_deck_size - card.ability.extra.evolve_sub}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end
    
    if not context.blueprint and not context.retrigger_joker and context.destroy_card and context.cardarea == G.play and SMODS.has_enhancement(context.destroy_card, 'm_steel') and SMODS.in_scoring(context.destroy_card, context.scoring_hand) then
        context.destroy_card.fnwk_removed_by_kingandcountry = true
        return {
            remove = true
        }
    end

    if not context.blueprint and not context.retrigger_joker and context.remove_playing_cards and not context.scoring_hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if #G.playing_cards <= (G.GAME.starting_deck_size - card.ability.extra.evolve_sub) then
                    ArrowAPI.stands.evolve_stand(card)
                end

                return true 
            end 
        }))
    end

    -- the after handler covers evolving the stand for cards destroyed during main scoring
    -- in order to let K&C's ability play out, otherwise it would evolve before the hand finishes
    if not context.blueprint and not context.retrigger_joker and context.after then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if #G.playing_cards <= (G.GAME.starting_deck_size - card.ability.extra.evolve_sub) then
                    ArrowAPI.stands.evolve_stand(card)
                end
                return true 
            end 
        }))
    end

    if context.playing_card_removed and context.individual and context.removed.fnwk_removed_by_kingandcountry then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.48)
            end,
            delay = 0.75,
            extra = {
                func = function()
                    local juice_card = context.blueprint_card or card
                    local available_indices = {}
                    for i, hand_card in ipairs(G.hand.cards) do 
                        if hand_card.config.center.key ~= 'm_steel' then
                            available_indices[#available_indices+1] = i
                        end
                    end
        
                    if #available_indices == 0 then return end
                    local rand_idx = pseudorandom_element(available_indices, pseudoseed('kingandcountry'))
                    local rand_card = G.hand.cards[rand_idx]
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            juice_card:juice_up()
                            rand_card:flip()
                            rand_card:juice_up(0.3, 0.3)
                            play_sound('card1')
                            return true 
                        end 
                    }))

                    if not rand_card then return end
        
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            rand_card:set_ability('m_steel')
                            return true 
                        end
                    }))

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            play_sound('tarot2', 1, 0.6)
                            rand_card:flip()
                            rand_card:juice_up(0.3, 0.3)
                            return true 
                        end 
                    }))
                end
            }
        }
    end
end

return consumInfo