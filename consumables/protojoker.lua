local consumInfo = {
    name = 'Protojoker',
    set = "Spectral",
    cost = 4,
    alerted = true,
    hidden = true,
    soul_rate = 0.003,
    soul_set = "Tarot",
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist25", set = "Other"}
    return {}
end

function consumInfo.use(self, card, area, copier)
    check_for_unlock({ type = "activate_protojoker" })
    for i = 1, #G.jokers.cards do
        if containsString(G.jokers.cards[i].ability.name, "Joker") and not G.jokers.cards[i].getting_sliced then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                -- Based on code from Ortalab
                local _center = G.P_CENTERS['j_fnwk_chad']
                G.jokers.cards[i].children.center = Sprite(G.jokers.cards[i].T.x, G.jokers.cards[i].T.y, G.jokers.cards[i].T.w, G.jokers.cards[i].T.h, G.ASSET_ATLAS[_center.atlas or 'j_fnwk_chad'], _center.pos)
                G.jokers.cards[i].children.center.states.hover = G.jokers.cards[i].states.hover
                G.jokers.cards[i].children.center.states.click = G.jokers.cards[i].states.click
                G.jokers.cards[i].children.center.states.drag = G.jokers.cards[i].states.drag
                G.jokers.cards[i].children.center.states.collide.can = false
                G.jokers.cards[i].children.center:set_role({major = G.jokers.cards[i], role_type = 'Glued', draw_major = G.jokers.cards[i]})
                G.jokers.cards[i]:set_ability(_center)
                G.jokers.cards[i]:set_cost()
                if not G.jokers.cards[i].edition then
                    G.jokers.cards[i]:juice_up()
                    play_sound('generic1')
                else
                    G.jokers.cards[i]:juice_up(1, 0.5)
                    if G.jokers.cards[i].edition.foil then play_sound('foil1', 1.2, 0.4) end
                    if G.jokers.cards[i].edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
                    if G.jokers.cards[i].edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
                    if G.jokers.cards[i].edition.negative then play_sound('negative', 1.5, 0.4) end
                end
                return true end
            }))
        end
    end
end

function consumInfo.draw(self,card,layer)
    if not G.chadley_scarf then
        G.chadley_scarf = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["fnwk_protojoker"], { x = 1, y = 0 })
    end
    local scale_mod = 0.05 + 0.05*math.sin(1.8*G.TIMERS.REAL) + 0.07*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
    local rotate_mod = 0.1*math.sin(1.219*G.TIMERS.REAL) + 0.07*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

    G.chadley_scarf.role.draw_major = card
    G.chadley_scarf:draw_shader('dissolve',0, nil, nil, card.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
    G.chadley_scarf:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
end

function consumInfo.can_use(self, card)
    for i = 1, #G.jokers.cards do
        if containsString(G.jokers.cards[i].ability.name, "Joker") then
            return true
        end
    end
end


return consumInfo