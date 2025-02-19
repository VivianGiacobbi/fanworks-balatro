

local base_get_id = Card.get_id
function Card:get_id()
    local id = base_get_id(self)
    if next(find_joker('Bone Crossed Joker')) and (id == 11 or id == 13) then
        return 12
    end
    return id
end

function Card:add_quip(text_key, align, loc_vars, extra)
    if self.children.quip then 
        self.children.quip:remove()     
    end

    self.children.quip = UIBox{
        definition = G.UIDEF.jok_speech_bubble(text_key, loc_vars, extra),
        config = { align = align or 'bm', offset = { x=0, y=0 }, parent = self}
    }
    self.children.quip:set_role{
        major = self,
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Weak',
    }
    self.children.quip.states.visible = false
end

function Card:remove_quip()
    if self.children.quip then 
        self.children.quip:remove()
        self.children.quip = nil 
    end
end

function Card:say_quip(iter, not_first, def_speed)
    -- cancel this quip once the iteration ends
    if iter <= 0 then 
        self.talking = false
        return 
    end
    
    local speed = (not def_speed and G.SPEEDFACTOR) or 1
    local delay_mult = def_speed and G.SPEEDFACTOR or 1
    self.talking = true

    if not not_first then 
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1 * delay_mult,
            func = function()
                if self.children.quip then 
                    self.children.quip.states.visible = true
                end
                self:say_quip(iter, true, def_speed)
            return true
        end}))
        return
    end

    local new_said = math.random(1, 10)
    if self.last_said and new_said >= self.last_said then
        new_said = new_said + 1
    end
    self.last_said = new_said
    play_sound('voice'..new_said, speed * (math.random() * 0.2 + 1), 0.5)

    self:juice_up()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        blocking = false,
        delay = 0.13 * delay_mult,
        func = function()
            self:say_quip(iter-1, true, def_speed)
        return true  
    end}), 'tutorial')
end