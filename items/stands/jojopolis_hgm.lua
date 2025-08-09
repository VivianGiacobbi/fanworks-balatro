local consumInfo = {
    key = 'c_fnwk_jojopolis_hgm',
    name = 'Hurdy Gurdy Man',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC', },
        evolve_key = 'c_fnwk_jojopolis_hgm_cosmic',
        extra = {
            big_mod = 1,
            boss_mod = 2,
            evolve_num = 10,
        },
        fnwk_hgm_mod = 0
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jojopolis',
		},
        custom_color = 'jojopolis',
    },
    artist = 'gote',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.big_mod, card.ability.extra.boss_mod, card.ability.extra.evolve_num}}
end

function consumInfo.add_to_deck(self, card, from_debuff)
    local blind_type = nil
    if G.GAME.blind then
        blind_type = G.GAME.blind:get_type()
    end
	
	local mod = (blind_type == 'Boss' and card.ability.extra.boss_mod) or (blind_type == 'Big' and card.ability.extra.big_mod) or 0
	
    if mod > 0 then
        G.hand:change_size(mod)
        card.ability.fnwk_hgm_mod = card.ability.fnwk_hgm_mod + mod

        ArrowAPI.stands.flare_aura(card, 0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                card:juice_up()
                return true
            end
        }))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_handsize',vars={mod}}})
    end
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint or context.retrigger_joker then return end

    if context.setting_blind then
        local blind_type = G.GAME.blind:get_type()
        if blind_type ~= 'Big' and blind_type ~= 'Boss' then
            return
        end

        local mod = blind_type == 'Boss' and card.ability.extra.boss_mod or card.ability.extra.big_mod

        G.hand:change_size(mod)
        card.ability.fnwk_hgm_mod = card.ability.fnwk_hgm_mod + mod

        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)
            end,
            extra = {
                message = localize{type='variable',key='a_handsize',vars={mod}},
            }
        }
    end

    if context.end_of_round and context.main_eval and card.ability.fnwk_hgm_mod > 0 then
        local mod = card.ability.fnwk_hgm_mod
        G.hand:change_size(-mod)
        card.ability.fnwk_hgm_mod = 0

        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)
            end,
            extra = {
                message = localize{type='variable',key='a_handsize_minus',vars={mod}},
            }
        }
    end

    if context.fnwk_hand_upgraded then
        for k, _ in pairs(context.upgraded) do
            if G.GAME.hands[k].level >= card.ability.extra.evolve_num then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        ArrowAPI.stands.evolve_stand(card)
                        return true 
                    end 
                }))
                break;
            end
        end
    end
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    if card.ability.fnwk_hgm_mod > 0 then
        G.hand:change_size(-card.ability.fnwk_hgm_mod)
	    card.ability.fnwk_hgm_mod = 0
    end	
end

return consumInfo