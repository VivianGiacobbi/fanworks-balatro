local consumInfo = {
    key = 'c_fnwk_bluebolt_chemical',
    name = 'My Chemical Romance',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'EAB9E0DC', 'EF5375DC' },
        extra = {
            stored_enhance = nil,
            stored_seal = nil,
            stored_edition = nil
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
    artist = 'coop',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    local num_display = (card.ability.extra.stored_enhance and 1 or 0) + (card.ability.extra.stored_seal and 1 or 0) + (card.ability.extra.stored_edition and 1 or 0)
    
    local stored_enhance = card.ability.extra.stored_enhance and localize({type = 'name_text', key = card.ability.extra.stored_enhance, set = 'Enhanced'}) or nil
    if stored_enhance and ArrowAPI.string.contains(stored_enhance, ' Card') then stored_enhance = string.sub(stored_enhance, 1, #stored_enhance - 5) end
    local stored_edition = card.ability.extra.stored_edition and localize({type = 'name_text', key = card.ability.extra.stored_edition, set = 'Edition'}) or nil

    local stored_seal = nil
    if card.ability.extra.stored_seal then
        local seal_key = G.localization.descriptions.Other[card.ability.extra.stored_seal] and card.ability.extra.stored_seal or (string.lower(card.ability.extra.stored_seal)..'_seal')
        stored_seal = card.ability.extra.stored_seal and localize({type = 'name_text', key = seal_key, set = 'Other'}) or nil
    end
    
    return { vars = {
            stored_enhance or (num_display == 0 and 'those') or '',
            stored_enhance and (num_display > 2 and ', ' or (num_display == 2 and ' and '..(stored_seal and 'a ' or '') or '')) or '',
            stored_edition or '',
            stored_edition and (((num_display > 2) and ', and')) or ((num_display == 1 and stored_seal) and 'a ' or '')  or '',
            stored_seal or (num_display == 0 and ' modifiers' or ''),
            num_display > 2 and 'a ' or ''
        },
        key = self.key..(num_display > 2 and '_longver' or '')
    }
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.retrigger_joker then return end

    if context.pre_discard and G.GAME.current_round.discards_used == 0 and #context.full_hand == 1 then
        local change_card = context.full_hand[1]
        card.ability.extra.stored_enhance = change_card.config.center.key ~= 'c_base' and change_card.config.center.key or nil
        card.ability.extra.stored_seal = change_card.seal or nil
        card.ability.extra.stored_edition = change_card.edition and change_card.edition.key or nil        

        if card.ability.extra.stored_enhance or card.ability.extra.stored_seal or card.ability.extra.stored_edition then
            card.ability.extra.mcr_transmute_ready = true

            return {
                func = function()
                    ArrowAPI.stands.flare_aura(card, 0.5)
                    change_card:set_ability('c_base')
                    change_card:set_seal(nil, true, true)
                    change_card:set_edition(nil, true, true)
                    change_card:juice_up()
                end,
                extra = {
                    message = localize('k_mcr_bubbled'),
                    colour = G.C.RED,
                    func = function()
                        local eval = function() return card.ability.extra.mcr_transmute_ready == true and not G.RESET_JIGGLES end
                        juice_card_until(card, eval, true)
                    end
                }
            }
        end
    end

    if context.before and card.ability.extra.mcr_transmute_ready then
        if #context.full_hand > 1 then
            card.ability.extra.mcr_transmute_ready = nil
            return {
                message = localize('k_mcr_popped'),
                colour = G.C.RED,
            }
        end

        local change_card = context.full_hand[1]
        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)

                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    -- apply all saved modifications
                    if card.ability.extra.stored_enhance then
                        change_card:set_ability(G.P_CENTERS[card.ability.extra.stored_enhance])
                        card.ability.extra.stored_enhance = nil
                    end
            
                    if card.ability.extra.stored_seal then
                        change_card:set_seal(card.ability.extra.stored_seal, true)
                        card.ability.extra.stored_seal = nil
                    end
            
                    if card.ability.extra.stored_edition then
                        change_card:set_edition(card.ability.extra.stored_edition, true)
                        card.ability.extra.stored_edition = nil
                    end

                    change_card:juice_up(0.3, 0.5)
                    card.ability.extra.mcr_transmute_ready = nil
                    return true end
                }))

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_mcr_transmuted'), colour = G.C.RED})
            end,
        }
    end
end

return consumInfo