local consumInfo = {
    name = 'Fortunate Son',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF658BDC', 'FFE6AADC' },
        extra = {
            mult = 30,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'crimson',
		},
        custom_color = 'crimson',
    },
    artist = 'gar',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    local main_end = nil
    if G.GAME.arrow_last_upgraded_hand then
        local nodes = {}
        local list_hands = {}
        for k, _ in pairs(G.GAME.arrow_last_upgraded_hand) do
            list_hands[#list_hands+1] = k
        end

        local colour = G.C.SECONDARY_SET.Planet
        if #list_hands == #G.handlist then
            colour = G.C.SECONDARY_SET.Spectral
            
            nodes[1] = {
                n=G.UIT.T,
                config={text = ' '..localize('k_all_hands')..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}
            }
        elseif #list_hands > 0 then
            local dyn_nodes = {}
            for _, key in ipairs(list_hands) do
                if G.GAME.arrow_last_upgraded_hand[key] then
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

        if #nodes > 0 then
            main_end = {
                {n=G.UIT.C, config={align = "bm", padding = 0.05}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes=nodes}
                }}
            }
        end
    end

    return {
        vars = {
            card.ability.extra.mult,
        },
        main_end = main_end
    }
end

function consumInfo.calculate(self, card, context)
    if not G.GAME.arrow_last_upgraded_hand or card.debuff then return end

    if context.joker_main and G.GAME.arrow_last_upgraded_hand[context.scoring_name] then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                mult = card.ability.extra.mult,
                card = flare_card
            }
        }
    end
end

return consumInfo