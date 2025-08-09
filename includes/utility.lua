function FnwkRandomSuitOrderCall(f, ...)
	local suit_buffer_copy = copy_table(SMODS.Suit.obj_buffer)
    local nominals_list = {}

    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        nominals_list[i] = SMODS.Suits[v].suit_nominal
    end

    -- correctly seeded suit order randomization
    math.randomseed((pseudohash('fnwk_multimedia_shuffle'..(G.GAME.pseudorandom.seed or '')) + (G.GAME.pseudorandom.hashed_seed or 0))/2)
    for i = #suit_buffer_copy, 2, -1 do
		local j = math.random(i)
        local key1 = SMODS.Suit.obj_buffer[i]
        local key2 = SMODS.Suit.obj_buffer[j]
		SMODS.Suit.obj_buffer[i], SMODS.Suit.obj_buffer[j] = key2, key1
	end

    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        SMODS.Suits[v].suit_nominal = nominals_list[i]
    end

    local old_suit_nominals = {}
    for i, v in ipairs(G.I.CARD) do
        if v.playing_card then
            old_suit_nominals[i] = {
                current = v.base.suit_nominal,
                original = v.base.suit_nominal_original
            }
            v.base.suit_nominal = SMODS.Suits[v.base.suit].suit_nominal
            v.base.suit_nominal_original = v.base.suit_nominal
        end
    end

    local ret = {f(...)}

    -- return the old values
    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        SMODS.Suit.obj_buffer[i] = suit_buffer_copy[i]
        SMODS.Suits[SMODS.Suit.obj_buffer[i]].suit_nominal = nominals_list[i]
    end

    for i, v in ipairs(G.I.CARD) do
        if v.playing_card then
            v.base.suit_nominal = old_suit_nominals[i].current
            v.base.suit_nominal_original = old_suit_nominals[i].original
        end
    end

	return unpack(ret)
end

function FnwkReviveEffect(revive_card)
    G.E_MANAGER:add_event(Event({
        blockable = false,
        trigger = 'after', 
        func = function()
            revive_card.ability.make_vortex = true
            
            local explode_time = 1.3*(0.6 or 1)*(math.sqrt(G.SETTINGS.GAMESPEED))
            revive_card.dissolve = 0
            revive_card.dissolve_colours = {G.C.WHITE}

            local start_time = G.TIMERS.TOTAL
            local percent = 0
            play_sound('explosion_buildup1')
            revive_card.juice = {
                scale = 0,
                r = 0,
                handled_elsewhere = true,
                start_time = start_time,
                end_time = start_time + explode_time
            }

            local particles = Particles(0, 0, 0, 0, {
                timer_type = 'TOTAL',
                timer = 0.01*explode_time,
                scale = 0.2,
                speed = 2,
                lifespan = 0.2*explode_time,
                attach = revive_card,
                colours = revive_card.dissolve_colours,
                fill = true
            })

            G.E_MANAGER:add_event(Event({
                blockable = false,
                func = (function()
                        if revive_card.juice then 
                            percent = (G.TIMERS.TOTAL - start_time)/explode_time
                            revive_card.juice.r = 0.05*(math.sin(5*G.TIMERS.TOTAL) + math.cos(0.33 + 41.15332*G.TIMERS.TOTAL) + math.cos(67.12*G.TIMERS.TOTAL))*percent
                            revive_card.juice.scale = percent*0.15
                        end
                        if G.TIMERS.TOTAL - start_time > 1.5*explode_time then return true end
                    end)
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blockable = false,
                ref_table = revive_card,
                ref_value = 'dissolve',
                ease_to = 0.3,
                delay =  0.9*explode_time,
                func = (function(t) return t end)
            }))

            G.E_MANAGER:add_event(Event({
                blockable = false,
                delay = 1.6*explode_time,
                func = (function()
                    if G.TIMERS.TOTAL - start_time > 1.55*explode_time then
                        revive_card.dissolve = 0
                        percent = 0
                        revive_card.juice = {
                            scale = 0,
                            r = 0,
                            handled_elsewhere = true,
                            start_time = start_time,
                            end_time = G.TIMERS.TOTAL
                        }
                        return true
                    end
                end)
            }))
            particles:fade()

            G.E_MANAGER:add_event(Event({
                blockable = false,
                trigger = 'after',
                delay = 1.2,
                func = function()
                    revive_card.ability.make_vortex = nil
                    return true
                end
            }))
            card_eval_status_text(revive_card, 'extra', nil, nil, nil, {
                message = localize('k_revived'),
                colour = G.C.DARK_EDITION,
                sound = 'negative',
                delay = 1.25
            })
            return true
        end
    }))
end