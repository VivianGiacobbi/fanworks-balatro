local consumInfo = {
    name = 'Disturbia',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FEFE9FDC', 'FEED1CDC' },
        extra = {
            target_card = nil,
            timer = 0,
            timer_max = 3
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'Pianolote',
    programmer = 'Vivian Giacobbi',
    blueprint_compat = false,
}

local function replace_return_messages(ret_table, replace_target, replace_card)
    if type(ret_table) ~= 'table' then return end

    local recur_tbl = ret_table
    repeat
        recur_tbl.message_card = (recur_tbl.message_card == replace_target) and replace_card or recur_tbl.message_card
        recur_tbl.juice_card = (recur_tbl.juice_card == replace_target) and replace_card or recur_tbl.juice_card
        recur_tbl.card = (recur_tbl.card == replace_target) and replace_card or recur_tbl.card
        recur_tbl.focus = (recur_tbl.focus == replace_target) and replace_card or recur_tbl.focus
        recur_tbl = recur_tbl.extra
    until recur_tbl == nil
end

function consumInfo.load(self, card, card_table, other_card)
    if card_table.ability.extra.target_card then
        if not G.jokers then
            card_table.ability.extra.target_card = nil
        end

        local find_target = nil
        for _, v in ipairs(G.jokers.cards) do
            if v.unique_val == card_table.ability.extra.target_card.unique_val then
                find_target = v
                break
            end
        end

        if not find_target then return end

        find_target.fnwk_disturbia_joker = card_table
        find_target.states.visible = false
        card_table.ability.fnwk_disturbia_fake = find_target
        card_table.ability.name = find_target.ability.name or find_target.center.key
        card:set_cost()
    end
end

function consumInfo.add_to_deck(self, card, from_debuff)
    if card.ability.extra.target_card then
        return card.ability.fnwk_disturbia_fake:add_to_deck_disturbia(from_debuff, true)
    end
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    if card.ability.extra.target_card then
        if from_debuff then
            return card.ability.fnwk_disturbia_fake:remove_from_deck_disturbia(from_debuff, true)
        end

        card.ability.fnwk_disturbia_fake:remove()
        card.ability.fnwk_disturbia_fake = nil
    end
end

function consumInfo.calc_dollar_bonus(self, card)
    if card.ability.extra.target_card then
       return card.ability.fnwk_disturbia_fake:calculate_dollar_bonus_disturbia(true)
    end
end

function consumInfo.update(self, card, dt)
    if card.ability.extra.target_card then
        local ret = card.ability.fnwk_disturbia_fake:update(dt)
        card.debuff = card.ability.fnwk_disturbia_fake.debuff
        return ret
    end
end

function consumInfo.calculate(self, card, context)
    if not context.blueprint or context.retrigger_joker then
        if context.before or context.setting_blind then
            card.ability.fnwk_disturbia_played_hand = true
        end

        if context.hand_drawn and card.ability.fnwk_disturbia_played_hand then
            card.ability.fnwk_disturbia_played_hand = nil

            if not G.jokers or G.jokers.config.visible_card_count < 1 then
                if card.ability.fnwk_disturbia_fake then
                    card.ability.fnwk_disturbia_fake:remove()
                    card.ability.fnwk_disturbia_fake = nil
                    card.ability.extra.target_card = nil
                end
                card:set_cost()
                return
            end

            local jokers = {}
            for _, v in ipairs(G.jokers.cards) do
                if not v.fnwk_disturbia_joker then
                    jokers[#jokers+1] = v
                end
            end

            local copy_target = pseudorandom_element(jokers, pseudoseed('fnwk_disturbia'))
            if card.ability.extra.target_card and copy_target.unique_val == card.ability.extra.target_card.unique_val then
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = card.ability.name,
                    colour = G.C.STAND,
                    card = card
                })
                return
            else
                if card.ability.fnwk_disturbia_fake then
                    card.ability.fnwk_disturbia_fake:remove()
                    card.ability.fnwk_disturbia_fake = nil
                    card.ability.extra.target_card = nil
                end
            end

            local new_fake = copy_card(copy_target)
            new_fake.states.visible = false
            new_fake.fnwk_disturbia_joker = card

            new_fake:add_to_deck()
            G.jokers:emplace(new_fake)
            card.ability.fnwk_disturbia_fake = new_fake

            card.ability.extra.target_card = {
                key = copy_target.config.center.key,
                unique_val = copy_target.unique_val
            }
            card.ability.name = localize{type = 'name_text', key = copy_target.config.center.key, set = copy_target.ability.set}
            card:set_cost()

            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = card.ability.name,
                colour = G.C.STAND,
                card = card
            })
        end
    end

    if card.ability.extra.target_card then
        local ret, triggered = card.ability.fnwk_disturbia_fake:calculate_joker(context)

        if ret then replace_return_messages(ret, card.ability.fnwk_disturbia_fake, card) end
        if triggered then replace_return_messages(triggered, card.ability.fnwk_disturbia_fake, card) end

        return ret, triggered
    end
end

return consumInfo