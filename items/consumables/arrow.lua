local consumInfo = {
    name = 'The Arrow',
    set = "Tarot",
    cost = 4,
    alerted = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    if G.GAME.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME.max_stands or 1, (card.area.config.collection and localize('k_stand')) or (G.GAME.max_stands > 1 and localize('b_stand_cards') or localize('k_stand')) }}
    end
    return {}
end

local get_replaceable_stand = function()
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "Stand" then
            return v
        end
    end
    return nil
end

local multiple_stands = function()
    local count = 0
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "Stand" then
            count = count+1
        end
    end
    if count > 1 then return true else return false end
end

local replace_stand = function()
    local card = get_replaceable_stand()
    local new_stand = pseudorandom_element(get_current_pool('Stand', nil, nil, 'arrow'), pseudoseed('arrowreplace'))
    card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_stand.atlas], new_stand.pos)
    card.children.center.states.hover = card.states.hover
    card.children.center.states.click = card.states.click
    card.children.center.states.drag = card.states.drag
    card.children.center.states.collide.can = false
    card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
    card:set_ability(new_stand )
    card:set_cost()
    if new_stand.soul_pos then
        card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_stand.atlas], new_stand.soul_pos)
        card.children.floating_sprite.role.draw_major = card
        card.children.floating_sprite.states.hover.can = false
        card.children.floating_sprite.states.click.can = false
    end
    if not card.edition then
        card:juice_up()
        play_sound('generic1')
    else
        card:juice_up(1, 0.5)
        if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
        if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
        if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
        if card.edition.negative then play_sound('negative', 1.5, 0.4) end
    end
end

local new_stand = function()
    if G.GAME.unlimited_stands then
        if G.consumeables.config.card_limit > #G.consumeables.cards then
            local card = create_card('Stand', G.consumeables, nil, nil, nil, nil, nil, 'arrow')
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:juice_up(0.3, 0.5)
        else
            replace_stand()
        end
    else
        if G.consumeables.config.card_limit > #G.consumeables.cards then
            local card = create_card('Stand', G.consumeables, nil, nil, nil, nil, nil, 'arrow')
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:juice_up(0.3, 0.5)
        else
            if get_replaceable_stand() ~= nil then
                replace_stand()
            end
        end
    end
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        new_stand()
        return true
    end }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if G.consumeables.config.card_limit > #G.consumeables.cards-(card.area == G.consumeables and 1 or 0) then
        return true
    else
        if get_replaceable_stand() ~= nil then
            return true
        end
    end
    return true
end

return consumInfo