local consumInfo = {
    name = 'Tragic Kingdom',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            contain_rank = '8',
            rank_mod = -1
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'last',
		},
        custom_color = 'last',
    },
    artist = 'gote',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.contain_rank, -card.ability.extra.rank_mod }}
end

function consumInfo.calculate(self, card, context)
        -- record flip cards and do initial flip
    if not context.before then
        return
    end

    for i, v in ipairs(context.full_hand) do
        if v.base.value == card.ability.extra.contain_rank then
            break
        end

        if i == #context.full_hand then
            return
        end
    end

    local change_cards = {}
    for _, v in ipairs(context.full_hand) do     
        if v.base.value ~= card.ability.extra.contain_rank then
            change_cards[#change_cards+1] = v
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v:flip()
                    play_sound('card1')
                    v:juice_up(0.3, 0.3)
                    return true 
                end 
            }))
        end
    end

    if #change_cards < 1 then return end

    ArrowAPI.stands.flare_aura(card, 0.5)
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_tragic_rankdown'), colour = G.C.SUITS[target_key]})

    for _, v in ipairs(change_cards) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                SMODS.modify_rank(v, card.ability.extra.rank_mod)
                return true 
            end
        }))
    end
    
    -- do flip back over
    for _, v in ipairs(change_cards) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.25,
            func = function() 
                v:flip()
                play_sound('tarot2', 1, 0.6)
                v:juice_up(0.3, 0.3)
                return true 
            end 
        }))
    end
end

return consumInfo