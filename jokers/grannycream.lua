local jokerInfo = {
    name = 'Granny Cream',
    config = {
        extra = {
            chip_goal = 150,
            chip_pool = 500,
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    streamer = "other",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist22", set = "Other"}
    return { vars = {card.ability.extra.chip_goal, card.ability.extra.chip_pool } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_grannycream" })
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        if hand_chips < card.ability.extra.chip_goal then
            local spent_chips = card.ability.extra.chip_goal - hand_chips
            if spent_chips > card.ability.extra.chip_pool then
                spent_chips = card.ability.extra.chip_pool
            end
            if not next(SMODS.find_card('j_fnwk_bunji')) then
                card.ability.extra.chip_pool = card.ability.extra.chip_pool - spent_chips
            end
            return {
                message = localize{type='variable',key='a_chips',vars={spent_chips}},
                chip_mod = spent_chips
            }
        end
    end
    if context.cardarea == G.jokers and context.after and not (card.debuff or context.blueprint or context.repetition or context.individual or context.before) then
        if card.ability.extra.chip_pool == 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1, blockable = false,
                             func = function()
                                 G.jokers:remove_card(card)
                                 card:remove()
                                 card = nil
                                 return true
                             end
                    }))
                    return true
                end
            }))
            return {
                message = localize('k_sipped_ex'),
                colour = G.C.CHIPS
            }
        end
    end
end

local upd = Game.update
fnwk_grannycream_dt = 0
function Game:update(dt)
    upd(self,dt)
    fnwk_grannycream_dt = fnwk_grannycream_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_fnwk_grannycream and fnwk_grannycream_dt > 0.1 then
        fnwk_grannycream_dt = 0
        local obj = G.P_CENTERS.j_fnwk_grannycream
        if (obj.pos.x == 8 and obj.pos.y == 3) then
            obj.pos.x = 0
            obj.pos.y = 0
        elseif (obj.pos.x < 8) then obj.pos.x = obj.pos.x + 1
        elseif (obj.pos.y < 3) then
            obj.pos.x = 0
            obj.pos.y = obj.pos.y + 1
        end
    end

end

return jokerInfo