-- simple hook copying most of the start_dissolve function to add an extra joker destroyed hook
Card.start_dissolve = function(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    local dissolve_time = 0.7*(dissolve_time_fac or 1)
    self.dissolve = 0
    self.dissolve_colours = dissolve_colours
        or {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY}
    if not no_juice then self:juice_up() end
    local childParts = Particles(0, 0, 0,0, {
        timer_type = 'TOTAL',
        timer = 0.01*dissolve_time,
        scale = 0.1,
        speed = 2,
        lifespan = 0.7*dissolve_time,
        attach = self,
        colours = self.dissolve_colours,
        fill = true
    })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  0.7*dissolve_time,
        func = (function() childParts:fade(0.3*dissolve_time) return true end)
    }))
    if not silent then 
        G.E_MANAGER:add_event(Event({
            blockable = false,
            func = (function()
                    play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                    play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        ref_table = self,
        ref_value = 'dissolve',
        ease_to = 1,
        delay =  1*dissolve_time,
        func = (function(t) return t end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  1.05*dissolve_time,
        func = (function() self:remove() return true end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  1.051*dissolve_time,
    }))

    if self.ability.set == 'Joker' then
        eval_card(self, {cardarea = G.jokers, joker_destroyed = true, removed = self})
    end
end

Card.get_chip_mult = function(self)
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    if self.ability.effect == "Lucky Card" then 
        if not G.GAME.lucky_cancels and pseudorandom('lucky_mult') < G.GAME.probabilities.normal/5 then
            self.lucky_trigger = true
            return self.ability.mult
        else
            return 0
        end
    else  
        return self.ability.mult
    end
end

Card.get_p_dollars = function(self)
    if self.debuff then return 0 end
    local ret = 0
    if self.seal == 'Gold' then
        ret = ret +  3
    end
    if self.ability.p_dollars > 0 then
        if self.ability.effect == "Lucky Card" then 
            if not G.GAME.lucky_cancels and pseudorandom('lucky_money') < G.GAME.probabilities.normal/15 then
                self.lucky_trigger = true
                ret = ret + self.ability.p_dollars
            end
        else 
            ret = ret + self.ability.p_dollars
        end
    end
    if ret > 0 then 
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + ret
        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
    end
    return ret
end