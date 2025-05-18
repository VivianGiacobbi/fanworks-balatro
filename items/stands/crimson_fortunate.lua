local consumInfo = {
    key = 'c_fnwk_crimson_fortunate',
    name = 'Fortunate Son',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF658BDC', 'FFE6AADC' },
        extra = {
            mult = 30,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'crimson',
    blueprint_compat = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    local main_end = nil
    if G.GAME.fnwk_last_upgraded_hand then
        local nodes = {}
        local total = 0
        local count = 0
        for _, key in ipairs(G.handlist) do
            total = total + 1
            if G.GAME.fnwk_last_upgraded_hand[key] then count = count + 1 end
        end

        local colour = G.C.SECONDARY_SET.Planet
        if count == #SMODS.PokerHand.obj_buffer then
            colour = G.C.SECONDARY_SET.Spectral
            
            nodes[1] = {
                n=G.UIT.T,
                config={text = ' '..localize('k_all_hands')..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true
            }}
        else
            local dyn_nodes = {}
            for _, key in ipairs(G.handlist) do
                if G.GAME.fnwk_last_upgraded_hand[key] then
                    dyn_nodes[#dyn_nodes+1] = {string = ' '..localize(key, 'poker_hands')..' ', colour = G.C.UI.TEXT_LIGHT}
                end             
            end

            nodes[1] = {
                n=G.UIT.O, config={object = DynaText({
                    string = dyn_nodes,
                    colours = {G.C.UI.TEXT_DARK},
                    pop_in_rate = 1.5*G.SPEEDFACTOR,
                    silent = true,
                    pop_delay = 1.2,
                    scale = 0.3,
                    min_cycle_time = 0.3,
                })}
            }
        end

        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.05}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes=nodes}
            }}
        }
    end
    
    return { 
        vars = {
            card.ability.extra.mult,
        },
        main_end = main_end
    }
end

function consumInfo.calculate(self, card, context)
    if not G.GAME.fnwk_last_upgraded_hand or card.debuff then return end

    if context.joker_main and G.GAME.fnwk_last_upgraded_hand[context.scoring_name] then
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(context.blueprint_card or card, 0.5)
            end,
            extra = {
                mult = card.ability.extra.mult,
            }
        }
    end
end

return consumInfo